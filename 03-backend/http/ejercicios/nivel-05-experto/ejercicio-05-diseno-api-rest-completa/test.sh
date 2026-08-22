#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 5) - diseño de API REST completa.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
EXP="expected.json"
REQ="peticiones.http"

for f in "$RESP" "$EXP" "$REQ"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

python3 - "$RESP" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

rutas = data.get("rutas")
if not isinstance(rutas, dict) or not rutas:
    print("FAIL: falta el objeto 'rutas' con operaciones"); sys.exit(1)

METHODS = {"GET", "POST", "PUT", "PATCH", "DELETE"}
errors = []

for key, val in rutas.items():
    parts = str(val).split(" ", 1)
    if len(parts) != 2:
        errors.append(f"'{key}'='{val}': formato debe ser 'METODO /ruta'"); continue
    m, path = parts[0].upper(), parts[1]
    if m not in METHODS:
        errors.append(f"'{key}'='{val}': método '{m}' no es HTTP válido")
    # Anti-patrón: verbos en la ruta
    if re.search(r"/(get|post|put|patch|delete|create|update|list|find|cancel)[a-zA-Z]",
                 path, re.IGNORECASE):
        errors.append(f"'{key}'='{val}': la ruta contiene un verbo (anti-patrón RPC)")
    # Debe usar plurales
    if not re.search(r"/(products|users|orders|items)(/|\{|$)", path):
        errors.append(f"'{key}'='{val}': la ruta debe usar recursos en plural")

# Comprobar operaciones clave
EXPECTED = {
    "listar_productos": "GET",
    "crear_producto": "POST",
    "borrar_producto": "DELETE",
    "listar_pedidos_de_usuario": "GET",
    "crear_pedido_de_usuario": "POST",
    "cancelar_pedido": "PATCH",
}
for key, method in EXPECTED.items():
    val = rutas.get(key)
    if not val:
        errors.append(f"falta la operación '{key}'"); continue
    if not str(val).startswith(method):
        errors.append(f"'{key}': esperado método {method}")

# Anidación de sub-recursos
val = str(rutas.get("listar_pedidos_de_usuario", ""))
if not re.search(r"/users/\{[^}]+\}/orders", val):
    errors.append("listar_pedidos_de_usuario debe anidar: /users/{id}/orders")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)
print("OK rutas válidas")
PY

# Validar que peticiones.http tiene ejemplos coherentes
COUNT=$(grep -cE '^(GET|POST|PATCH|DELETE) ' "$REQ")
[[ "$COUNT" -ge 10 ]] || { echo "FAIL: peticiones.http debe tener al menos 10 peticiones (tiene $COUNT)"; fail; }

echo "OK Tests pasaron"
