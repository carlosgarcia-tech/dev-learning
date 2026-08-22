#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 4) - JWT decode y verify.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

EXP="expected.json"
SRV="server.sh"
REQ="peticiones.http"

for f in "$EXP" "$SRV" "$REQ"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v curl >/dev/null 2>&1 || { echo "FAIL: se requiere curl"; fail; }

python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Validar estructura del expected
python3 - "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    e = json.load(f)
if e.get("sub") != "user_42":
    print("FAIL: sub debe ser 'user_42'"); sys.exit(1)
if e.get("role") != "admin":
    print("FAIL: role debe ser 'admin'"); sys.exit(1)
if "iat" not in e or "exp" not in e:
    print("FAIL: faltan iat/exp"); sys.exit(1)
print("OK expected válido")
PY

# peticiones.http menciona Bearer
grep -qi '^Authorization: Bearer' "$REQ" || { echo "FAIL: falta Authorization: Bearer en peticiones.http"; fail; }

# Generar el token.txt si no existe (arrancando el servidor brevemente, o generándolo con python)
if [[ ! -f token.txt ]]; then
  python3 - <<'PY'
import hmac, hashlib, base64, json, os
SECRET = b"supersecreto"
HEADER = {"alg": "HS256", "typ": "JWT"}
PAYLOAD = {"sub": "user_42", "role": "admin", "iat": 1724304000, "exp": 9999999999}
def b64url(d): return base64.urlsafe_b64encode(d).rstrip(b"=").decode("ascii")
h = b64url(json.dumps(HEADER, separators=(",", ":")).encode())
p = b64url(json.dumps(PAYLOAD, separators=(",", ":")).encode())
s = b64url(hmac.new(SECRET, (h+"."+p).encode(), hashlib.sha256).digest())
with open("token.txt", "w") as f:
    f.write(f"{h}.{p}.{s}")
print("token.txt generado")
PY
fi

TOKEN=$(cat token.txt | tr -d '\n\r ')

# 1. Decodificar el payload y comparar con expected.json
python3 - "$TOKEN" "$EXP" <<'PY'
import json, sys, base64
token, exp_file = sys.argv[1], sys.argv[2]
parts = token.split(".")
if len(parts) != 3:
    print("FAIL: el token no tiene 3 partes"); sys.exit(1)
p = parts[1]
p += "=" * (-len(p) % 4)
payload = json.loads(base64.urlsafe_b64decode(p))
with open(exp_file, encoding="utf-8") as f:
    expected = json.load(f)
for k, v in expected.items():
    if payload.get(k) != v:
        print(f"FAIL: claim '{k}' = {payload.get(k)} != {v}"); sys.exit(1)
print("OK payload decodificado coincide con expected")
PY

# 2. Verificar la firma con el secreto
python3 - "$TOKEN" <<'PY'
import sys, hmac, hashlib, base64
token = sys.argv[1]
h, p, s = token.split(".")
signing_input = (h + "." + p).encode()
expected = base64.urlsafe_b64encode(
    hmac.new(b"supersecreto", signing_input, hashlib.sha256).digest()
).rstrip(b"=").decode()
if not hmac.compare_digest(expected, s):
    print("FAIL: la firma del JWT no es válida"); sys.exit(1)
print("OK firma válida")
PY

# 3. Levantar servidor y verificar /me con el token
PORT=8095
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/me" >/dev/null 2>&1 && break
  sleep 0.1
done

# Con token válido -> 200
CODE_OK=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" "http://127.0.0.1:$PORT/me")
[[ "$CODE_OK" == "200" ]] || { echo "FAIL: /me con token válido devolvió $CODE_OK, esperado 200"; fail; }

# Sin token -> 401
CODE_NO=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/me")
[[ "$CODE_NO" == "401" ]] || { echo "FAIL: /me sin token devolvió $CODE_NO, esperado 401"; fail; }

# Con token manipulado -> 401
BAD_TOKEN="${TOKEN%?}X"
CODE_BAD=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $BAD_TOKEN" "http://127.0.0.1:$PORT/me")
[[ "$CODE_BAD" == "401" ]] || { echo "FAIL: /me con token manipulado devolvió $CODE_BAD, esperado 401"; fail; }

echo "OK Tests pasaron"
