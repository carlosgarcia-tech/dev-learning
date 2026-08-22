#!/usr/bin/env bash
# Validación del ejercicio 01 - TOTP MFA.
# Verifica que el código TOTP generado es correcto recalculándolo.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

TOTP_FILE="totp.json"

if [[ ! -f "$TOTP_FILE" ]]; then
  echo "FAIL: falta $TOTP_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$TOTP_FILE" <<'PY'
import hmac, hashlib, struct, base64, json, sys

def totp_code(secret_b32, timestamp):
    counter = timestamp // 30
    key = base64.b32decode(secret_b32)
    msg = struct.pack(">Q", counter)
    digest = hmac.new(key, msg, hashlib.sha1).digest()
    offset = digest[-1] & 0x0F
    code = struct.unpack(">I", digest[offset:offset+4])[0] & 0x7FFFFFFF
    return str(code % 1000000).zfill(6)

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

secret = data.get("secret", "")
timestamp = data.get("timestamp")

if secret != "JBSWY3DPEHPK3PXP":
    errors.append(f"secret debe ser 'JBSWY3DPEHPK3PXP', es '{secret}'")

if timestamp != 1700000000:
    errors.append(f"timestamp debe ser 1700000000, es {timestamp}")

# Recalcular el código TOTP esperado
expected_code = totp_code(secret, timestamp)
if data.get("codigo_generado") != expected_code:
    errors.append(f"codigo_generado incorrecto")
    errors.append(f"  Esperado: {expected_code}")
    errors.append(f"  Recibido: {data.get('codigo_generado')}")

# Ventana
if data.get("ventana_segundos") != 30:
    errors.append(f"ventana_segundos debe ser 30, es {data.get('ventana_segundos')}")

# Dígitos
if data.get("digitos") != 6:
    errors.append(f"digitos debe ser 6, es {data.get('digitos')}")

# Algoritmo
if data.get("algoritmo") != "HMAC-SHA1":
    errors.append(f"algoritmo debe ser 'HMAC-SHA1', es '{data.get('algoritmo')}'")

# otpauth_uri
uri = data.get("otpauth_uri", "")
if not uri.startswith("otpauth://totp/"):
    errors.append("otpauth_uri debe empezar por 'otpauth://totp/'")
if secret not in uri:
    errors.append("otpauth_uri debe contener el secret")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
