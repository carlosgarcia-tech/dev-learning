#!/usr/bin/env bash
# Nota: requiere un cluster K8s (kind/minikube) para validación completa; sin cluster valida los YAML.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

fail() { echo "FAIL Tests fallaron"; echo "  $1"; exit 1; }

# Validar los YAML de solucion/
if [ ! -d "solucion" ]; then
  fail "No existe la carpeta solucion/"
fi

yaml_files=$(find solucion -name '*.yaml' -type f 2>/dev/null | sort)
if [ -z "$yaml_files" ]; then
  fail "No se encontraron archivos *.yaml en solucion/"
fi

for f in $yaml_files; do
  python3 -c "import yaml; yaml.safe_load(open('$f'))" 2>/dev/null || fail "YAML inválido: $f"
done

# Validar campos requeridos
python3 - <<'PYEOF' || exit 1
import sys, yaml, glob, os
for f in sorted(glob.glob('solucion/**/*.yaml', recursive=True)):
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

echo "OK Tests pasaron"
exit 0
