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

# Validaciones específicas blue-green
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

kinds = {}
for d in docs:
    kinds.setdefault(d['kind'], []).append(d)

deps = kinds.get('Deployment', [])
if len(deps) < 2:
    print("Se necesitan al menos 2 Deployments (blue y green)")
    sys.exit(1)

blue = None
green = None
for d in deps:
    name = d.get('metadata', {}).get('name', '')
    labels = d.get('metadata', {}).get('labels', {}) or {}
    tmpl_labels = d.get('spec', {}).get('template', {}).get('metadata', {}).get('labels', {}) or {}
    all_labels = {**labels, **tmpl_labels}
    if 'blue' in name or all_labels.get('slot') == 'blue':
        blue = d
    if 'green' in name or all_labels.get('slot') == 'green':
        green = d

if blue is None:
    print("No se encontró el Deployment blue (nombre 'blue' o label slot=blue)")
    sys.exit(1)
if green is None:
    print("No se encontró el Deployment green (nombre 'green' o label slot=green)")
    sys.exit(1)

# Ambos deben compartir app label
def get_app(d):
    tmpl = d.get('spec', {}).get('template', {}).get('metadata', {}).get('labels', {}) or {}
    return tmpl.get('app')

if get_app(blue) != get_app(green):
    print("Ambos Deployments deben tener el mismo label 'app' en el template")
    sys.exit(1)

# Service debe apuntar a uno de los slots (blue o green)
svcs = kinds.get('Service', [])
if not svcs:
    print("Falta un Service")
    sys.exit(1)
svc = svcs[0]
sel = svc.get('spec', {}).get('selector', {}) or {}
if 'app' not in sel:
    print("El Service debe seleccionar por 'app'")
    sys.exit(1)
if 'slot' not in sel:
    print("El Service debe seleccionar por 'slot' (blue o green)")
    sys.exit(1)
if sel.get('slot') not in ('blue', 'green'):
    print(f"Service: slot debe ser 'blue' o 'green', no '{sel.get('slot')}'")
    sys.exit(1)
PYEOF

# Validación opcional con cluster
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Cluster K8s detectado, aplicando y verificando..."
  kubectl apply -f "$YAML_DIR" >/dev/null 2>&1 || fail "kubectl apply falló"
fi

echo "OK Tests pasaron"
exit 0
