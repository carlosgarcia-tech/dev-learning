#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 27 — GitOps con ArgoCD

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

# ArgoCD Application
app = load("k8s/argocd-application.yaml")
app_ok = False
for doc in app:
    if isinstance(doc, dict) and doc.get("kind") == "Application":
        app_ok = True
        if doc.get("apiVersion") != "argoproj.io/v1alpha1":
            errors.append(f"apiVersion debe ser argoproj.io/v1alpha1, es {doc.get('apiVersion')!r}")
        spec = doc.get("spec", {})
        source = spec.get("source", {})
        if not source.get("repoURL"):
            errors.append("falta spec.source.repoURL")
        if not source.get("path"):
            errors.append("falta spec.source.path")
        dest = spec.get("destination", {})
        if not dest.get("server"):
            errors.append("falta spec.destination.server")
        if not dest.get("namespace"):
            errors.append("falta spec.destination.namespace")
        sync = spec.get("syncPolicy", {}).get("automated", {})
        if "selfHeal" not in sync:
            errors.append("falta syncPolicy.automated.selfHeal")
        break
if not app_ok:
    errors.append("argocd-application.yaml no es una Application")

# Workflow
try:
    with open(".github/workflows/gitops.yml") as f:
        wf_raw = f.read()
    wf = yaml.safe_load(wf_raw)
    steps = wf.get("jobs", {}).get("update-manifest", {}).get("steps", [])
    all_runs = " ".join(s.get("run", "") or "" for s in steps)
    if "sed" not in all_runs:
        errors.append("el workflow no actualiza la imagen con sed")
    if "git commit" not in all_runs and "commit" not in all_runs:
        errors.append("el workflow no hace commit")
    if "git push" not in all_runs and "push" not in all_runs:
        errors.append("el workflow no hace push")
except Exception as e:
    errors.append(f"error leyendo workflow: {e}")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ GitOps con ArgoCD correcto")
PYEOF

ok "Validación completada" || true

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
