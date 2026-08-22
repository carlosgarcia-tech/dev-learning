#!/usr/bin/env bash
# Validación del ejercicio 01 - Crear JWT con HMAC-SHA256.
# Verifica la estructura y la firma del JWT en token.jwt.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

TOKEN_FILE="token.jwt"
HEADER_FILE="header.json"
PAYLOAD_FILE="payload.json"

for f in "$TOKEN_FILE" "$HEADER_FILE" "$PAYLOAD_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$TOKEN_FILE" "$HEADER_FILE" "$PAYLOAD_FILE" <<'PY'
import base64, json, hmac, hashlib, sys, re

SECRET = b"super-secreto-2024"

def b64url_decode(s: str) -> bytes:
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

def b64url_encode(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

with open(sys.argv[1], encoding="utf-8") as f:
    token = f.read().strip()
with open(sys.argv[2], encoding="utf-8") as f:
    header_json = json.load(f)
with open(sys.argv[3], encoding="utf-8") as f:
    payload_json = json.load(f)

errors = []

# 1. El token tiene 3 partes
parts = token.split('.')
if len(parts) != 3:
    errors.append(f"El JWT debe tener 3 partes separadas por '.', tiene {len(parts)}")
    print_errors = True
else:
    header_b64, payload_b64, sig_b64 = parts

    # 2. No debe contener padding '='
    if '=' in token:
        errors.append("El JWT no debe contener padding '=' (base64url sin padding)")

    # 3. Decodificar header
    try:
        decoded_header = json.loads(b64url_decode(header_b64))
    except Exception as e:
        errors.append(f"No se pudo decodificar el header: {e}")
        decoded_header = {}

    if decoded_header.get("alg") != "HS256":
        errors.append(f"header.alg debe ser 'HS256', es '{decoded_header.get('alg')}'")
    if decoded_header.get("typ") != "JWT":
        errors.append(f"header.typ debe ser 'JWT', es '{decoded_header.get('typ')}'")

    # 4. Decodificar payload
    try:
        decoded_payload = json.loads(b64url_decode(payload_b64))
    except Exception as e:
        errors.append(f"No se pudo decodificar el payload: {e}")
        decoded_payload = {}

    for field in ("sub", "role", "iat", "exp"):
        if field not in decoded_payload:
            errors.append(f"payload debe tener '{field}'")

    # 5. Verificar la firma
    signing_input = f"{header_b64}.{payload_b64}".encode()
    expected_sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()
    expected_sig_b64 = b64url_encode(expected_sig)

    if not hmac.compare_digest(expected_sig_b64, sig_b64):
        errors.append("La firma HMAC-SHA256 no es válida")
        errors.append(f"  Esperada: {expected_sig_b64}")
        errors.append(f"  Recibida: {sig_b64}")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
