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
tags = push.get("tags") if isinstance(push, dict) else None
print("PASS|El trigger usa on.push.tags (tags v*)" if tags else "FAIL|El trigger no usa on.push.tags")

lower = text.lower()
has_release = ("action-gh-release" in lower) or ("gh-release" in lower) or ("release" in lower and "uses:" in lower)
print("PASS|Hay referencia a release / gh-release" if has_release else "FAIL|No hay referencia a release o gh-release")
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
