#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }
command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

GITLAB_CI=".gitlab-ci.yml"
if [ ! -f "$GITLAB_CI" ]; then
  ko "No existe .gitlab-ci.yml en la raíz del ejercicio"
  echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1
fi

mapfile -t CHECKS < <(python3 - "$GITLAB_CI" <<'PY'
import sys, yaml
path = sys.argv[1]
with open(path) as f:
    text = f.read()
try:
    data = yaml.safe_load(text)
except Exception as e:
    print(f"FAIL|YAML inválido en {path}: {e}")
    sys.exit(0)

if not isinstance(data, dict):
    print("FAIL|.gitlab-ci.yml no es un diccionario válido")
    sys.exit(0)

stages = data.get("stages")
print("PASS|Define stages" if stages and len(stages) >= 3 else f"FAIL|No define al menos 3 stages (encontrados: {stages})")

rules_found = False
artifacts_found = False
for name, job in data.items():
    if name in ("stages", "default", "variables", "include", "image", "workflow"):
        continue
    if not isinstance(job, dict):
        continue
    if "rules" in job:
        rules_found = True
    if "artifacts" in job:
        artifacts_found = True

print("PASS|Algun job usa rules" if rules_found else "FAIL|Ningún job usa rules con if")
print("PASS|Algun job declara artifacts" if artifacts_found else "FAIL|Ningún job declara artifacts")
PY
)

for line in "${CHECKS[@]}"; do
  status="${line%%|*}"
  msg="${line#*|}"
  if [ "$status" = "PASS" ]; then ok "$msg"; else ko "$msg"; fi
done

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"; exit 0
