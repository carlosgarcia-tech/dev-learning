#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 05 — Artifacts

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/artifacts.yml"

[ -f "$WF" ] && ok "El archivo $WF existe" || { ko "No existe $WF"; echo ""; echo "Resultados: $PASS pasaron, $FAIL fallaron"; echo "❌ Tests fallaron"; exit 1; }

python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})

if "crear" not in jobs:
    errors.append("falta el job 'crear'")
else:
    steps = jobs["crear"].get("steps", [])
    has_upload = any("upload-artifact" in (s.get("uses","") or "") for s in steps)
    if not has_upload:
        errors.append("el job 'crear' no usa upload-artifact")

if "leer" not in jobs:
    errors.append("falta el job 'leer'")
else:
    job = jobs["leer"]
    if job.get("needs") != "crear" and (not isinstance(job.get("needs"), list) or "crear" not in job.get("needs",[])):
        errors.append("el job 'leer' no tiene needs: crear")
    steps = job.get("steps", [])
    has_download = any("download-artifact" in (s.get("uses","") or "") for s in steps)
    if not has_download:
        errors.append("el job 'leer' no usa download-artifact")
    has_cat = any("cat" in (s.get("run","") or "") for s in steps)
    if not has_cat:
        errors.append("el job 'leer' no hace cat saludo.txt")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Artifacts y dependencias correctos")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
