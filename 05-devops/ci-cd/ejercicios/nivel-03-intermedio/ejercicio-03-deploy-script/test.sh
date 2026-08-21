#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 15 — Deploy con script

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/deploy.yml"
SC="scripts/deploy.sh"

[ -f "$WF" ] && ok "El archivo $WF existe" || ko "No existe $WF"
[ -f "$SC" ] && ok "El script $SC existe" || ko "No existe $SC"

# Validar script
if [ -f "$SC" ]; then
    head -1 "$SC" | grep -q "^#!" && ok "Script tiene shebang" || ko "Script sin shebang"
    grep -q "set -euo pipefail" "$SC" && ok "Script tiene set -euo pipefail" || ko "Script sin set -euo pipefail"
fi

# Validar workflow
if [ -f "$WF" ]; then
python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
job = jobs.get("deploy")
if not job:
    errors.append("falta el job 'deploy'")
else:
    if job.get("environment") != "staging":
        errors.append(f"environment debe ser 'staging', es {job.get('environment')!r}")
    steps = job.get("steps", [])
    has_checkout = any("actions/checkout" in (s.get("uses","") or "") for s in steps)
    if not has_checkout:
        errors.append("falta actions/checkout")
    has_deploy = any("deploy.sh" in (s.get("run","") or "") for s in steps)
    if not has_deploy:
        errors.append("falta ejecutar scripts/deploy.sh")
    has_env_secret = False
    for s in steps:
        env = s.get("env", {})
        if isinstance(env, dict):
            for v in env.values():
                if "secrets.DEPLOY_KEY" in str(v):
                    has_env_secret = True
    if not has_env_secret:
        errors.append("falta DEPLOY_KEY via env: con secrets.DEPLOY_KEY")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Deploy con script correcto")
PYEOF
fi

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
