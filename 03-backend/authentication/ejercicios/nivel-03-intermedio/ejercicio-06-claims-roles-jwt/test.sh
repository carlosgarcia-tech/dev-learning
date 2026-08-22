#!/usr/bin/env bash
# Validación del ejercicio 06 - Claims y roles en JWT.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

TOK_FILE="token.jwt"
AUT_FILE="autorizacion.json"

for f in "$TOK_FILE" "$AUT_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$TOK_FILE" "$AUT_FILE" <<'PY'
import base64, json, hmac, hashlib, sys

SECRET = b"super-secreto-2024"

def b64url_decode(s):
    padding = 4 - len(s) % 4
    if padding != 4:
        s += '=' * padding
    return base64.urlsafe_b64decode(s)

def b64url_encode(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('ascii')

# Leer token del estudiante
with open(sys.argv[1], encoding="utf-8") as f:
    token = f.read().strip()

with open(sys.argv[2], encoding="utf-8") as f:
    aut = json.load(f)

errors = []

# 1. Token tiene 3 partes
parts = token.split('.')
if len(parts) != 3:
    errors.append(f"token.jwt debe tener 3 partes, tiene {len(parts)}")
else:
    header_b64, payload_b64, sig_b64 = parts
    
    # 2. Verificar firma
    signing_input = f"{header_b64}.{payload_b64}".encode()
    expected_sig = hmac.new(SECRET, signing_input, hashlib.sha256).digest()
    expected_sig_b64 = b64url_encode(expected_sig)
    if not hmac.compare_digest(expected_sig_b64, sig_b64):
        errors.append("La firma del token no es válida")
    
    # 3. Decodificar payload
    try:
        payload = json.loads(b64url_decode(payload_b64))
    except Exception as e:
        errors.append(f"No se pudo decodificar el payload: {e}")
        payload = {}
    
    # 4. Claims esperados
    if payload.get("role") != "admin":
        errors.append(f"payload.role debe ser 'admin', es '{payload.get('role')}'")
    
    perms = payload.get("permissions", [])
    if not isinstance(perms, list):
        errors.append("payload.permissions debe ser un array")
    else:
        for p in ["users:read", "users:write", "users:delete"]:
            if p not in perms:
                errors.append(f"permissions debe contener '{p}'")

# 5. autorizacion.json: payload_decodificado debe coincidir con el del token
dec = aut.get("payload_decodificado")
if dec:
    if dec.get("role") != "admin":
        errors.append("payload_decodificado.role debe ser 'admin'")
    if not isinstance(dec.get("permissions"), list):
        errors.append("payload_decodificado.permissions debe ser un array")
else:
    errors.append("payload_decodificado no puede ser null")

# 6. Checks
checks = aut.get("checks", [])
if len(checks) != 3:
    errors.append(f"Debe haber 3 checks, hay {len(checks)}")
else:
    expected = [
        ("users:read", True),
        ("users:delete", True),
        ("posts:write", False),
    ]
    for i, (recurso, permitido) in enumerate(expected):
        c = checks[i]
        if c.get("recurso") != recurso:
            errors.append(f"Check {i}: recurso debe ser '{recurso}', es '{c.get('recurso')}'")
        if c.get("permitido") is not permitido:
            errors.append(f"Check {i} ({recurso}): permitido debe ser {permitido}, es {c.get('permitido')}")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
