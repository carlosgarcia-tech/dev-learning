#!/usr/bin/env bash
# Validación del ejercicio 03 - OIDC ID token.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

ID_FILE="id_token.jwt"
OIDC_FILE="oidc.json"

for f in "$ID_FILE" "$OIDC_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$ID_FILE" "$OIDC_FILE" <<'PY'
import base64, json, hmac, hashlib, sys

SECRET = b"super-secreto-2024"

def b64url_decode(s):
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

def b64url_encode(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

# Leer ID token
with open(sys.argv[1], encoding="utf-8") as f:
    token = f.read().strip()

with open(sys.argv[2], encoding="utf-8") as f:
    oidc = json.load(f)

errors = []

# 1. Token tiene 3 partes
parts = token.split('.')
if len(parts) != 3:
    errors.append(f"id_token.jwt debe tener 3 partes, tiene {len(parts)}")
else:
    header_b64, payload_b64, sig_b64 = parts
    
    # 2. Verificar firma
    signing_input = f"{header_b64}.{payload_b64}".encode()
    expected_sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()
    expected_sig_b64 = b64url_encode(expected_sig)
    if not hmac.compare_digest(expected_sig_b64, sig_b64):
        errors.append("La firma del ID token no es válida")
    
    # 3. Decodificar payload
    try:
        payload = json.loads(b64url_decode(payload_b64))
    except Exception as e:
        errors.append(f"No se pudo decodificar el payload: {e}")
        payload = {}
    
    # 4. Claims de identidad
    expected_claims = {
        "iss": "https://auth.example.com",
        "sub": "user-123",
        "aud": "client_123",
        "email": "alice@example.com",
        "email_verified": True,
        "name": "Alice García",
        "picture": "https://auth.example.com/avatar/123.png",
    }
    for claim, expected in expected_claims.items():
        if payload.get(claim) != expected:
            errors.append(f"payload.{claim} debe ser '{expected}', es '{payload.get(claim)}'")

# 5. oidc.json
if oidc.get("id_token_purpose") != "authentication":
    errors.append(f"id_token_purpose debe ser 'authentication', es '{oidc.get('id_token_purpose')}'")
if oidc.get("access_token_purpose") != "authorization":
    errors.append(f"access_token_purpose debe ser 'authorization', es '{oidc.get('access_token_purpose')}'")
if oidc.get("consumidor_id_token") != "client":
    errors.append(f"consumidor_id_token debe ser 'client', es '{oidc.get('consumidor_id_token')}'")
if oidc.get("consumidor_access_token") != "resource_server":
    errors.append(f"consumidor_access_token debe ser 'resource_server', es '{oidc.get('consumidor_access_token')}'")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
