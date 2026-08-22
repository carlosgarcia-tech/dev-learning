#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 4) - OAuth flow simulado.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

REQ="peticiones.http"
EXP="expected.json"
SRV="server.sh"

for f in "$REQ" "$EXP" "$SRV"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v curl >/dev/null 2>&1 || { echo "FAIL: se requiere curl"; fail; }

# Validar peticiones.http
grep -q '^GET /authorize' "$REQ" || { echo "FAIL: falta GET /authorize"; fail; }
grep -q '^POST /token' "$REQ" || { echo "FAIL: falta POST /token"; fail; }
grep -qi '^Authorization: Bearer' "$REQ" || { echo "FAIL: falta Authorization: Bearer"; fail; }

# Validar expected.json
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }
python3 - "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    e = json.load(f)
if e.get("authorize_status") != 302:
    print("FAIL: authorize_status debe ser 302"); sys.exit(1)
if e.get("token", {}).get("token_type") != "Bearer":
    print("FAIL: token.token_type debe ser 'Bearer'"); sys.exit(1)
if e.get("token", {}).get("expires_in") != 3600:
    print("FAIL: token.expires_in debe ser 3600"); sys.exit(1)
if e.get("perfil", {}).get("usuario") != "ana":
    print("FAIL: perfil.usuario debe ser 'ana'"); sys.exit(1)
print("OK expected válido")
PY

# Levantar servidor
PORT=8096
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/authorize" >/dev/null 2>&1 && break
  sleep 0.1
done

# Paso 1: authorize -> 302 + Location con code
AUTH_URL="http://127.0.0.1:$PORT/authorize?response_type=code&client_id=app123&redirect_uri=http://localhost:3000/cb&state=xyz"
HEAD1=$(curl -s -D - -o /dev/null "$AUTH_URL")
CODE1=$(echo "$HEAD1" | head -1 | awk '{print $2}')
[[ "$CODE1" == "302" ]] || { echo "FAIL: authorize devolvió $CODE1, esperado 302"; fail; }
echo "$HEAD1" | grep -qi 'Location: http://localhost:3000/cb?code=CODE_123&state=xyz' \
  || { echo "FAIL: Location del authorize incorrecto"; fail; }

# Paso 2: token -> access_token
TOKEN_RESP=$(curl -s -X POST "http://127.0.0.1:$PORT/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=authorization_code&code=CODE_123&client_id=app123&client_secret=secret")
ACCESS=$(python3 -c "import json,sys; print(json.loads(sys.argv[1])['access_token'])" "$TOKEN_RESP") \
  || { echo "FAIL: no se obtuvo access_token"; fail; }
[[ "$ACCESS" == "TOKEN_ABC" ]] || { echo "FAIL: access_token=$ACCESS, esperado TOKEN_ABC"; fail; }

# Paso 3: perfil con Bearer -> 200 + usuario
PERFIL=$(curl -s -H "Authorization: Bearer $ACCESS" "http://127.0.0.1:$PORT/api/perfil")
python3 - "$PERFIL" <<'PY'
import json, sys
d = json.loads(sys.argv[1])
if d.get("usuario") != "ana":
    print(f"FAIL: perfil.usuario = {d.get('usuario')}, esperado 'ana'"); sys.exit(1)
print("OK perfil correcto")
PY

# Token invalido -> 401
CODE_BAD=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer MALO" "http://127.0.0.1:$PORT/api/perfil")
[[ "$CODE_BAD" == "401" ]] || { echo "FAIL: token inválido devolvió $CODE_BAD, esperado 401"; fail; }

echo "OK Tests pasaron"
