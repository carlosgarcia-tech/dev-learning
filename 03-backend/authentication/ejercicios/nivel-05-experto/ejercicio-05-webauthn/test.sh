#!/usr/bin/env bash
# Validación del ejercicio 05 - WebAuthn.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

WA_FILE="webauthn.json"

if [[ ! -f "$WA_FILE" ]]; then
  echo "FAIL: falta $WA_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$WA_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# Registro
reg = data.get("registro", {})
challenge_reg = reg.get("challenge", "")
if len(challenge_reg) < 16:
    errors.append(f"registro.challenge debe tener mínimo 16 caracteres, tiene {len(challenge_reg)}")

rp = reg.get("rp", {})
if not rp.get("name"):
    errors.append("registro.rp.name no puede estar vacío")
if not rp.get("id"):
    errors.append("registro.rp.id no puede estar vacío (dominio)")

user = reg.get("user", {})
if not user.get("id"):
    errors.append("registro.user.id no puede estar vacío")

pkcp = reg.get("pubKeyCredParams", [])
if not isinstance(pkcp, list) or len(pkcp) < 1:
    errors.append("registro.pubKeyCredParams debe ser un array con al menos 1 elemento")

# Respuesta de registro
reg_resp = data.get("registro_respuesta", {})
if not reg_resp.get("credential_id"):
    errors.append("registro_respuesta.credential_id no puede estar vacío")
if not reg_resp.get("public_key"):
    errors.append("registro_respuesta.public_key no puede estar vacío")

# Login
login = data.get("login", {})
challenge_login = login.get("challenge", "")
if len(challenge_login) < 16:
    errors.append(f"login.challenge debe tener mínimo 16 caracteres, tiene {len(challenge_login)}")

# El challenge de login debe ser distinto del de registro
if challenge_login == challenge_reg and challenge_reg:
    errors.append("login.challenge debe ser distinto del challenge de registro")

# Respuesta de login
login_resp = data.get("login_respuesta", {})
if not login_resp.get("signature"):
    errors.append("login_respuesta.signature no puede estar vacío")
if login_resp.get("verified") is not True:
    errors.append("login_respuesta.verified debe ser true")

# phishing_resistant
if data.get("phishing_resistant") is not True:
    errors.append("phishing_resistant debe ser true")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
