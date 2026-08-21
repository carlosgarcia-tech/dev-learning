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

def get_on(on):
    if isinstance(on, str):
        return {on: {}}
    if isinstance(on, list):
        return {x: {} for x in on}
    return on or {}

on = get_on(data.get("on") or data.get(True))
push = on.get("push", {}) if isinstance(on, dict) else {}
paths = push.get("paths") if isinstance(push, dict) else None
uses_filter = "dorny/paths-filter" in text or "paths-filter" in text
print("PASS|El workflow usa path filters (on.push.paths o paths-filter)" if (paths or uses_filter) else "FAIL|El workflow no usa path filters (on.push.paths ni dorny/paths-filter)")

jobs = data.get("jobs", {}) or {}
if not jobs:
    print("FAIL|No hay jobs definidos en el workflow")
else:
    cond = [n for n, j in jobs.items() if isinstance(j, dict) and "if" in j]
    print("PASS|Hay jobs con if condicionales" if cond else "FAIL|No hay jobs con campo if condicional")
    needs_ok = [n for n, j in jobs.items() if isinstance(j, dict) and "needs" in j]
    print("PASS|Los jobs dependen (needs) del detector" if needs_ok else "FAIL|No hay jobs con needs (dependencia del detector)")
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
