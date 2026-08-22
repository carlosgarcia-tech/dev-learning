#!/usr/bin/env bash
# Validación del ejercicio 05 - Proveedor OAuth simulado.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

PROV_FILE="proveedor.json"
FLOW_FILE="flow.json"

for f in "$PROV_FILE" "$FLOW_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$PROV_FILE" "$FLOW_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    prov = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    flow = json.load(f)

errors = []

# proveedor.json
p = prov.get("proveedor", {})
for field in ["nombre", "issuer", "authorization_endpoint", "token_endpoint", "userinfo_endpoint"]:
    if not p.get(field):
        errors.append(f"proveedor.{field} no puede estar vacío")

c = prov.get("cliente", {})
for field in ["client_id", "client_secret", "redirect_uri"]:
    if not c.get(field):
        errors.append(f"cliente.{field} no puede estar vacío")

scopes = prov.get("scopes_disponibles", [])
if not isinstance(scopes, list) or len(scopes) < 3:
    errors.append(f"scopes_disponibles debe tener al menos 3 elementos, tiene {len(scopes) if isinstance(scopes, list) else 'no es array'}")
else:
    for s in ["openid", "email", "profile"]:
        if s not in scopes:
            errors.append(f"scopes_disponibles debe contener '{s}'")

# flow.json
auth_url = flow.get("authorization_url", "")
if not auth_url:
    errors.append("authorization_url no puede estar vacío")
else:
    if "response_type=code" not in auth_url:
        errors.append("authorization_url debe contener 'response_type=code'")
    if c.get("client_id", "") not in auth_url:
        errors.append("authorization_url debe contener el client_id")
    if c.get("redirect_uri", "") not in auth_url:
        errors.append("authorization_url debe contener el redirect_uri")
    if "scope" not in auth_url:
        errors.append("authorization_url debe contener scope")
    if "state" not in auth_url:
        errors.append("authorization_url debe contener state")

te = flow.get("token_exchange", {})
if te.get("method") != "POST":
    errors.append(f"token_exchange.method debe ser POST, es '{te.get('method')}'")
if not te.get("url"):
    errors.append("token_exchange.url no puede estar vacío")
params = te.get("params", {})
if params.get("grant_type") != "authorization_code":
    errors.append("token_exchange.params.grant_type debe ser 'authorization_code'")
if "code" not in params:
    errors.append("token_exchange.params debe contener 'code'")
if params.get("client_id") != c.get("client_id"):
    errors.append("token_exchange.params.client_id debe coincidir con proveedor")
if params.get("client_secret") != c.get("client_secret"):
    errors.append("token_exchange.params.client_secret debe coincidir con proveedor")

ui = flow.get("userinfo_response", {})
if not ui.get("email"):
    errors.append("userinfo_response.email no puede estar vacío")
if not ui.get("name"):
    errors.append("userinfo_response.name no puede estar vacío")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
