#!/usr/bin/env bash
# Validación del ejercicio 06 - Sub-recursos anidados.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta.json respuesta_sub_item.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
if r.get("status") != 200: errors.append("respuesta.status debe ser 200")
data = r.get("body", {}).get("data")
if not isinstance(data, list) or len(data) == 0:
    errors.append("body.data debe ser un array no vacío")
else:
    for i, o in enumerate(data):
        for k in ("id", "status", "total"):
            if k not in o: errors.append(f"data[{i}] falta '{k}'")

with open("respuesta_sub_item.json", encoding="utf-8") as f:
    ri = json.load(f)
if ri.get("status") != 200: errors.append("respuesta_sub_item.status debe ser 200")
bi = ri.get("body", {})
if bi.get("id") != "ord_456": errors.append("respuesta_sub_item.body.id debe ser 'ord_456'")
if bi.get("userId") != "usr_123": errors.append("respuesta_sub_item.body.userId debe ser 'usr_123'")

if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
