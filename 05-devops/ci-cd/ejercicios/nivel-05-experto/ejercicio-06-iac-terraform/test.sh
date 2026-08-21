#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 30 — IaC con Terraform en pipeline

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

TF="terraform/main.tf"
WF=".github/workflows/terraform.yml"

[ -f "$TF" ] && ok "Existe $TF" || ko "No existe $TF"
[ -f "$WF" ] && ok "Existe $WF" || ko "No existe $WF"

# Validar main.tf tiene provider y resource
if [ -f "$TF" ]; then
    grep -qi "^provider" "$TF" && ok "main.tf tiene provider" || ko "main.tf no tiene provider"
    grep -qi "resource" "$TF" && ok "main.tf tiene resource" || ko "main.tf no tiene resource"
fi

# Validar workflow
if [ -f "$WF" ]; then
python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})

plan = jobs.get("plan", {})
if not plan:
    errors.append("falta el job 'plan'")
else:
    steps = plan.get("steps", [])
    all_uses = " ".join(s.get("uses", "") or "" for s in steps)
    all_runs = " ".join(s.get("run", "") or "" for s in steps)
    if "setup-terraform" not in all_uses:
        errors.append("falta hashicorp/setup-terraform@v3")
    for cmd in ["terraform init", "terraform plan"]:
        if cmd not in all_runs:
            errors.append(f"falta '{cmd}'")
    if "fmt -check" not in all_runs and "validate" not in all_runs:
        errors.append("falta fmt -check o validate")

apply = jobs.get("apply", {})
if not apply:
    errors.append("falta el job 'apply'")
else:
    if apply.get("environment") != "production":
        errors.append(f"apply debe tener environment: production, es {apply.get('environment')!r}")
    steps = apply.get("steps", [])
    all_runs = " ".join(s.get("run", "") or "" for s in steps)
    if "terraform apply" not in all_runs:
        errors.append("apply no ejecuta terraform apply")
    if "auto-approve" not in all_runs:
        errors.append("apply debe usar -auto-approve")
    needs = apply.get("needs", "")
    if needs != "plan" and (not isinstance(needs, list) or "plan" not in needs):
        errors.append("apply debe tener needs: plan")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Pipeline de Terraform correcto")
PYEOF
fi

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
