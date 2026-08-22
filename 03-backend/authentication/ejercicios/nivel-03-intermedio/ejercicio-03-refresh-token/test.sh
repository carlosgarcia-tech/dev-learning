#!/usr/bin/env bash
# Validación del ejercicio 03 - Refresh token.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

TOK_FILE="tokens.json"

if [[ ! -f "$TOK_FILE" ]]; then
  echo "FAIL: falta $TOK_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$TOK_FILE" <<'PY'
import base64, json, hmac, hashlib, sys

SECRET = b"super-secreto-2024"

def b64url_decode(s):
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

def b64url_encode(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

def verify_token(token_obj, expected_type, expected_ttl, token_name):
    token = token_obj.get("token", "")
    parts = token.split(".")
    if len(parts) != 3:
        errors.append(f"{token_name}: debe ser un JWT con 3 partes")
        return
    
    header_b64, payload_b64, sig_b64 = parts
    
    # Verificar firma
    signing_input = f"{header_b64}.{payload_b64}".encode()
    expected_sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()
    expected_sig_b64 = b64url_encode(expected_sig)
    if not hmac.compare_digest(expected_sig_b64, sig_b64):
        errors.append(f"{token_name}: la firma no es válida")
    
    # Decodificar payload
    try:
        payload = json.loads(b64url_decode(payload_b64))
    except Exception:
        errors.append(f"{token_name}: no se pudo decodificar el payload")
        return
    
    # type
    if payload.get("type") != expected_type:
        errors.append(f"{token_name}: type debe ser '{expected_type}', es '{payload.get('type')}'")
    
    # iat y exp
    iat = payload.get("iat")
    exp = payload.get("exp")
    if not iat or not exp:
        errors.append(f"{token_name}: faltan iat o exp")
        return
    
    ttl = exp - iat
    if ttl != expected_ttl:
        errors.append(f"{token_name}: TTL debe ser {expected_ttl}s, es {ttl}s")
    
    # ttl_segundos en el JSON
    if token_obj.get("ttl_segundos") != expected_ttl:
        errors.append(f"{token_name}: ttl_segundos debe ser {expected_ttl}, es {token_obj.get('ttl_segundos')}")
    
    # type en el JSON
    if token_obj.get("type") != expected_type:
        errors.append(f"{token_name}: type (json) debe ser '{expected_type}', es '{token_obj.get('type')}'")
    
    return payload

at = data.get("access_token", {})
rt = data.get("refresh_token", {})

at_payload = verify_token(at, "access", 900, "access_token")
rt_payload = verify_token(rt, "refresh", 604800, "refresh_token")

# Ambos tokens deben tener el mismo sub
if at_payload and rt_payload:
    if at_payload.get("sub") != rt_payload.get("sub"):
        errors.append(f"access_token y refresh_token deben tener el mismo sub: {at_payload.get('sub')} vs {rt_payload.get('sub')}")
    if at_payload.get("sub") != data.get("user_id"):
        errors.append(f"sub debe coincidir con user_id ({data.get('user_id')})")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
