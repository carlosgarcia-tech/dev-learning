#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 16 — Reusable workflow

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

REUSABLE=".github/workflows/build-reusable.yml"
CALLER=".github/workflows/caller.yml"

[ -f "$REUSABLE" ] && ok "Existe $REUSABLE" || ko "No existe $REUSABLE"
[ -f "$CALLER" ] && ok "Existe $CALLER" || ko "No existe $CALLER"

if [ -f "$REUSABLE" ]; then
python3 - "$REUSABLE" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
on = data.get("on") or data.get(True)
has_wc = False
if isinstance(on, dict) and "workflow_call" in on:
    has_wc = True
    inputs = on["workflow_call"].get("inputs", {})
    if "node-version" not in inputs:
        errors.append("falta el input 'node-version'")
    else:
        if inputs["node-version"].get("required") is not True:
            errors.append("el input 'node-version' debe ser required: true")

jobs = data.get("jobs", {})
job = jobs.get("build")
if not job:
    errors.append("falta el job 'build'")
else:
    steps = job.get("steps", [])
    has_input_ref = any("inputs.node-version" in str(s) for s in steps)
    if not has_input_ref:
        errors.append("ningun step usa inputs.node-version")

if not has_wc:
    errors.append("falta on: workflow_call")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Workflow reutilizable correcto")
PYEOF
fi

if [ -f "$CALLER" ]; then
python3 - "$CALLER" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
for name, job in jobs.items():
    uses = job.get("uses", "")
    if "build-reusable" not in uses:
        errors.append(f"el job '{name}' no llama a build-reusable.yml")
    w = job.get("with", {})
    if w.get("node-version") != "20":
        errors.append(f"el job '{name}' no pasa node-version: '20'")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Caller correcto")
PYEOF
fi

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
