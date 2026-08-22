#!/usr/bin/env bash
# Validación del ejercicio 02 - PKCE.
# Verifica que code_challenge = base64url(SHA256(code_verifier)).
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

PKCE_FILE="pkce.json"

if [[ ! -f "$PKCE_FILE" ]]; then
  echo "FAIL: falta $PKCE_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$PKCE_FILE" <<'PY'
import json, sys, re, hashlib, base64

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

verifier = data.get("code_verifier", "")
challenge = data.get("code_challenge", "")
method = data.get("code_challenge_method", "")

# code_verifier: 43-128 chars, solo [A-Za-z0-9-._~]
if len(verifier) < 43 or len(verifier) > 128:
    errors.append(f"code_verifier debe tener 43-128 caracteres, tiene {len(verifier)}")
if not re.match(r'^[A-Za-z0-9\-._~]+$', verifier):
    errors.append("code_verifier solo debe contener [A-Za-z0-9-._~]")

# code_challenge_method
if method != "S256":
    errors.append(f"code_challenge_method debe ser 'S256', es '{method}'")

# code_challenge: debe ser base64url(SHA256(code_verifier))
expected_digest = hashlib.sha256(verifier.encode()).digest()
expected_challenge = base64.urlsafe_b64encode(expected_digest).rstrip(b'=').decode('ascii')

if challenge != expected_challenge:
    errors.append(f"code_challenge incorrecto")
    errors.append(f"  Esperado: {expected_challenge}")
    errors.append(f"  Recibido: {challenge}")

# code_challenge no debe tener padding
if '=' in challenge:
    errors.append("code_challenge no debe contener padding '='")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
