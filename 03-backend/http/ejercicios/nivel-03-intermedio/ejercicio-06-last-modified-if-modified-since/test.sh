#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 3) - Last-Modified e If-Modified-Since.
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

COUNT_GET=$(grep -c '^GET /doc HTTP/1\.1$' "$REQ")
[[ "$COUNT_GET" -ge 2 ]] || { echo "FAIL: faltan peticiones GET /doc (esperadas 2)"; fail; }
grep -qi '^If-Modified-Since: Wed, 21 Oct 2025 07:28:00 GMT$' "$REQ" \
  || { echo "FAIL: falta If-Modified-Since correcto"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
if data.get("primera") != 200:
    print("FAIL: primera debe ser 200"); sys.exit(1)
if data.get("segunda") != 304:
    print("FAIL: segunda debe ser 304"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8094
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/doc" >/dev/null 2>&1 && break
  sleep 0.1
done

# 1ª sin If-Modified-Since -> 200 + Last-Modified
HEAD1=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/doc")
CODE1=$(echo "$HEAD1" | head -1 | awk '{print $2}')
[[ "$CODE1" == "200" ]] || { echo "FAIL: 1ª devolvió $CODE1, esperado 200"; fail; }
echo "$HEAD1" | grep -qi 'Last-Modified: Wed, 21 Oct 2025 07:28:00 GMT' \
  || { echo "FAIL: 1ª sin Last-Modified correcto"; fail; }

# 2ª con If-Modified-Since igual -> 304
CODE2=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "If-Modified-Since: Wed, 21 Oct 2025 07:28:00 GMT" \
  "http://127.0.0.1:$PORT/doc")
[[ "$CODE2" == "304" ]] || { echo "FAIL: 2ª devolvió $CODE2, esperado 304"; fail; }

# 3ª con fecha anterior -> 200
CODE3=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "If-Modified-Since: Tue, 20 Oct 2025 07:28:00 GMT" \
  "http://127.0.0.1:$PORT/doc")
[[ "$CODE3" == "200" ]] || { echo "FAIL: con fecha anterior devolvió $CODE3, esperado 200"; fail; }

echo "OK Tests pasaron"
