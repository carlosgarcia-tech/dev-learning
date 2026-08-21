#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 06 — Cache de dependencias

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/cache.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
job = jobs.get("install")
if not job:
    errors.append("falta el job 'install'")
else:
    steps = job.get("steps", [])
    has_checkout = any("actions/checkout" in (s.get("uses","") or "") for s in steps)
    if not has_checkout:
        errors.append("falta actions/checkout")
    setup = None
    for s in steps:
        if "actions/setup-node" in (s.get("uses","") or ""):
            setup = s
            break
    if not setup:
        errors.append("falta actions/setup-node@v4")
    else:
        w = setup.get("with", {})
        if w.get("cache") != "npm":
            errors.append("setup-node debe tener cache: npm")
    has_install = any("npm install" in (s.get("run","") or "") for s in steps)
    if not has_install:
        errors.append("falta 'npm install'")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Cache de dependencias correcto")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
