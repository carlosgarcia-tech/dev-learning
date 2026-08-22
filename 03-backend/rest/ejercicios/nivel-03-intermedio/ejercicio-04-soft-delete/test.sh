#!/usr/bin/env bash
# Validación del ejercicio 04 - Soft delete.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_delete.json respuesta_get_despues.json respuesta_get_con_include.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_delete.json", encoding="utf-8") as f:
    rd = json.load(f)
if rd.get("status") not in (200, 204): errors.append(f"respuesta_delete.status debe ser 200 o 204, es {rd.get('status')}")
bd = rd.get("body", {})
if rd.get("status") == 200 and not bd.get("deletedAt"): errors.append("respuesta_delete 200 debe incluir deletedAt")

with open("respuesta_get_despues.json", encoding="utf-8") as f:
    rg = json.load(f)
if rg.get("status") != 404: errors.append("respuesta_get_despues.status debe ser 404 (borrado no visible por defecto)")

with open("respuesta_get_con_include.json", encoding="utf-8") as f:
    ri = json.load(f)
if ri.get("status") != 200: errors.append("respuesta_get_con_include.status debe ser 200")
bi = ri.get("body", {})
if bi.get("deleted") is not True: errors.append("respuesta_get_con_include.body.deleted debe ser true")
if not bi.get("deletedAt"): errors.append("respuesta_get_con_include.body.deletedAt debe estar seteado")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
