#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 02 — Trigger on push

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/trigger.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
if data.get("name") != "Trigger Push":
    errors.append("name debe ser 'Trigger Push'")

on = data.get("on") or data.get(True)
if not on:
    errors.append("falta 'on'")
else:
    push = on if on == "push" else (on.get("push") if isinstance(on, dict) else None)
    if push is None:
        errors.append("el trigger debe ser push")
    elif isinstance(push, dict):
        branches = push.get("branches", [])
        if "main" not in branches or "develop" not in branches:
            errors.append(f"branches debe incluir main y develop, es {branches}")

jobs = data.get("jobs", {})
if "verificar" not in jobs:
    errors.append("falta el job 'verificar'")
else:
    job = jobs["verificar"]
    if job.get("runs-on") != "ubuntu-latest":
        errors.append("runs-on debe ser ubuntu-latest")
    steps = job.get("steps", [])
    has_ref = any("github.ref" in (s.get("run","") or "") for s in steps)
    if not has_ref:
        errors.append("ningún step usa github.ref")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Trigger y estructura correctos")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
