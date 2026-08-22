#!/usr/bin/env bash
# Validación del ejercicio 01 - Diseñar URL RESTful.
# Comprueba que respuesta.json es JSON válido y que cada operación mapea a
# "METODO /ruta" con método y ruta RESTful correctos (plurales, sin verbos).
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

# Validar que es JSON sintácticamente correcto
if ! python3 -m json.tool "$RESP" >/dev/null 2>&1; then
  echo "FAIL: $RESP no es JSON válido"
  python3 -m json.tool "$RESP" || true
  fail
fi

# Validar contenido con un script python embebido
python3 - "$RESP" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

ops = data.get("operaciones")
if not isinstance(ops, dict):
    errors.append("falta el objeto 'operaciones'")
    ops = {}

METHODS = {"GET", "POST", "PUT", "PATCH", "DELETE"}
EXPECTED = {
    "listar_productos": ("GET", "/products"),
    "obtener_producto_por_id": ("GET", "/products/"),
    "crear_producto": ("POST", "/products"),
    "reemplazar_producto": ("PUT", "/products/"),
    "modificar_precio_producto": ("PATCH", "/products/"),
    "borrar_producto": ("DELETE", "/products/"),
    "listar_pedidos_de_usuario": ("GET", "/users/"),
    "obtener_pedido_de_usuario": ("GET", "/users/"),
}

for key, (method, path_prefix) in EXPECTED.items():
    val = ops.get(key)
    if not val:
        errors.append(f"falta la operación '{key}'")
        continue
    parts = val.split(" ", 1)
    if len(parts) != 2:
        errors.append(f"'{key}'='{val}': formato debe ser 'METODO /ruta'")
        continue
    m, path = parts[0].upper(), parts[1]
    if m not in METHODS:
        errors.append(f"'{key}'='{val}': método '{m}' no es HTTP válido")
    if m != method:
        errors.append(f"'{key}'='{val}': método esperado {method}")
    if not path.startswith(path_prefix):
        errors.append(f"'{key}'='{val}': ruta debe empezar por {path_prefix}")
    # Anti-patrón: verbos en la ruta
    if re.search(r"/(get|post|put|patch|delete|create|update|list|find)[a-zA-Z]",
                 path, re.IGNORECASE):
        errors.append(f"'{key}'='{val}': la ruta contiene un verbo (anti-patrón RPC)")
    # Debe ser plural (products, users, orders)
    if not re.search(r"/(products|users|orders)(/|$)", path):
        errors.append(f"'{key}'='{val}': la ruta debe usar recursos en plural")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)

print("OK Tests pasaron")
PY
