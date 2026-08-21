#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 26 — Canary deployment

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

python3 - <<'PYEOF'
import yaml, sys

errors = []

def load(path):
    try:
        with open(path) as f:
            return list(yaml.safe_load_all(f))
    except Exception as e:
        return [{"_error": str(e)}]

# rollout.yaml
rollout = load("k8s/rollout.yaml")
rollout_ok = False
for doc in rollout:
    if isinstance(doc, dict) and doc.get("kind") == "Rollout":
        rollout_ok = True
        if doc.get("apiVersion") != "argoproj.io/v1alpha1":
            errors.append(f"apiVersion debe ser argoproj.io/v1alpha1, es {doc.get('apiVersion')!r}")
        strategy = doc.get("spec", {}).get("strategy", {})
        if "canary" not in strategy:
            errors.append("falta strategy.canary")
        else:
            steps = strategy["canary"].get("steps", [])
            if not isinstance(steps, list) or len(steps) < 3:
                errors.append(f"canary debe tener al menos 3 steps, tiene {len(steps)}")
            weights = [s.get("setWeight") for s in steps if isinstance(s, dict) and "setWeight" in s]
            if not weights:
                errors.append("no hay steps con setWeight")
            else:
                if 10 not in weights or 30 not in weights:
                    errors.append(f"debe haber setWeight 10 y 30, hay {weights}")
            has_pause = any("pause" in s for s in steps if isinstance(s, dict))
            if not has_pause:
                errors.append("falta un step con pause")
        break
if not rollout_ok:
    errors.append("rollout.yaml no es un Rollout")

# service.yaml
svc = load("k8s/service.yaml")
svc_ok = any(isinstance(d, dict) and d.get("kind") == "Service" for d in svc)
if not svc_ok:
    errors.append("service.yaml no es un Service")

# workflow
try:
    with open(".github/workflows/canary.yml") as f:
        wf = yaml.safe_load(f)
    steps = wf.get("jobs", {}).get("deploy", {}).get("steps", [])
    all_runs = " ".join(s.get("run", "") or "" for s in steps)
    if "kubectl apply" not in all_runs:
        errors.append("el workflow no hace kubectl apply")
except Exception as e:
    errors.append(f"error leyendo workflow: {e}")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Canary deployment correcto")
PYEOF

ok "Validación completada" || true

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
