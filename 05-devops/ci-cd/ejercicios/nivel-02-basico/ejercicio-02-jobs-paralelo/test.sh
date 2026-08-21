#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 08 — Jobs en paralelo

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/paralelo.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
required = ["lint", "unit", "e2e"]
for name in required:
    if name not in jobs:
        errors.append(f"falta el job '{name}'")
    else:
        job = jobs[name]
        if "needs" in job:
            errors.append(f"el job '{name}' tiene needs (debe correr en paralelo)")
        if job.get("runs-on") != "ubuntu-latest":
            errors.append(f"el job '{name}' debe tener runs-on: ubuntu-latest")
        steps = job.get("steps", [])
        has_echo = any("echo" in (s.get("run","") or "") for s in steps)
        if not has_echo:
            errors.append(f"el job '{name}' no tiene un step con echo")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Jobs en paralelo correctos")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
