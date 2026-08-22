#!/usr/bin/env bash
# Validación del ejercicio 01 - Paginación limit/offset.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
[[ -f "$RESP" ]] || { echo "FAIL: falta $RESP"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; python3 -m json.tool "$RESP" || true; fail; }

python3 - <<'PY'
import json, sys, re
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
errors = []
if r.get("status") != 200:
    errors.append(f"status debe ser 200, es {r.get('status')}")
b = r.get("body", {})
data = b.get("data")
if not isinstance(data, list) or len(data) != 2:
    errors.append("body.data debe tener exactamente 2 elementos")
pag = b.get("pagination", {})
if pag.get("limit") != 2: errors.append("pagination.limit debe ser 2")
if pag.get("offset") != 2: errors.append("pagination.offset debe ser 2")
if pag.get("total") != 5: errors.append("pagination.total debe ser 5")
nxt = pag.get("next")
# offset=2, limit=2, total=5 -> next debe apuntar a offset=4
if nxt is not None and not re.search(r"offset=4", str(nxt)):
    errors.append(f"pagination.next debe apuntar a offset=4, es '{nxt}'")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
