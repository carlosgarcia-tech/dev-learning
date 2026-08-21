#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 25 — Blue-green deploy con K8s

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

# Validar manifests K8s
for f in k8s/blue-deployment.yaml k8s/green-deployment.yaml k8s/service.yaml; do
    [ -f "$f" ] && ok "Existe $f" || { ko "No existe $f"; FAIL_EXISTS=1; }
done

WF=".github/workflows/blue-green.yml"
[ -f "$WF" ] && ok "Existe $WF" || ko "No existe $WF"

# Validar contenido de manifests K8s
python3 - <<'PYEOF'
import yaml, sys

errors = []

def load(path):
    try:
        with open(path) as f:
            return list(yaml.safe_load_all(f))
    except Exception as e:
        return [{"_error": str(e)}]

# blue deployment
blue = load("k8s/blue-deployment.yaml")
blue_ok = False
for doc in blue:
    if isinstance(doc, dict) and doc.get("kind") == "Deployment":
        labels = doc.get("metadata", {}).get("labels", {})
        if labels.get("version") == "blue":
            blue_ok = True
        tmpl_labels = doc.get("spec", {}).get("template", {}).get("metadata", {}).get("labels", {})
        if tmpl_labels.get("version") != "blue":
            errors.append("blue-deployment template labels debe tener version: blue")
if not blue_ok:
    errors.append("blue-deployment.yaml no es un Deployment con version: blue")

# green deployment
green = load("k8s/green-deployment.yaml")
green_ok = False
for doc in green:
    if isinstance(doc, dict) and doc.get("kind") == "Deployment":
        labels = doc.get("metadata", {}).get("labels", {})
        if labels.get("version") == "green":
            green_ok = True
        tmpl_labels = doc.get("spec", {}).get("template", {}).get("metadata", {}).get("labels", {})
        if tmpl_labels.get("version") != "green":
            errors.append("green-deployment template labels debe tener version: green")
if not green_ok:
    errors.append("green-deployment.yaml no es un Deployment con version: green")

# service
svc = load("k8s/service.yaml")
svc_ok = False
for doc in svc:
    if isinstance(doc, dict) and doc.get("kind") == "Service":
        selector = doc.get("spec", {}).get("selector", {})
        if selector.get("version") == "blue":
            svc_ok = True
        else:
            errors.append(f"service selector debe tener version: blue, es {selector}")
        break
if not svc_ok:
    errors.append("service.yaml no es un Service con selector version: blue")

# workflow
try:
    with open(".github/workflows/blue-green.yml") as f:
        wf_raw = f.read()
    wf = yaml.safe_load(wf_raw)
    jobs = wf.get("jobs", {})
    job = jobs.get("deploy", {})
    steps = job.get("steps", [])
    all_runs = " ".join(s.get("run", "") or "" for s in steps)
    if "kubectl apply" not in all_runs:
        errors.append("el workflow no hace kubectl apply")
    if "patch" not in all_runs:
        errors.append("el workflow no conmuta el Service (kubectl patch)")
    if "curl" not in all_runs:
        errors.append("el workflow no hace health check (curl)")
    if "blue" not in all_runs:
        errors.append("el workflow no tiene rollback a blue")
except Exception as e:
    errors.append(f"error leyendo workflow: {e}")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Blue-green K8s correcto")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
