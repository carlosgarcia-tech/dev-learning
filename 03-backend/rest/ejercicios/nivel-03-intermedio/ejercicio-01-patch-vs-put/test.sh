#!/usr/bin/env bash
# Validación del ejercicio 01 - PATCH parcial vs PUT total.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_patch.json respuesta_put.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_patch.json", encoding="utf-8") as f:
    rp = json.load(f)
if rp.get("status") != 200: errors.append("respuesta_patch.status debe ser 200")
bp = rp.get("body", {})
if bp.get("price") != 99.90: errors.append("respuesta_patch body.price debe ser 99.90")
if bp.get("name") != "Teclado mecánico": errors.append("respuesta_patch body.name debe conservarse (PATCH parcial)")
if bp.get("stock") != 15: errors.append("respuesta_patch body.stock debe conservarse (PATCH parcial)")

with open("respuesta_put.json", encoding="utf-8") as f:
    ru = json.load(f)
if ru.get("status") != 422: errors.append("respuesta_put.status debe ser 422")
bu = ru.get("body", {})
fields = [e.get("field") for e in bu.get("errors", []) if isinstance(e, dict)]
if "name" not in fields: errors.append("respuesta_put debe reportar falta de 'name'")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
