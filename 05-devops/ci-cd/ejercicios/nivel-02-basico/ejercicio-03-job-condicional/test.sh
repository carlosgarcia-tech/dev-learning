#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 09 — Job condicional (if)

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/condicional.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})

if "build" not in jobs:
    errors.append("falta el job 'build'")

if "deploy" not in jobs:
    errors.append("falta el job 'deploy'")
else:
    deploy = jobs["deploy"]
    cond = deploy.get("if", "")
    if "github.ref" not in str(cond) or "main" not in str(cond):
        errors.append("deploy debe tener if con github.ref == refs/heads/main")
    needs = deploy.get("needs", "")
    if needs != "build" and (not isinstance(needs, list) or "build" not in needs):
        errors.append("deploy debe tener needs: build")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Job condicional correcto")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
