#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 3) - CORS preflight.
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

# Validar peticiones.http
grep -q '^OPTIONS /datos HTTP/1\.1$' "$REQ" || { echo "FAIL: falta OPTIONS /datos"; fail; }
grep -qi '^Origin: https://app.tienda.com$' "$REQ" || { echo "FAIL: falta Origin"; fail; }
grep -qi '^Access-Control-Request-Method: POST$' "$REQ" || { echo "FAIL: falta Access-Control-Request-Method: POST"; fail; }
grep -q '^POST /datos HTTP/1\.1$' "$REQ" || { echo "FAIL: falta POST /datos"; fail; }

# Validar respuesta.json
python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
h = data.get("headers_preflight", {})
required = {
    "Access-Control-Allow-Origin": "https://app.tienda.com",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
}
for k, v in required.items():
    val = h.get(k, "")
    if v.lower() not in val.lower():
        print(f"FAIL: {k} debe contener '{v}', recibido '{val}'"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8090
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s -X OPTIONS "http://127.0.0.1:$PORT/datos" -o /dev/null 2>&1 && break
  sleep 0.1
done

# Preflight real
PREF=$(curl -s -D - -o /dev/null -X OPTIONS "http://127.0.0.1:$PORT/datos" \
  -H "Origin: https://app.tienda.com" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type")

echo "$PREF" | grep -qi 'Access-Control-Allow-Origin: https://app.tienda.com' \
  || { echo "FAIL: el preflight no devuelve Access-Control-Allow-Origin correcto"; fail; }
echo "$PREF" | grep -qi 'Access-Control-Allow-Methods' \
  || { echo "FAIL: el preflight no devuelve Access-Control-Allow-Methods"; fail; }
echo "$PREF" | grep -qi 'Access-Control-Allow-Headers' \
  || { echo "FAIL: el preflight no devuelve Access-Control-Allow-Headers"; fail; }

# POST real con Origin -> 200
CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "http://127.0.0.1:$PORT/datos" \
  -H "Origin: https://app.tienda.com" \
  -H "Content-Type: application/json" -d '{"valor":"hola"}')
[[ "$CODE" == "200" ]] || { echo "FAIL: POST real devolvió $CODE, esperado 200"; fail; }

echo "OK Tests pasaron"
