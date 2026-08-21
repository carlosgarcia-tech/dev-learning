#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 18 — Pipeline GitLab CI completo

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

GL=".gitlab-ci.yml"

[ -f "$GL" ] && ok "El archivo $GL existe" || { ko "No existe $GL"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$GL" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []

# image
if data.get("image") != "node:20-alpine":
    errors.append(f"image debe ser 'node:20-alpine', es {data.get('image')!r}")

# stages
stages = data.get("stages", [])
if not isinstance(stages, list) or len(stages) < 3:
    errors.append(f"stages debe tener al menos 3 etapas, es {stages!r}")
else:
    for s in ["build", "test", "deploy"]:
        if s not in stages:
            errors.append(f"falta el stage '{s}'")

# variables
variables = data.get("variables", {})
if not isinstance(variables, dict) or "NODE_ENV" not in variables:
    errors.append("falta variables con NODE_ENV")

# jobs: build, test, deploy son claves de raíz
# pero hay que excluir las claves no-job: image, stages, variables, default, workflow, cache, include
non_job_keys = {"image", "stages", "variables", "default", "workflow", "cache", "include", "before_script", "after_script"}

for jname in ["build", "test", "deploy"]:
    if jname not in data:
        errors.append(f"falta el job '{jname}'")
        continue
    job = data[jname]
    if not isinstance(job, dict):
        errors.append(f"'{jname}' no es un job válido")
        continue

if "build" in data and isinstance(data["build"], dict):
    if "artifacts" not in data["build"]:
        errors.append("build debe tener artifacts")
    elif "dist/" not in str(data["build"].get("artifacts", {}).get("paths", [])):
        errors.append("build debe guardar dist/ como artifact")

if "test" in data and isinstance(data["test"], dict):
    cache = data["test"].get("cache", {})
    key = cache.get("key", {})
    if isinstance(key, dict):
        files = key.get("files", [])
        if "package-lock.json" not in files:
            errors.append("test debe tener cache.key.files con package-lock.json")
    else:
        errors.append("test debe tener cache con key.files")

if "deploy" in data and isinstance(data["deploy"], dict):
    rules = data["deploy"].get("rules", [])
    has_main_rule = False
    has_manual = False
    if isinstance(rules, list):
        for r in rules:
            if "main" in str(r.get("if", "")):
                has_main_rule = True
            if r.get("when") == "manual":
                has_manual = True
    if not has_main_rule:
        errors.append("deploy debe tener rules con $CI_COMMIT_BRANCH == main")
    if not has_manual:
        errors.append("deploy debe tener when: manual")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Pipeline GitLab CI completo correcto")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
