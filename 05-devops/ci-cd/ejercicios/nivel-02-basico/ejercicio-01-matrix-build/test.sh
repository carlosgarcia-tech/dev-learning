#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 07 — Matrix build

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/matrix.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
job = jobs.get("test")
if not job:
    errors.append("falta el job 'test'")
else:
    strategy = job.get("strategy", {})
    matrix = strategy.get("matrix", {})
    node = matrix.get("node")
    if not node or 18 not in node or 20 not in node:
        errors.append(f"matrix.node debe ser [18, 20], es {node!r}")
    steps = job.get("steps", [])
    has_matrix_ref = False
    for s in steps:
        uses = s.get("uses","") or ""
        if "setup-node" in uses:
            w = s.get("with", {})
            if "matrix.node" in str(w.get("node-version","")):
                has_matrix_ref = True
    if not has_matrix_ref:
        errors.append("setup-node no usa ${{ matrix.node }}")
    has_node_ver = any("node --version" in (s.get("run","") or "") or "node -v" in (s.get("run","") or "") for s in steps)
    if not has_node_ver:
        errors.append("falta 'node --version'")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Matrix y referencias correctas")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
