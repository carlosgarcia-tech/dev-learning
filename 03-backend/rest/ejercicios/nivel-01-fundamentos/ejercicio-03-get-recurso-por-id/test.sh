#!/usr/bin/env bash
# Validación del ejercicio 03 - GET recurso por id.
# Comprueba respuesta 200 con body correcto y respuesta_404 con error RESTful.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

for f in respuesta.json respuesta_404.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, re, sys

with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
errors = []
if r.get("status") != 200:
    errors.append(f"status debe ser 200, es {r.get('status')}")
if r.get("headers", {}).get("Content-Type") != "application/json":
    errors.append("headers.Content-Type debe ser application/json")
b = r.get("body", {})
if b.get("id") != "prod_001":
    errors.append("body.id debe ser 'prod_001'")
for k in ("name", "price", "stock", "createdAt"):
    if k not in b:
        errors.append(f"body falta el campo '{k}'")
if not isinstance(b.get("price"), (int, float)):
    errors.append("body.price debe ser numérico")
if not isinstance(b.get("stock"), int):
    errors.append("body.stock debe ser entero")
if not re.match(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$", str(b.get("createdAt", ""))):
    errors.append("body.createdAt debe ser ISO 8601 UTC con Z")

with open("respuesta_404.json", encoding="utf-8") as f:
    e = json.load(f)
if e.get("status") != 404:
    errors.append(f"respuesta_404.status debe ser 404, es {e.get('status')}")
eb = e.get("body", {})
for k in ("type", "title", "status", "detail"):
    if k not in eb:
        errors.append(f"respuesta_404.body falta el campo '{k}'")
if eb.get("status") != 404:
    errors.append("respuesta_404.body.status debe ser 404")

if errors:
    for x in errors: print("  -", x)
    sys.exit(1)
print("OK Tests pasaron")
PY
