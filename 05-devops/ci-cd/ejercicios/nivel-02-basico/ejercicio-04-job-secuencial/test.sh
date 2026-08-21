#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 10 — Job secuencial (needs)

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/secuencial.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})

for name in ["build", "test", "deploy"]:
    if name not in jobs:
        errors.append(f"falta el job '{name}'")

if "test" in jobs:
    needs = jobs["test"].get("needs", "")
    if needs != "build" and (not isinstance(needs, list) or "build" not in needs):
        errors.append("test debe tener needs: build")

if "deploy" in jobs:
    needs = jobs["deploy"].get("needs", "")
    if needs != "test" and (not isinstance(needs, list) or "test" not in needs):
        errors.append("deploy debe tener needs: test")

for name, job in jobs.items():
    if job.get("runs-on") != "ubuntu-latest":
        errors.append(f"el job '{name}' debe tener runs-on: ubuntu-latest")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Jobs secuenciales correctos")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
