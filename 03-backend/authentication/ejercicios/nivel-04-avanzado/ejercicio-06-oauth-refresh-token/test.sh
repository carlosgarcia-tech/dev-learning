#!/usr/bin/env bash
# Validación del ejercicio 06 - OAuth refresh token.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

FLOW_FILE="flow.json"
INIT_FILE="tokens_iniciales.json"

for f in "$FLOW_FILE" "$INIT_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$FLOW_FILE" "$INIT_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    flow = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    init = json.load(f)

errors = []

# refresh_request
req = flow.get("refresh_request", {})
if req.get("method") != "POST":
    errors.append(f"refresh_request.method debe ser 'POST', es '{req.get('method')}'")
if req.get("url") != init.get("token_endpoint"):
    errors.append(f"refresh_request.url debe ser '{init.get('token_endpoint')}', es '{req.get('url')}'")

body = req.get("body", {})
if body.get("grant_type") != "refresh_token":
    errors.append(f"body.grant_type debe ser 'refresh_token', es '{body.get('grant_type')}'")
if body.get("refresh_token") != init.get("refresh_token"):
    errors.append("body.refresh_token debe coincidir con tokens_iniciales")
if body.get("client_id") != init.get("client_id"):
    errors.append("body.client_id debe coincidir con tokens_iniciales")
if body.get("client_secret") != init.get("client_secret"):
    errors.append("body.client_secret debe coincidir con tokens_iniciales")

# refresh_response
resp = flow.get("refresh_response", {})
if not resp.get("access_token"):
    errors.append("refresh_response.access_token no puede estar vacío")
if resp.get("token_type") != "Bearer":
    errors.append(f"refresh_response.token_type debe ser 'Bearer', es '{resp.get('token_type')}'")
if "expires_in" not in resp:
    errors.append("refresh_response debe tener expires_in")

# El nuevo access_token debe ser distinto del expirado
if resp.get("access_token") == init.get("access_token_expirado"):
    errors.append("refresh_response.access_token debe ser NUEVO (distinto del expirado)")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
