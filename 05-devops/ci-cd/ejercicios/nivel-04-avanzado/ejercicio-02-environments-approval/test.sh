#!/usr/bin/env bash
set -euo pipefail
PASS=0; FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }
command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

shopt -s nullglob
WORKFLOWS=(.github/workflows/*.yml)
shopt -u nullglob
if [ ${#WORKFLOWS[@]} -eq 0 ]; then
  ko "No hay workflows en .github/workflows/*.yml"
  echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1
fi
WORKFLOW="${WORKFLOWS[0]}"

mapfile -t CHECKS < <(python3 - "$WORKFLOW" <<'PY'
import sys, yaml, os
path = sys.argv[1]
with open(path) as f:
    text = f.read()
try:
    data = yaml.safe_load(text)
except Exception as e:
    print(f"FAIL|YAML inválido en {path}: {e}")
    sys.exit(0)

jobs = data.get("jobs", {}) or {}
if not jobs:
    print("FAIL|No hay jobs definidos en el workflow")
else:
    env_jobs = []
    for n, j in jobs.items():
        if not isinstance(j, dict):
            continue
        env = j.get("environment")
        if env is not None:
            env_jobs.append(n)
    print("PASS|Algún job tiene environment definido" if env_jobs else "FAIL|Ningún job tiene el campo environment definido")
    needs_ok = any(isinstance(j, dict) and "needs" in j for j in jobs.values())
    print("PASS|El job de deploy usa needs (depende de build/test)" if needs_ok else "FAIL|No hay ningún job con needs")

print("PASS|Existe el script scripts/deploy.sh" if os.path.isfile("scripts/deploy.sh") else "FAIL|No existe scripts/deploy.sh")
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
