#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 29 — Rollback automático

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/rollback.yml"

# Verificar archivos
for f in "$WF" scripts/health-check.sh scripts/rollback.sh k8s/deployment.yaml; do
    [ -f "$f" ] && ok "Existe $f" || ko "No existe $f"
done

# Verificar scripts
for sc in scripts/health-check.sh scripts/rollback.sh; do
    if [ -f "$sc" ]; then
        head -1 "$sc" | grep -q "^#!" && ok "$sc tiene shebang" || ko "$sc sin shebang"
        grep -q "set -euo pipefail" "$sc" && ok "$sc tiene set -euo pipefail" || ko "$sc sin set -euo pipefail"
    fi
done

# health-check usa curl
if [ -f "scripts/health-check.sh" ]; then
    grep -q "curl" scripts/health-check.sh && ok "health-check usa curl" || ko "health-check no usa curl"
fi

# rollback usa kubectl rollout undo
if [ -f "scripts/rollback.sh" ]; then
    grep -q "rollout undo" scripts/rollback.sh && ok "rollback usa kubectl rollout undo" || ko "rollback no usa rollout undo"
fi

# Validar workflow y deployment
python3 - <<'PYEOF'
import yaml, sys

errors = []

# workflow
try:
    with open(".github/workflows/rollback.yml") as f:
        wf = yaml.safe_load(f)
    jobs = wf.get("jobs", {})
    deploy = jobs.get("deploy", {})
    deploy_steps = deploy.get("steps", [])
    deploy_runs = " ".join(s.get("run", "") or "" for s in deploy_steps)
    if "kubectl apply" not in deploy_runs:
        errors.append("deploy no hace kubectl apply")
    if "rollout status" not in deploy_runs:
        errors.append("deploy no hace rollout status")
    if "health-check" not in deploy_runs:
        errors.append("deploy no ejecuta health-check.sh")
    # rollback job
    rollback = jobs.get("rollback", {})
    if not rollback:
        errors.append("falta el job 'rollback'")
    else:
        if "failure()" not in str(rollback.get("if", "")):
            errors.append("rollback debe tener if: failure()")
        rb_steps = rollback.get("steps", [])
        rb_runs = " ".join(s.get("run", "") or "" for s in rb_steps)
        if "rollback" not in rb_runs:
            errors.append("rollback no ejecuta rollback.sh")
except Exception as e:
    errors.append(f"error leyendo workflow: {e}")

# deployment.yaml
try:
    with open("k8s/deployment.yaml") as f:
        docs = list(yaml.safe_load_all(f))
    dep_ok = any(isinstance(d, dict) and d.get("kind") == "Deployment" for d in docs)
    if not dep_ok:
        errors.append("k8s/deployment.yaml no es un Deployment")
except Exception as e:
    errors.append(f"error leyendo deployment.yaml: {e}")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Rollback automático correcto")
PYEOF

ok "Validación completada" || true

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
