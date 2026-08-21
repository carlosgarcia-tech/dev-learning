#!/usr/bin/env bash
set -euo pipefail

# Validador del Proyecto Final — Pipeline completo de CI/CD

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

echo "=== Validando archivos del proyecto ==="

# Verificar existencia de archivos clave
for f in \
  app/package.json \
  app/server.js \
  app/test/health.test.js \
  Dockerfile \
  .github/workflows/ci.yml \
  .github/workflows/cd.yml \
  .gitlab-ci.yml \
  k8s/deployment.yaml \
  k8s/service.yaml \
  scripts/health-check.sh \
  scripts/rollback.sh; do
    [ -f "$f" ] && ok "Existe $f" || ko "No existe $f"
done

# Verificar scripts
for sc in scripts/health-check.sh scripts/rollback.sh; do
    if [ -f "$sc" ]; then
        head -1 "$sc" | grep -q "^#!" && ok "$sc tiene shebang" || ko "$sc sin shebang"
        grep -q "set -euo pipefail" "$sc" && ok "$sc tiene set -euo pipefail" || ko "$sc sin set -euo pipefail"
    fi
done

echo ""
echo "=== Validando sintaxis YAML ==="

python3 - <<'PYEOF'
import yaml, sys

errors = []

def load(path):
    try:
        with open(path) as f:
            return yaml.safe_load(f)
    except Exception as e:
        return {"_error": str(e)}

# ci.yml
ci = load(".github/workflows/ci.yml")
if "_error" in ci:
    errors.append(f"ci.yml inválido: {ci['_error']}")
else:
    jobs = ci.get("jobs", {})
    for name in ["lint", "test", "build", "scan", "publish"]:
        if name not in jobs:
            errors.append(f"ci.yml: falta el job '{name}'")
    # verificar needs
    if "build" in jobs:
        needs = jobs["build"].get("needs", [])
        if "lint" not in needs or "test" not in needs:
            errors.append("ci.yml: build debe depender de lint y test")
    if "scan" in jobs:
        needs = jobs["scan"].get("needs", "")
        if needs != "build" and (not isinstance(needs, list) or "build" not in needs):
            errors.append("ci.yml: scan debe depender de build")
    if "publish" in jobs:
        needs = jobs["publish"].get("needs", "")
        if needs != "scan" and (not isinstance(needs, list) or "scan" not in needs):
            errors.append("ci.yml: publish debe depender de scan")

# cd.yml
cd = load(".github/workflows/cd.yml")
if "_error" in cd:
    errors.append(f"cd.yml inválido: {cd['_error']}")
else:
    jobs = cd.get("jobs", {})
    for name in ["deploy_staging", "deploy_prod"]:
        if name not in jobs:
            errors.append(f"cd.yml: falta el job '{name}'")
    if "deploy_prod" in jobs:
        if jobs["deploy_prod"].get("environment") != "production":
            errors.append("cd.yml: deploy_prod debe tener environment: production")
        needs = jobs["deploy_prod"].get("needs", "")
        if needs != "deploy_staging" and (not isinstance(needs, list) or "deploy_staging" not in needs):
            errors.append("cd.yml: deploy_prod debe depender de deploy_staging")
    if "rollback" in jobs:
        if "failure()" not in str(jobs["rollback"].get("if", "")):
            errors.append("cd.yml: rollback debe tener if: failure()")

# .gitlab-ci.yml
gl = load(".gitlab-ci.yml")
if "_error" in gl:
    errors.append(f".gitlab-ci.yml inválido: {gl['_error']}")
else:
    stages = gl.get("stages", [])
    for s in ["test", "build", "scan", "deploy"]:
        if s not in stages:
            errors.append(f".gitlab-ci.yml: falta el stage '{s}'")
    for job in ["lint", "test", "deploy_staging", "deploy_prod"]:
        if job not in gl:
            errors.append(f".gitlab-ci.yml: falta el job '{job}'")
    if "deploy_prod" in gl:
        rules = gl["deploy_prod"].get("rules", [])
        has_manual = any(r.get("when") == "manual" for r in rules if isinstance(r, dict))
        if not has_manual and gl["deploy_prod"].get("when") != "manual":
            errors.append(".gitlab-ci.yml: deploy_prod debe ser when: manual")

# k8s manifests
dep = load("k8s/deployment.yaml")
if "_error" in dep:
    errors.append(f"deployment.yaml inválido: {dep['_error']}")
elif dep.get("kind") != "Deployment":
    errors.append("k8s/deployment.yaml debe ser kind: Deployment")

svc = load("k8s/service.yaml")
if "_error" in svc:
    errors.append(f"service.yaml inválido: {svc['_error']}")
elif svc.get("kind") != "Service":
    errors.append("k8s/service.yaml debe ser kind: Service")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Todos los YAML son válidos y tienen la estructura esperada")
PYEOF

echo ""
echo "=== Validando app Node.js ==="

# Verificar que server.js tiene endpoint /health
if [ -f "app/server.js" ]; then
    grep -q '/health' app/server.js && ok "server.js tiene endpoint /health" || ko "server.js no tiene endpoint /health"
fi

# Verificar Dockerfile
if [ -f "Dockerfile" ]; then
    grep -qi "^FROM" Dockerfile && ok "Dockerfile tiene FROM" || ko "Dockerfile sin FROM"
    grep -qi "^COPY" Dockerfile && ok "Dockerfile tiene COPY" || ko "Dockerfile sin COPY"
fi

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then
    echo "❌ Tests fallaron"
    exit 1
fi
echo "✅ Tests pasaron"
exit 0
