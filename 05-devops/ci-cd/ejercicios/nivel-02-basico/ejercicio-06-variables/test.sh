#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 12 — Variables

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/variables.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    raw = f.read()
    data = yaml.safe_load(raw)

errors = []
env = data.get("env", {})
if not isinstance(env, dict):
    errors.append("falta env a nivel de workflow")
else:
    if env.get("ENTORNO") != "dev":
        errors.append(f"env.ENTORNO debe ser 'dev', es {env.get('ENTORNO')!r}")
    if env.get("REGISTRY") != "ghcr.io":
        errors.append(f"env.REGISTRY debe ser 'ghcr.io', es {env.get('REGISTRY')!r}")

jobs = data.get("jobs", {})
job = jobs.get("info")
if not job:
    errors.append("falta el job 'info'")
else:
    steps = job.get("steps", [])
    all_runs = " ".join(s.get("run","") or "" for s in steps)
    if "ENTORNO" not in all_runs:
        errors.append("ningún step usa ENTORNO")
    if "REGISTRY" not in all_runs:
        errors.append("ningún step usa REGISTRY")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Variables de entorno correctas")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
