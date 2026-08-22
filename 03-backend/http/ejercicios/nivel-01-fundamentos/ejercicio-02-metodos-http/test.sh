#!/usr/bin/env bash
# Validación del ejercicio 02 - Métodos HTTP.
# Comprueba que respuesta.json asigna el método correcto a cada operación.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"

if [[ ! -f "$RESP" ]]; then
  echo "FAIL: falta $RESP"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

if ! python3 -m json.tool "$RESP" >/dev/null 2>&1; then
  echo "FAIL: $RESP no es JSON válido"
  fail
fi

python3 - "$RESP" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []
ops = data.get("operaciones")
if not isinstance(ops, dict):
    errors.append("falta el objeto 'operaciones'")
    ops = {}

EXPECTED = {
    "listar_productos": "GET",
    "obtener_producto_por_id": "GET",
    "crear_producto": "POST",
    "reemplazar_producto": "PUT",
    "modificar_precio_producto": "PATCH",
    "borrar_producto": "DELETE",
    "saber_metodos_soportados": "OPTIONS",
    "obtener_solo_headers": "HEAD",
}

for key, method in EXPECTED.items():
    val = ops.get(key)
    if not val:
        errors.append(f"falta la operación '{key}'")
        continue
    if not isinstance(val, str) or val.upper() != method:
        errors.append(f"'{key}': esperado '{method}', recibido '{val}'")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)

print("OK Tests pasaron")
PY
