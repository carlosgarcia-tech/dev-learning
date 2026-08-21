#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 04 — Usar una action pública

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/action.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
job = jobs.get("node")
if not job:
    errors.append("falta el job 'node'")
else:
    steps = job.get("steps", [])
    has_checkout = any("actions/checkout" in (s.get("uses","") or "") for s in steps)
    if not has_checkout:
        errors.append("falta actions/checkout")
    setup_step = None
    for s in steps:
        uses = s.get("uses","") or ""
        if "actions/setup-node" in uses:
            setup_step = s
            break
    if not setup_step:
        errors.append("falta actions/setup-node@v4")
    else:
        w = setup_step.get("with", {})
        nv = w.get("node-version")
        if str(nv) != "20":
            errors.append(f"node-version debe ser 20, es {nv!r}")
    has_node_ver = any("node --version" in (s.get("run","") or "") or "node -v" in (s.get("run","") or "") for s in steps)
    if not has_node_ver:
        errors.append("falta 'node --version'")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Actions y configuración correctas")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
