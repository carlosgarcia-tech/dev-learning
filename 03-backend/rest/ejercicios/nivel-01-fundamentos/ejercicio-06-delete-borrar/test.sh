#!/usr/bin/env bash
# Validación del ejercicio 06 - DELETE borrar.
# Comprueba respuesta 204 (sin body) o 200 (con confirmación) y un 404 RESTful.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

for f in respuesta.json respuesta_404.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
errors = []
status = r.get("status")
if status not in (200, 204):
    errors.append(f"status debe ser 204 o 200, es {status}")
if status == 204:
    if r.get("body") not in (None, {}):
        errors.append("con 204 el body debe ser null o ausente")
elif status == 200:
    b = r.get("body", {})
    if not isinstance(b, dict) or not b:
        errors.append("con 200 el body debe ser un objeto de confirmación")
    if b and not b.get("id"):
        errors.append("el body de confirmación debe incluir 'id'")

with open("respuesta_404.json", encoding="utf-8") as f:
    e = json.load(f)
if e.get("status") != 404:
    errors.append(f"respuesta_404.status debe ser 404, es {e.get('status')}")
eb = e.get("body", {})
for k in ("type", "title", "status", "detail"):
    if k not in eb:
        errors.append(f"respuesta_404.body falta el campo '{k}'")

if errors:
    for x in errors: print("  -", x)
    sys.exit(1)
print("OK Tests pasaron")
PY
