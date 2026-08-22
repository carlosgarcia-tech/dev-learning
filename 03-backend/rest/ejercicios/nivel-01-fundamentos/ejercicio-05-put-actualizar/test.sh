#!/usr/bin/env bash
# Validación del ejercicio 05 - PUT actualizar.
# Comprueba 200, id/createdAt conservados, updatedAt >= createdAt y campos actualizados.
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
from datetime import datetime
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
with open("peticion.json", encoding="utf-8") as f:
    p = json.load(f)
errors = []
if r.get("status") != 200:
    errors.append(f"status debe ser 200, es {r.get('status')}")
b = r.get("body", {})
if b.get("id") != "prod_001":
    errors.append("body.id debe conservarse como 'prod_001'")
prev = p.get("estado_previo", {})
if b.get("createdAt") != prev.get("createdAt"):
    errors.append("body.createdAt debe conservarse igual al estado previo")
def parse(s): return datetime.strptime(s.replace("Z",""), "%Y-%m-%dT%H:%M:%S")
try:
    if parse(b["createdAt"]) > parse(b["updatedAt"]):
        errors.append("body.updatedAt debe ser >= createdAt")
except Exception as ex:
    errors.append(f"fechas inválidas: {ex}")
sent = p.get("body", {})
for k in ("name", "price", "stock", "category"):
    if b.get(k) != sent.get(k):
        errors.append(f"body.{k} debe coincidir con la petición")
if not re.match(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$", str(b.get("updatedAt", ""))):
    errors.append("body.updatedAt debe ser ISO 8601 UTC con Z")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
