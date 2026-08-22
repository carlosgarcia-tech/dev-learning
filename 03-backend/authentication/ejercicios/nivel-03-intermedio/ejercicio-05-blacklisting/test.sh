#!/usr/bin/env bash
# Validación del ejercicio 05 - Blacklisting tokens.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

BL_FILE="blacklist.json"

if [[ ! -f "$BL_FILE" ]]; then
  echo "FAIL: falta $BL_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$BL_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# jti
if data.get("jti") != "tok_abc123":
    errors.append(f"jti debe ser 'tok_abc123', es '{data.get('jti')}'")

# token_exp y ahora_logout
if data.get("token_exp") != 1700003600:
    errors.append(f"token_exp debe ser 1700003600, es {data.get('token_exp')}")
if data.get("ahora_logout") != 1700000000:
    errors.append(f"ahora_logout debe ser 1700000000, es {data.get('ahora_logout')}")

# token_revocado
if data.get("token_revocado") is not True:
    errors.append("token_revocado debe ser true")

# razon_revocacion no vacía
if not data.get("razon_revocacion"):
    errors.append("razon_revocacion no puede estar vacía")

# ttl_blacklist_segundos = token_exp - ahora_logout = 3600
if data.get("ttl_blacklist_segundos") != 3600:
    errors.append(f"ttl_blacklist_segundos debe ser 3600, es {data.get('ttl_blacklist_segundos')}")

# verificacion
v = data.get("verificacion", {})

# antes_logout: en_blacklist=false, expirado=false, acceso_permitido=true
al = v.get("antes_logout", {})
if al.get("en_blacklist") is not False:
    errors.append("antes_logout.en_blacklist debe ser false")
if al.get("expirado") is not False:
    errors.append("antes_logout.expirado debe ser false")
if al.get("acceso_permitido") is not True:
    errors.append("antes_logout.acceso_permitido debe ser true")

# despues_logout: en_blacklist=true, expirado=false, acceso_permitido=false
dl = v.get("despues_logout", {})
if dl.get("en_blacklist") is not True:
    errors.append("despues_logout.en_blacklist debe ser true")
if dl.get("expirado") is not False:
    errors.append("despues_logout.expirado debe ser false")
if dl.get("acceso_permitido") is not False:
    errors.append("despues_logout.acceso_permitido debe ser false")

# despues_expiracion: en_blacklist=false, expirado=true, acceso_permitido=false
de = v.get("despues_expiracion", {})
if de.get("en_blacklist") is not False:
    errors.append("despues_expiracion.en_blacklist debe ser false")
if de.get("expirado") is not True:
    errors.append("despues_expiracion.expirado debe ser true")
if de.get("acceso_permitido") is not False:
    errors.append("despues_expiracion.acceso_permitido debe ser false")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
