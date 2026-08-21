#!/usr/bin/env bash
set -euo pipefail

# Validador del ejercicio 14 — Build de Docker image

PASS=0
FAIL=0
ok() { echo "✅ $1"; PASS=$((PASS+1)); }
ko() { echo "❌ $1"; FAIL=$((FAIL+1)); }

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 no está instalado"; exit 1; }
python3 -c "import yaml" 2>/dev/null || { echo "❌ pyyaml no está instalado. Ejecuta: pip install pyyaml"; exit 1; }

WF=".github/workflows/docker.yml"
DF="Dockerfile"

[ -f "$WF" ] && ok "El archivo $WF existe" || ko "No existe $WF"
[ -f "$DF" ] && ok "El archivo $DF existe" || ko "No existe $DF"

# Validar Dockerfile
if [ -f "$DF" ]; then
    grep -qi "^FROM node:20-alpine" "$DF" && ok "Dockerfile usa node:20-alpine" || ko "Dockerfile no usa FROM node:20-alpine"
    grep -qi "^COPY" "$DF" && ok "Dockerfile tiene COPY" || ko "Dockerfile no tiene COPY"
    grep -qiE "^(CMD|ENTRYPOINT)" "$DF" && ok "Dockerfile tiene CMD o ENTRYPOINT" || ko "Dockerfile no tiene CMD/ENTRYPOINT"
fi

# Validar workflow
if [ -f "$WF" ]; then
python3 - "$WF" <<'PYEOF'
import sys, yaml
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)

errors = []
jobs = data.get("jobs", {})
job = jobs.get("build")
if not job:
    errors.append("falta el job 'build'")
else:
    steps = job.get("steps", [])
    has_checkout = any("actions/checkout" in (s.get("uses","") or "") for s in steps)
    if not has_checkout:
        errors.append("falta actions/checkout")
    has_buildx = any("setup-buildx-action" in (s.get("uses","") or "") for s in steps)
    if not has_buildx:
        errors.append("falta docker/setup-buildx-action")
    has_build_push = any("build-push-action" in (s.get("uses","") or "") for s in steps)
    if not has_build_push:
        errors.append("falta docker/build-push-action")

if errors:
    print("❌ " + "; ".join(errors))
    sys.exit(1)
print("✅ Workflow de Docker correcto")
PYEOF
fi

echo ""
echo "Resultados: $PASS pasaron, $FAIL fallaron"
if [ "$FAIL" -gt 0 ]; then echo "❌ Tests fallaron"; exit 1; fi
echo "✅ Tests pasaron"
exit 0
