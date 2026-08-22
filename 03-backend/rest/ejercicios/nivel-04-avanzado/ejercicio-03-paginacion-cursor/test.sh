#!/usr/bin/env bash
# Validación del ejercicio 03 - Paginación con cursor.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
[[ -f "$RESP" ]] || { echo "FAIL: falta $RESP"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; python3 -m json.tool "$RESP" || true; fail; }

python3 - <<'PY'
import json, sys
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
errors = []
if r.get("status") != 200: errors.append("status debe ser 200")
b = r.get("body", {})
data = b.get("data")
if not isinstance(data, list) or len(data) != 2: errors.append("body.data debe tener 2 elementos")
pag = b.get("pagination", {})
if pag.get("limit") != 2: errors.append("pagination.limit debe ser 2")
nc = pag.get("nextCursor")
if not isinstance(nc, str) or len(nc) == 0: errors.append("pagination.nextCursor debe ser string no vacío")
if pag.get("hasMore") is not True: errors.append("pagination.hasMore debe ser true")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
