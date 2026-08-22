#!/usr/bin/env bash
# Validación del ejercicio 04 - POST crear recurso.
# Comprueba 201 Created, cabecera Location y body con id/timestamps del servidor.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"; PET="peticion.json"
[[ -f "$RESP" ]] || { echo "FAIL: falta $RESP"; fail; }
[[ -f "$PET" ]] || { echo "FAIL: falta $PET"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; python3 -m json.tool "$RESP" || true; fail; }

python3 - <<'PY'
import json, re, sys
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
with open("peticion.json", encoding="utf-8") as f:
    p = json.load(f)
errors = []
if r.get("status") != 201:
    errors.append(f"status debe ser 201, es {r.get('status')}")
h = r.get("headers", {})
if h.get("Content-Type") != "application/json":
    errors.append("headers.Content-Type debe ser application/json")
loc = h.get("Location", "")
if not re.match(r"^/products/[\w-]+$", loc):
    errors.append(f"headers.Location debe ser /products/<id>, es '{loc}'")
b = r.get("body", {})
if "id" not in b:
    errors.append("body.id debe estar presente (asignado por el servidor)")
sent = (p.get("body") or {})
for k in ("name", "price", "stock", "category"):
    if b.get(k) != sent.get(k):
        errors.append(f"body.{k} debe coincidir con la petición")
for k in ("createdAt", "updatedAt"):
    if not re.match(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$", str(b.get(k, ""))):
        errors.append(f"body.{k} debe ser ISO 8601 UTC con Z")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
