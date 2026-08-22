#!/usr/bin/env bash
# Validación del ejercicio 04 - Content-Type y MIME types.
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

tipos = data.get("tipos")
if not isinstance(tipos, dict):
    print("FAIL: falta el objeto 'tipos'"); sys.exit(1)

# (clave, subtipo obligatorio en cualquier posición)
EXPECTED = {
    "json_api": "application/json",
    "pagina_html": "text/html",
    "imagen_png": "image/png",
    "formulario_clasico": "application/x-www-form-urlencoded",
    "subida_archivo": "multipart/form-data",
    "texto_plano": "text/plain",
    "binario_generico": "application/octet-stream",
    "documento_xml": "application/xml",
}

errors = []
for key, mime in EXPECTED.items():
    val = tipos.get(key)
    if not val:
        errors.append(f"falta '{key}'")
        continue
    # Aceptar "mime" o "mime; charset=utf-8"
    base = val.split(";", 1)[0].strip()
    if base.lower() != mime.lower():
        errors.append(f"'{key}': esperado '{mime}', recibido '{val}'")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)

print("OK Tests pasaron")
PY
