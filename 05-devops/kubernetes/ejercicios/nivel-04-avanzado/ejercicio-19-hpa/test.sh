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

# Validaciones específicas del HPA
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

# El container del Deployment debe definir resources.requests.cpu (necesario para HPA de CPU)
containers = dep.get('spec', {}).get('template', {}).get('spec', {}).get('containers', [])
if not containers:
    print("El Deployment no tiene containers")
    sys.exit(1)
req = containers[0].get('resources', {}).get('requests', {})
if 'cpu' not in req:
    print("El container del Deployment debe definir resources.requests.cpu (necesario para HPA basado en CPU)")
    sys.exit(1)

# Debe existir un HorizontalPodAutoscaler
if 'HorizontalPodAutoscaler' not in kinds:
    print("Falta un recurso HorizontalPodAutoscaler")
    sys.exit(1)
hpa = kinds['HorizontalPodAutoscaler']

# scaleTargetRef debe apuntar al Deployment correcto
target = hpa.get('spec', {}).get('scaleTargetRef', {})
if target.get('kind') != 'Deployment':
    print("HPA.scaleTargetRef.kind debe ser Deployment")
    sys.exit(1)
if target.get('name') != dep.get('metadata', {}).get('name'):
    print("HPA.scaleTargetRef.name debe coincidir con el nombre del Deployment")
    sys.exit(1)

# minReplicas y maxReplicas válidos
spec = hpa.get('spec', {})
if 'minReplicas' not in spec or 'maxReplicas' not in spec:
    print("HPA debe definir minReplicas y maxReplicas")
    sys.exit(1)
if spec.get('minReplicas', 0) >= spec.get('maxReplicas', 0):
    print("HPA.maxReplicas debe ser mayor que minReplicas")
    sys.exit(1)

# metrics con CPU
metrics = spec.get('metrics', [])
has_cpu = False
for m in metrics:
    if m.get('type') == 'Resource' and m.get('resource', {}).get('name') == 'cpu':
        has_cpu = True
if not has_cpu:
    print("HPA debe definir una metric de tipo Resource con name cpu")
    sys.exit(1)
PYEOF

echo "OK Tests pasaron"
exit 0
