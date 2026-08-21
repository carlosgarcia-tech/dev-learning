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

# Validaciones específicas de la estrategia RollingUpdate
python3 - "$YAML_DIR" <<'PYEOF' || exit 1
import sys, yaml, glob, os, re
yaml_dir = sys.argv[1]
files = sorted(glob.glob(os.path.join(yaml_dir, '*.yaml')))
docs = []
for f in files:
    with open(f) as fh:
        for doc in yaml.safe_load_all(fh):
            if doc is not None:
                docs.append(doc)

kinds = {d['kind']: d for d in docs}
if 'Deployment' not in kinds:
    print("Falta un recurso Deployment")
    sys.exit(1)
dep = kinds['Deployment']
spec = dep.get('spec', {})

# Al menos 4 replicas
if spec.get('replicas', 0) < 4:
    print("El Deployment debe tener al menos 4 replicas")
    sys.exit(1)

# strategy.type == RollingUpdate
strategy = spec.get('strategy', {})
if strategy.get('type') != 'RollingUpdate':
    print("Deployment.strategy.type debe ser 'RollingUpdate'")
    sys.exit(1)

# maxSurge y maxUnavailable definidos
ru = strategy.get('rollingUpdate', {})
if 'maxSurge' not in ru:
    print("Deployment.strategy.rollingUpdate debe definir 'maxSurge'")
    sys.exit(1)
if 'maxUnavailable' not in ru:
    print("Deployment.strategy.rollingUpdate debe definir 'maxUnavailable'")
    sys.exit(1)

def parse_pct(v):
    """Convierte int o 'NN%' a un valor numerico comparable."""
    if isinstance(v, int):
        return float(v)
    s = str(v)
    if s.endswith('%'):
        return float(s[:-1]) / 100.0
    return float(s)

# Validar que maxSurge y maxUnavailable no sean negativos
ms = parse_pct(ru['maxSurge'])
mu = parse_pct(ru['maxUnavailable'])
if ms < 0:
    print("maxSurge no puede ser negativo")
    sys.exit(1)
if mu < 0:
    print("maxUnavailable no puede ser negativo")
    sys.exit(1)
PYEOF

echo "OK Tests pasaron"
exit 0
