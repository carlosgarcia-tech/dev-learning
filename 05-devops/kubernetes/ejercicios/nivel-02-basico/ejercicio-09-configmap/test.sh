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

# Validaciones específicas del ConfigMap
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

# Debe existir un ConfigMap
if 'ConfigMap' not in kinds:
    print("Falta un recurso ConfigMap")
    sys.exit(1)
cm = kinds['ConfigMap']

cm_name = cm.get('metadata', {}).get('name')
data = cm.get('data', {})
if not data:
    print("El ConfigMap debe tener claves en spec.data")
    sys.exit(1)
for key in ('LOG_LEVEL', 'ENTORNO'):
    if key not in data:
        print(f"El ConfigMap debe definir la clave '{key}'")
        sys.exit(1)
# Al menos una clave de tipo fichero (con extensión)
has_file_key = any('.' in k for k in data.keys())
if not has_file_key:
    print("El ConfigMap debe definir al menos una clave de tipo fichero (p. ej. config.yaml)")
    sys.exit(1)

# Debe existir un Pod
if 'Pod' not in kinds:
    print("Falta un recurso Pod")
    sys.exit(1)
pod = kinds['Pod']

containers = pod.get('spec', {}).get('containers', [])
if not containers:
    print("El Pod no tiene containers")
    sys.exit(1)
c = containers[0]

# Debe inyectar variables de entorno desde el ConfigMap
env = c.get('env', [])
ref_keys = set()
for e in env:
    ref = e.get('valueFrom', {}).get('configMapKeyRef', {})
    if ref.get('name') == cm_name:
        ref_keys.add(ref.get('key'))
for key in ('LOG_LEVEL', 'ENTORNO'):
    if key not in ref_keys:
        print(f"El Pod debe inyectar '{key}' desde configMapKeyRef del ConfigMap '{cm_name}'")
        sys.exit(1)

# Debe montar el ConfigMap como volumen
volumes = pod.get('spec', {}).get('volumes', [])
cm_vol = None
for v in volumes:
    if v.get('configMap', {}).get('name') == cm_name:
        cm_vol = v.get('name')
        break
if not cm_vol:
    print(f"El Pod debe montar el ConfigMap '{cm_name}' como volumen (volumes[].configMap.name)")
    sys.exit(1)

# El volumeMount debe referenciar el volumen
mounts = c.get('volumeMounts', [])
mount_names = [m.get('name') for m in mounts]
if cm_vol not in mount_names:
    print(f"El volumeMount del contenedor debe referenciar el volumen '{cm_vol}'")
    sys.exit(1)
PYEOF

# Validación opcional con cluster K8s
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  ns="ej09-$(date +%s | tail -c 6)"
  kubectl create namespace "$ns" >/dev/null 2>&1
  if kubectl apply -f "$YAML_DIR" -n "$ns" >/dev/null 2>&1; then
    kubectl get configmap app-config -n "$ns" >/dev/null 2>&1 || true
    kubectl get pod app -n "$ns" >/dev/null 2>&1 || true
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
  else
    kubectl delete namespace "$ns" >/dev/null 2>&1 || true
    fail "kubectl apply falló al aplicar los manifiestos"
  fi
fi

echo "OK Tests pasaron"
exit 0
