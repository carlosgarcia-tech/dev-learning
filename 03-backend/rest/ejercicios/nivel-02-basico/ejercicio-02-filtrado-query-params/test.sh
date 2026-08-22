#!/usr/bin/env bash
# Validación del ejercicio 02 - Filtrado por query params.
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
if r.get("status") != 200:
    errors.append(f"status debe ser 200, es {r.get('status')}")
data = r.get("body", {}).get("data")
if not isinstance(data, list) or len(data) == 0:
    errors.append("body.data debe ser un array no vacío")
else:
    for i, p in enumerate(data):
        if p.get("category") != "perifericos":
            errors.append(f"data[{i}].category debe ser 'perifericos' (filtro no aplicado)")
        if not isinstance(p.get("stock"), int) or p.get("stock") <= 0:
            errors.append(f"data[{i}].stock debe ser > 0 (filtro in_stock)")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
