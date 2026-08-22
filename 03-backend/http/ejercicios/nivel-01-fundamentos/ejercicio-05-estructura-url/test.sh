#!/usr/bin/env bash
# Validación del ejercicio 05 - Estructura de URL.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"

[[ -f "$RESP" ]] || { echo "FAIL: falta $RESP"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }

python3 - "$RESP" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

u = data.get("url")
if not isinstance(u, dict):
    print("FAIL: falta el objeto 'url'"); sys.exit(1)

checks = [
    ("esquema", "https"),
    ("host", "api.tienda.com"),
    ("puerto", "8443"),
    ("path", "/v1/products"),
    ("fragment", "resultados"),
]
errors = []
for key, val in checks:
    if str(u.get(key, "")) != val:
        errors.append(f"{key}: esperado '{val}', recibido '{u.get(key)}'")

q = u.get("query")
if not isinstance(q, dict):
    errors.append("query debe ser un objeto")
else:
    if str(q.get("limit")) != "10":
        errors.append(f"query.limit: esperado '10', recibido '{q.get('limit')}'")
    if str(q.get("sort")) != "desc":
        errors.append(f"query.sort: esperado 'desc', recibido '{q.get('sort')}'")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)

print("OK Tests pasaron")
PY
