#!/usr/bin/env bash
# Validación del ejercicio 05 - Errores 404/400.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_404.json respuesta_400.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_404.json", encoding="utf-8") as f:
    r404 = json.load(f)
if r404.get("status") != 404: errors.append("respuesta_404.status debe ser 404")
if r404.get("headers", {}).get("Content-Type") != "application/problem+json":
    errors.append("respuesta_404 Content-Type debe ser application/problem+json")
b = r404.get("body", {})
for k in ("type", "title", "status", "detail"):
    if k not in b: errors.append(f"respuesta_404.body falta '{k}'")
if "prod_999" not in str(b.get("detail", "")):
    errors.append("respuesta_404.body.detail debe mencionar prod_999")

with open("respuesta_400.json", encoding="utf-8") as f:
    r400 = json.load(f)
if r400.get("status") != 400: errors.append("respuesta_400.status debe ser 400")
if r400.get("headers", {}).get("Content-Type") != "application/problem+json":
    errors.append("respuesta_400 Content-Type debe ser application/problem+json")
b = r400.get("body", {})
for k in ("type", "title", "status", "detail"):
    if k not in b: errors.append(f"respuesta_400.body falta '{k}'")
if "json" not in str(b.get("detail", "")).lower():
    errors.append("respuesta_400.body.detail debe mencionar JSON mal formado")

if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
