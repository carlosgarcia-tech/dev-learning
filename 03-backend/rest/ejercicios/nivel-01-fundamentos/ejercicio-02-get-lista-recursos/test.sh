#!/usr/bin/env bash
# Validación del ejercicio 02 - GET lista de recursos.
# Comprueba que respuesta.json es JSON válido y que representa una colección
# RESTful correcta: status 200, body.data array, pagination con limit/offset/total.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
[[ -f "$RESP" ]] || { echo "FAIL: falta $RESP"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; python3 -m json.tool "$RESP" || true; fail; }

python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    r = json.load(f)
errors = []
if r.get("status") != 200:
    errors.append(f"status debe ser 200, es {r.get('status')}")
if r.get("headers", {}).get("Content-Type") != "application/json":
    errors.append("headers.Content-Type debe ser application/json")
body = r.get("body", {})
data = body.get("data")
if not isinstance(data, list) or len(data) == 0:
    errors.append("body.data debe ser un array no vacío")
else:
    for i, p in enumerate(data):
        for k in ("id", "name", "price"):
            if k not in p:
                errors.append(f"body.data[{i}] falta el campo '{k}'")
        if not isinstance(p.get("price"), (int, float)):
            errors.append(f"body.data[{i}].price debe ser numérico")
pag = body.get("pagination")
if not isinstance(pag, dict):
    errors.append("body.pagination debe ser un objeto")
else:
    for k in ("limit", "offset", "total"):
        if not isinstance(pag.get(k), int):
            errors.append(f"pagination.{k} debe ser entero")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
