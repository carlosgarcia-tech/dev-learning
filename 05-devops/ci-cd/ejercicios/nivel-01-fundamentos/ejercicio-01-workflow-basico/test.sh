#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 01 — Workflow básico

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/basico.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
try:
    with open(sys.argv[1]) as f:
        data = yaml.safe_load(f)
except Exception as e:
    print(f"❌ YAML inválido: {e}")
    sys.exit(1)

errors = []
# name
if data.get("name") != "Basico":
    errors.append(f"name debe ser 'Basico', es {data.get('name')!r}")
# on (YAML 1.1 puede cargar 'on' como True)
on = data.get("on") or data.get(True)
if on is None:
    errors.append("falta el trigger 'on'")
elif on != "push" and (not isinstance(on, dict) or "push" not in on):
    errors.append(f"el trigger debe ser push, es {on!r}")
# jobs
jobs = data.get("jobs")
if not jobs or not isinstance(jobs, dict):
    errors.append("no hay jobs definidos")
    sys.exit("\n".join(errors))
# job hola
if "hola" not in jobs:
    errors.append("no existe el job 'hola'")
else:
    job = jobs["hola"]
    if job.get("runs-on") != "ubuntu-latest":
        errors.append(f"runs-on debe ser ubuntu-latest, es {job.get('runs-on')!r}")
    steps = job.get("steps")
    if not steps or not isinstance(steps, list) or len(steps) < 1:
        errors.append("el job 'hola' no tiene steps")
    else:
        has_echo = any("echo" in (s.get("run","") or "") for s in steps)
        if not has_echo:
            errors.append("ningún step ejecuta echo")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Estructura del workflow correcta")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then
    echo "❌ Tests fallaron"
    exit 1
fi
echo "✅ Tests pasaron"
exit 0
