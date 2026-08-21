#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }
command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

shopt -s nullglob
WORKFLOWS=(.github/workflows/*.yml)
shopt -u nullglob
if [ ${#WORKFLOWS[@]} -eq 0 ]; then
  ko "No hay workflows en .github/workflows/*.yml"
  echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1
fi
WORKFLOW="${WORKFLOWS[0]}"

mapfile -t CHECKS < <(python3 - "$WORKFLOW" <<'PY'
import sys, yaml
path = sys.argv[1]
with open(path) as f:
    text = f.read()
try:
    data = yaml.safe_load(text)
except Exception as e:
    print(f"FAIL|YAML inválido en {path}: {e}")
    sys.exit(0)

has_github_output = ("GITHUB_OUTPUT" in text) or ("$GITHUB_OUTPUT" in text)
print("PASS|El workflow usa $GITHUB_OUTPUT" if has_github_output else "FAIL|El workflow no usa $GITHUB_OUTPUT")
has_fromjson = "fromJSON" in text
print("PASS|El workflow usa fromJSON" if has_fromjson else "FAIL|El workflow no usa fromJSON")

jobs = data.get("jobs", {}) or {}
matrix_fromjson = False
needs_ok = False
for n, j in jobs.items():
    if not isinstance(j, dict):
        continue
    strat = j.get("strategy", {})
    matrix = strat.get("matrix", {}) if isinstance(strat, dict) else {}
    # Buscar fromJSON en cualquier valor de la matrix
    for k, v in (matrix.items() if isinstance(matrix, dict) else []):
        if isinstance(v, str) and "fromJSON" in v:
            matrix_fromjson = True
    if "needs" in j:
        needs_ok = True

print("PASS|Hay strategy.matrix con fromJSON" if matrix_fromjson else "FAIL|No hay strategy.matrix que use fromJSON")
print("PASS|El job ejecutar depende (needs) de generar" if needs_ok else "FAIL|No hay jobs con needs")

import os
print("PASS|Existe config.json" if os.path.isfile("config.json") else "FAIL|No existe config.json")
PY
)

for line in "${CHECKS[@]}"; do
  status="${line%%|*}"
  msg="${line#*|}"
  if [ "$status" = "PASS" ]; then ok "$msg"; else ko "$msg"; fi
done

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"; exit 0
