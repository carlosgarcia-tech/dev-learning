#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 3) - autenticación Basic.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

REQ="peticiones.http"
RESP="respuesta.json"
SRV="server.sh"

for f in "$REQ" "$RESP" "$SRV"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v curl >/dev/null 2>&1 || { echo "FAIL: se requiere curl"; fail; }

grep -q '^GET /privado HTTP/1\.1$' "$REQ" || { echo "FAIL: falta GET /privado"; fail; }
grep -qi '^Authorization: Basic YWRtaW46c2VjcmV0bw==$' "$REQ" \
  || { echo "FAIL: falta Authorization: Basic correcto"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
if data.get("status") != 200:
    print("FAIL: status debe ser 200"); sys.exit(1)
if data.get("sin_auth") != 401:
    print("FAIL: sin_auth debe ser 401"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8093
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/privado" >/dev/null 2>&1 && break
  sleep 0.1
done

# Sin auth -> 401 + WWW-Authenticate
HEAD_NO=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/privado")
CODE_NO=$(echo "$HEAD_NO" | head -1 | awk '{print $2}')
[[ "$CODE_NO" == "401" ]] || { echo "FAIL: sin auth devolvió $CODE_NO, esperado 401"; fail; }
echo "$HEAD_NO" | grep -qi 'WWW-Authenticate: Basic' || { echo "FAIL: falta WWW-Authenticate: Basic"; fail; }

# Con auth correcta -> 200
CODE_OK=$(curl -s -o /dev/null -w "%{http_code}" -u admin:secreto "http://127.0.0.1:$PORT/privado")
[[ "$CODE_OK" == "200" ]] || { echo "FAIL: con auth devolvió $CODE_OK, esperado 200"; fail; }

# Con auth incorrecta -> 401
CODE_BAD=$(curl -s -o /dev/null -w "%{http_code}" -u admin:mala "http://127.0.0.1:$PORT/privado")
[[ "$CODE_BAD" == "401" ]] || { echo "FAIL: con auth mala devolvió $CODE_BAD, esperado 401"; fail; }

echo "OK Tests pasaron"
