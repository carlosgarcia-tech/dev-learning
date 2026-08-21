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

# Validaciones específicas
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

# Debe existir un Service headless postgres
if 'Service' not in kinds:
    print("Falta el recurso Service")
    sys.exit(1)
svc = kinds['Service']
if svc.get('spec', {}).get('clusterIP') != 'None':
    print("Service: clusterIP debe ser 'None' (headless)")
    sys.exit(1)
sel = svc.get('spec', {}).get('selector', {})
if sel.get('app') != 'postgres':
    print("Service: el selector debe ser app=postgres")
    sys.exit(1)
ports = svc.get('spec', {}).get('ports', [])
if not any(p.get('port') == 5432 for p in ports):
    print("Service: debe exponer el puerto 5432")
    sys.exit(1)

# Debe existir un StatefulSet postgres
if 'StatefulSet' not in kinds:
    print("Falta el recurso StatefulSet")
    sys.exit(1)
sts = kinds['StatefulSet']
sspec = sts.get('spec', {})
if sspec.get('replicas') != 3:
    print(f"StatefulSet: replicas debe ser 3 (es {sspec.get('replicas')})")
    sys.exit(1)
if sspec.get('serviceName') != 'postgres':
    print(f"StatefulSet: serviceName debe ser 'postgres' (es '{sspec.get('serviceName')}')")
    sys.exit(1)
selector = sspec.get('selector', {}).get('matchLabels', {})
if selector.get('app') != 'postgres':
    print("StatefulSet: selector.matchLabels debe ser app=postgres")
    sys.exit(1)
tmpl = sspec.get('template', {})
tmpl_labels = tmpl.get('metadata', {}).get('labels', {})
if tmpl_labels.get('app') != 'postgres':
    print("StatefulSet: template.metadata.labels debe ser app=postgres")
    sys.exit(1)
containers = tmpl.get('spec', {}).get('containers', [])
if not containers:
    print("StatefulSet: falta definir containers")
    sys.exit(1)
c0 = containers[0]
if c0.get('image') != 'postgres:16':
    print(f"StatefulSet: la imagen debe ser 'postgres:16' (es '{c0.get('image')}')")
    sys.exit(1)
envs = c0.get('env', [])
if not any(e.get('name') == 'POSTGRES_PASSWORD' for e in envs):
    print("StatefulSet: falta la variable POSTGRES_PASSWORD")
    sys.exit(1)
vmounts = c0.get('volumeMounts', [])
if not any(vm.get('mountPath') == '/var/lib/postgresql/data' for vm in vmounts):
    print("StatefulSet: falta volumeMount en /var/lib/postgresql/data")
    sys.exit(1)

# volumeClaimTemplates
vcts = sspec.get('volumeClaimTemplates', [])
if not vcts:
    print("StatefulSet: falta volumeClaimTemplates")
    sys.exit(1)
vct = vcts[0]
req = vct.get('spec', {}).get('resources', {}).get('requests', {}).get('storage', '')
if req != '5Gi':
    print(f"StatefulSet: volumeClaimTemplates requests.storage debe ser '5Gi' (es '{req}')")
    sys.exit(1)
if 'ReadWriteOnce' not in vct.get('spec', {}).get('accessModes', []):
    print("StatefulSet: volumeClaimTemplates debe tener accessMode ReadWriteOnce")
    sys.exit(1)

print("OK Validación específica StatefulSet")
PYEOF

# Si hay cluster, aplicar y verificar
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster detectado. Aplicando manifiestos..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
  sleep 3
  kubectl get svc postgres >/dev/null 2>&1 || fail "No se encontró el Service postgres"
  kubectl get statefulset postgres >/dev/null 2>&1 || fail "No se encontró el StatefulSet postgres"
  kubectl delete -f "$YAML_DIR" --ignore-not-found >/dev/null 2>&1 || true
  echo "Validación en cluster OK."
fi

echo "OK Tests pasaron"
exit 0
