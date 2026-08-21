#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 28 — Pipeline multi-entorno con gates

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/multi-entorno.yml"
SC="scripts/deploy.sh"

[ -f "$WF" ] && ok "Existe $WF" || ko "No existe $WF"
[ -f "$SC" ] && ok "Existe $SC" || ko "No existe $SC"

if [ -f "$SC" ]; then
    head -1 "$SC" | grep -q "^#!" && ok "Script tiene shebang" || ko "Script sin shebang"
    grep -q "set -euo pipefail" "$SC" && ok "Script tiene set -euo pipefail" || ko "Script sin set -euo pipefail"
fi

if [ -f "$WF" ]; then
python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})

# tres jobs
for name in ["deploy_dev", "deploy_staging", "deploy_prod"]:
    if name not in jobs:
        errors.append(f"falta el job '{name}'")

# environments
env_map = {"deploy_dev": "dev", "deploy_staging": "staging", "deploy_prod": "production"}
for name, env in env_map.items():
    if name in jobs:
        actual = jobs[name].get("environment")
        if actual != env:
            errors.append(f"{name} debe tener environment: {env}, es {actual!r}")

# needs
if "deploy_staging" in jobs:
    needs = jobs["deploy_staging"].get("needs", "")
    if needs != "deploy_dev" and (not isinstance(needs, list) or "deploy_dev" not in needs):
        errors.append("deploy_staging debe tener needs: deploy_dev")
if "deploy_prod" in jobs:
    needs = jobs["deploy_prod"].get("needs", "")
    if needs != "deploy_staging" and (not isinstance(needs, list) or "deploy_staging" not in needs):
        errors.append("deploy_prod debe tener needs: deploy_staging")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Pipeline multi-entorno correcto")
PYEOF
fi

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
