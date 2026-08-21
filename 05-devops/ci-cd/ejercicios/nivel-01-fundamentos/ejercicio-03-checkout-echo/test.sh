#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 03 — Checkout + run echo

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/checkout.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
if "build" not in jobs:
    errors.append("falta el job 'build'")
else:
    job = jobs["build"]
    if job.get("runs-on") != "ubuntu-latest":
        errors.append("runs-on debe ser ubuntu-latest")
    steps = job.get("steps", [])
    has_checkout = any("actions/checkout" in (s.get("uses","") or "") for s in steps)
    if not has_checkout:
        errors.append("falta actions/checkout@v4")
    has_ls = any("ls" in (s.get("run","") or "") for s in steps)
    if not has_ls:
        errors.append("falta un step con ls")
    has_echo = any("echo" in (s.get("run","") or "") for s in steps)
    if not has_echo:
        errors.append("falta un step con echo")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Checkout y steps correctos")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
