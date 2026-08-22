#!/usr/bin/env bash
# Validación del ejercicio 02 - Cookie Set-Cookie con atributos de seguridad.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

COOKIE_FILE="cookie.json"

if [[ ! -f "$COOKIE_FILE" ]]; then
  echo "FAIL: falta $COOKIE_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$COOKIE_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

sc = data.get("set_cookie", "")

# sid=sess_...
if "sid=sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3" not in sc:
    errors.append("set_cookie debe contener 'sid=sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3'")

# HttpOnly
if "HttpOnly" not in sc:
    errors.append("set_cookie debe contener 'HttpOnly'")

# Secure
if "Secure" not in sc:
    errors.append("set_cookie debe contener 'Secure'")

# SameSite=Lax
if "SameSite=Lax" not in sc:
    errors.append("set_cookie debe contener 'SameSite=Lax'")

# Path=/
if "Path=/" not in sc:
    errors.append("set_cookie debe contener 'Path=/'")

# Max-Age=3600
if "Max-Age=3600" not in sc:
    errors.append("set_cookie debe contener 'Max-Age=3600'")

# atributos: array con al menos 5 elementos
atributos = data.get("atributos", [])
if not isinstance(atributos, list) or len(atributos) < 5:
    errors.append(f"atributos debe ser un array con mínimo 5 elementos, tiene {len(atributos) if isinstance(atributos, list) else 'no es array'}")
else:
    for i, a in enumerate(atributos):
        if "nombre" not in a or "proposito" not in a:
            errors.append(f"atributo {i} debe tener 'nombre' y 'proposito'")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
