#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 17 — Artifacts entre jobs

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

for name in ["build", "test", "package"]:
    if name not in jobs:
        errors.append(f"falta el job '{name}'")

if "build" in jobs:
    steps = jobs["build"].get("steps", [])
    has_upload = any("upload-artifact" in (s.get("uses","") or "") for s in steps)
    if not has_upload:
        errors.append("build no usa upload-artifact")

if "test" in jobs:
    needs = jobs["test"].get("needs", "")
    if needs != "build" and (not isinstance(needs, list) or "build" not in needs):
        errors.append("test debe tener needs: build")
    steps = jobs["test"].get("steps", [])
    has_download = any("download-artifact" in (s.get("uses","") or "") for s in steps)
    if not has_download:
        errors.append("test no usa download-artifact")

if "package" in jobs:
    needs = jobs["package"].get("needs", "")
    if needs != "test" and (not isinstance(needs, list) or "test" not in needs):
        errors.append("package debe tener needs: test")
    steps = jobs["package"].get("steps", [])
    has_download = any("download-artifact" in (s.get("uses","") or "") for s in steps)
    if not has_download:
        errors.append("package no usa download-artifact")
    has_tar = any("tar" in (s.get("run","") or "") for s in steps)
    if not has_tar:
        errors.append("package no crea tar.gz")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Artifacts entre jobs correctos")
PYEOF

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
