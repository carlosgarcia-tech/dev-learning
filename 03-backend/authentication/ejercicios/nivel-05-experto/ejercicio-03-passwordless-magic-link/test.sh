#!/usr/bin/env bash
# Validación del ejercicio 03 - Passwordless magic link.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

ML_FILE="magic_link.json"

if [[ ! -f "$ML_FILE" ]]; then
  echo "FAIL: falta $ML_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$ML_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# email
if data.get("email") != "alice@example.com":
    errors.append(f"email debe ser 'alice@example.com', es '{data.get('email')}'")

# token: no vacío, mínimo 32 chars
token = data.get("token", "")
if not token:
    errors.append("token no puede estar vacío")
elif len(token) < 32:
    errors.append(f"token debe tener mínimo 32 caracteres, tiene {len(token)}")

# url_magic: https:// y contiene token=
url = data.get("url_magic", "")
if not url.startswith("https://"):
    errors.append("url_magic debe empezar por 'https://'")
if "token=" not in url:
    errors.append("url_magic debe contener 'token='")
if token and token not in url:
    errors.append("url_magic debe contener el token")

# ttl_segundos = 900
if data.get("ttl_segundos") != 900:
    errors.append(f"ttl_segundos debe ser 900, es {data.get('ttl_segundos')}")

# usado: false inicialmente
if data.get("usado") is not False:
    errors.append("usado debe ser false (inicialmente)")

# flujo: mínimo 5 pasos
flujo = data.get("flujo", [])
if len(flujo) < 5:
    errors.append(f"flujo debe tener mínimo 5 pasos, tiene {len(flujo)}")

# verificacion_reuso
vr = data.get("verificacion_reuso", {})
if vr.get("denegado") is not True:
    errors.append("verificacion_reuso.denegado debe ser true")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
