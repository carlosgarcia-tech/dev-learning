#!/usr/bin/env bash
# Nota: requiere un cluster K8s (kind/minikube) para validación completa; sin cluster valida los YAML.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

YAML_DIR="."
if ! ls *.yaml >/dev/null 2>&1; then
  YAML_DIR="solucion"
fi

fail() { echo "FAIL Tests fallaron"; echo "  $1"; exit 1; }

yaml_files=$(find "$YAML_DIR" -maxdepth 1 -name '*.yaml' -type f 2>/dev/null | sort)
if [ -z "$yaml_files" ]; then
  fail "No se encontraron archivos *.yaml en $YAML_DIR/"
fi

for f in $yaml_files; do
  python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null || fail "YAML inválido: $f"
done

python3 - "$YAML_DIR" <<'PYEOF' || exit 1
import sys, yaml, glob, os
yaml_dir = sys.argv[1]
files = sorted(glob.glob(os.path.join(yaml_dir, '*.yaml')))
for f in files:
    with open(f) as fh:
        for doc in yaml.safe_load_all(fh):
            if doc is None:
                continue
            for field in ('apiVersion', 'kind', 'metadata'):
                if field not in doc:
                    print(f"Falta '{field}' en {f}")
                    sys.exit(1)
            if 'name' not in doc.get('metadata', {}):
                print(f"Falta 'metadata.name' en {f}")
                sys.exit(1)
PYEOF

# Validaciones específicas del Service NodePort
python3 - "$YAML_DIR" <<'PYEOF' || exit 1
import sys, yaml, glob, os
yaml_dir = sys.argv[1]
files = sorted(glob.glob(os.path.join(yaml_dir, '*.yaml')))
docs = []
for f in files:
    with open(f) as fh:
        for doc in yaml.safe_load_all(fh):
            if doc is not None:
                docs.append(doc)

kinds = {d['kind']: d for d in docs}

# Debe existir un Deployment
if 'Deployment' not in kinds:
    print("Falta un recurso Deployment")
    sys.exit(1)
dep = kinds['Deployment']

replicas = dep.get('spec', {}).get('replicas', 1)
if replicas < 2:
    print("El Deployment debe tener al menos 2 réplicas")
    sys.exit(1)

# Debe existir un Service
if 'Service' not in kinds:
    print("Falta un recurso Service")
    sys.exit(1)
svc = kinds['Service']

# El Service debe ser tipo NodePort
svc_type = svc.get('spec', {}).get('type', 'ClusterIP')
if svc_type != 'NodePort':
    print(f"El Service debe ser tipo NodePort (encontrado: {svc_type})")
    sys.exit(1)

# Selector debe coincidir con las labels del pod
selector = svc.get('spec', {}).get('selector')
if not selector:
    print("El Service debe definir spec.selector")
    sys.exit(1)
pod_labels = dep.get('spec', {}).get('template', {}).get('metadata', {}).get('labels', {})
for k, v in selector.items():
    if pod_labels.get(k) != v:
        print(f"El selector del Service ({k}={v}) no coincide con las labels del pod")
        sys.exit(1)

# Debe definir nodePort en el rango 30000-32767
ports = svc.get('spec', {}).get('ports', [])
if not ports:
    print("El Service debe definir al menos un puerto en spec.ports")
    sys.exit(1)
np = ports[0].get('nodePort')
if np is None or not (30000 <= np <= 32767):
    print("El Service debe definir nodePort en el rango 30000-32767")
    sys.exit(1)
# port 80 y targetPort 80
if ports[0].get('port') != 80 or ports[0].get('targetPort') != 80:
    print("El Service debe exponer port 80 con targetPort 80")
    sys.exit(1)
PYEOF

# Validación opcional con cluster K8s
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  ns="ej08-$(date +%s | tail -c 6)"
  kubectl create namespace "$ns" >/dev/null 2>&1
  if kubectl apply -f "$YAML_DIR" -n "$ns" >/dev/null 2>&1; then
    kubectl get svc web -n "$ns" >/dev/null 2>&1 || true
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
  else
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
    fail "kubectl apply falló al aplicar los manifiestos"
  fi
fi

echo "OK Tests pasaron"
exit 0
