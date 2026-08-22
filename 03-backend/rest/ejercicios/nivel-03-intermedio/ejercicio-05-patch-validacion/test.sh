#!/usr/bin/env bash
# Validación del ejercicio 05 - PATCH con validación (error 422).
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
if r.get("status") != 422: errors.append(f"status debe ser 422, es {r.get('status')}")
if r.get("headers", {}).get("Content-Type") != "application/problem+json":
    errors.append("Content-Type debe ser application/problem+json")
b = r.get("body", {})
errs = b.get("errors")
if not isinstance(errs, list) or len(errs) < 3:
    errors.append("body.errors debe tener al menos 3 errores")
else:
    fields = set()
    for e in errs:
        for k in ("field", "code", "message"):
            if k not in e: errors.append(f"cada error debe tener '{k}': {e}")
        fields.add(e.get("field"))
    for f in ("price", "stock", "category"):
        if f not in fields: errors.append(f"falta error para '{f}'")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
