#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 11 — Secrets

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/secrets.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

[ -f "deploy.sh" ] && ok "deploy.sh existe" || ko "Falta deploy.sh"

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    raw = f.read()
    data = yaml.safe_load(raw)

errors = []
jobs = data.get("jobs", {})
job = jobs.get("deploy")
if not job:
    errors.append("falta el job 'deploy'")
else:
    steps = job.get("steps", [])
    has_checkout = any("actions/checkout" in (s.get("uses","") or "") for s in steps)
    if not has_checkout:
        errors.append("falta actions/checkout")

    # El secret debe pasarse via env, no como argumento de run
    has_env_secret = False
    has_run_secret_arg = False
    for s in steps:
        env = s.get("env", {})
        if isinstance(env, dict):
            for v in env.values():
                if "secrets.API_TOKEN" in str(v):
                    has_env_secret = True
        run = s.get("run", "") or ""
        if "secrets.API_TOKEN" in run:
            has_run_secret_arg = True

    if not has_env_secret:
        errors.append("el secret debe inyectarse via env: con secrets.API_TOKEN")
    if has_run_secret_arg:
        errors.append("el secret NO debe aparecer en run: (queda visible)")

    has_deploy = any("deploy.sh" in (s.get("run","") or "") for s in steps)
    if not has_deploy:
        errors.append("falta ejecutar ./deploy.sh")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Uso de secrets correcto")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
