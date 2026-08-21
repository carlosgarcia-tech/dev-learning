#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 13 — Build + test + lint

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/ci.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})

expected = {"lint": "npm run lint", "test": "npm test", "build": "npm run build"}
needs_map = {"test": "lint", "build": "test"}

for name in expected:
    if name not in jobs:
        errors.append(f"falta el job '{name}'")
        continue
    job = jobs[name]
    steps = job.get("steps", [])
    has_checkout = any("actions/checkout" in (s.get("uses","") or "") for s in steps)
    if not has_checkout:
        errors.append(f"el job '{name}' no tiene checkout")
    has_setup = any("actions/setup-node" in (s.get("uses","") or "") for s in steps)
    if not has_setup:
        errors.append(f"el job '{name}' no tiene setup-node")
    else:
        for s in steps:
            if "setup-node" in (s.get("uses","") or ""):
                if s.get("with", {}).get("cache") != "npm":
                    errors.append(f"el job '{name}' no tiene cache: npm")
    all_runs = " ".join(s.get("run","") or "" for s in steps)
    if expected[name] not in all_runs:
        errors.append(f"el job '{name}' no ejecuta '{expected[name]}'")

for name, dep in needs_map.items():
    if name in jobs:
        needs = jobs[name].get("needs", "")
        if needs != dep and (not isinstance(needs, list) or dep not in needs):
            errors.append(f"el job '{name}' debe tener needs: {dep}")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Pipeline CI completo correcto")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
