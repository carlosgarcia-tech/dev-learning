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

jobs = data.get("jobs", {}) or {}
if_jobs = [n for n, j in jobs.items() if isinstance(j, dict) and "if" in j]
count = len(if_jobs)
print(f"PASS|Hay {count} jobs con campo if (>=2)" if count >= 2 else f"FAIL|Solo {count} jobs con campo if (se requieren >=2)")

# Revisar las expresiones if en texto (los comentarios ${...} pueden no cargar como string simple)
# Volcamos cada if a string para inspeccionar tokens.
import json
ifs_text = " ".join(
    str(j.get("if", "")) for j in jobs.values() if isinstance(j, dict) and "if" in j
)
has_github = "github." in ifs_text
has_contains = "contains" in ifs_text
has_startswith = "startsWith" in ifs_text
cond_ok = has_github or has_contains or has_startswith
print("PASS|Las condiciones usan github.* o contains o startsWith" if cond_ok else "FAIL|Las condiciones no usan github.*, contains ni startsWith")
func_ok = has_contains or has_startswith
print("PASS|Alguna condición usa contains o startsWith" if func_ok else "FAIL|Ninguna condición usa contains ni startsWith")
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
