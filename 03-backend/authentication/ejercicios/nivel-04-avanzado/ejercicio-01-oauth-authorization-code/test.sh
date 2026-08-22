#!/usr/bin/env bash
# Validación del ejercicio 01 - OAuth authorization code flow.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

FLOW_FILE="flow.json"
CONF_FILE="config.json"

for f in "$FLOW_FILE" "$CONF_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$FLOW_FILE" "$CONF_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    flow = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    conf = json.load(f)

errors = []

pasos = flow.get("pasos", [])
if len(pasos) != 6:
    errors.append(f"Debe haber 6 pasos, hay {len(pasos)}")
else:
    # Paso 1: authorization_request
    p1 = pasos[0]
    if p1.get("nombre") != "authorization_request":
        errors.append(f"Paso 1: nombre debe ser 'authorization_request', es '{p1.get('nombre')}'")
    url1 = p1.get("url", "")
    if "response_type=code" not in url1:
        errors.append("Paso 1: url debe contener 'response_type=code'")
    if conf["client_id"] not in url1:
        errors.append("Paso 1: url debe contener el client_id")
    if conf["redirect_uri"] not in url1:
        errors.append("Paso 1: url debe contener el redirect_uri")
    if "scope" not in url1:
        errors.append("Paso 1: url debe contener scope")
    if "state" not in url1:
        errors.append("Paso 1: url debe contener state (protección CSRF)")
    
    # Paso 2: user_consent
    p2 = pasos[1]
    if p2.get("nombre") != "user_consent":
        errors.append(f"Paso 2: nombre debe ser 'user_consent', es '{p2.get('nombre')}'")
    if p2.get("consent") is not True:
        errors.append("Paso 2: consent debe ser true")
    
    # Paso 3: redirect_code
    p3 = pasos[2]
    if p3.get("nombre") != "redirect_code":
        errors.append(f"Paso 3: nombre debe ser 'redirect_code', es '{p3.get('nombre')}'")
    url3 = p3.get("url", "")
    if "code=" not in url3:
        errors.append("Paso 3: url debe contener 'code='")
    if "state=" not in url3:
        errors.append("Paso 3: url debe contener 'state='")
    # El state debe coincidir entre paso 1 y 3
    state1 = ""
    state3 = ""
    for part in url1.split("&"):
        if part.startswith("state="):
            state1 = part.split("=")[1]
    for part in url3.split("?")[1].split("&") if "?" in url3 else []:
        if part.startswith("state="):
            state3 = part.split("=")[1]
    if state1 and state3 and state1 != state3:
        errors.append(f"Paso 3: state debe coincidir con paso 1 ({state1} vs {state3})")
    
    # Paso 4: token_exchange
    p4 = pasos[3]
    if p4.get("nombre") != "token_exchange":
        errors.append(f"Paso 4: nombre debe ser 'token_exchange', es '{p4.get('nombre')}'")
    if p4.get("metodo") != "POST":
        errors.append("Paso 4: metodo debe ser POST")
    body4 = p4.get("body", {})
    if body4.get("grant_type") != "authorization_code":
        errors.append("Paso 4: body.grant_type debe ser 'authorization_code'")
    if "code" not in body4:
        errors.append("Paso 4: body debe contener 'code'")
    if body4.get("client_id") != conf["client_id"]:
        errors.append("Paso 4: body.client_id debe coincidir con config")
    if body4.get("client_secret") != conf["client_secret"]:
        errors.append("Paso 4: body.client_secret debe coincidir con config")
    if body4.get("redirect_uri") != conf["redirect_uri"]:
        errors.append("Paso 4: body.redirect_uri debe coincidir con config")
    
    # Paso 5: token_response
    p5 = pasos[4]
    if p5.get("nombre") != "token_response":
        errors.append(f"Paso 5: nombre debe ser 'token_response', es '{p5.get('nombre')}'")
    body5 = p5.get("body", {})
    if not body5.get("access_token"):
        errors.append("Paso 5: body debe tener access_token")
    if body5.get("token_type") != "Bearer":
        errors.append("Paso 5: token_type debe ser 'Bearer'")
    if "expires_in" not in body5:
        errors.append("Paso 5: body debe tener expires_in")
    if "scope" not in body5:
        errors.append("Paso 5: body debe tener scope")
    
    # Paso 6: api_call
    p6 = pasos[5]
    if p6.get("nombre") != "api_call":
        errors.append(f"Paso 6: nombre debe ser 'api_call', es '{p6.get('nombre')}'")
    headers6 = p6.get("headers", {})
    auth = headers6.get("Authorization", "")
    if not auth.startswith("Bearer "):
        errors.append("Paso 6: Authorization debe ser 'Bearer <token>'")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
