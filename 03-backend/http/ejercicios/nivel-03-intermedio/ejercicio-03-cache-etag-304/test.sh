#!/usr/bin/env bash
# Validación del ejercicio 03 (nivel 3) - caché ETag y 304.
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

# Validar peticiones.http: hay dos GET /recurso, uno con If-None-Match
COUNT_GET=$(grep -c '^GET /recurso HTTP/1\.1$' "$REQ")
[[ "$COUNT_GET" -ge 2 ]] || { echo "FAIL: faltan peticiones GET /recurso (esperadas 2)"; fail; }
grep -qi '^If-None-Match: "v1"$' "$REQ" || { echo "FAIL: falta If-None-Match: \"v1\""; fail; }

# Validar respuesta.json
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
PORT=8091
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/recurso" >/dev/null 2>&1 && break
  sleep 0.1
done

# 1ª petición: 200 + ETag
HEAD1=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/recurso")
CODE1=$(echo "$HEAD1" | head -1 | awk '{print $2}')
echo "$HEAD1" | grep -qi 'ETag: "v1"' || { echo "FAIL: 1ª respuesta sin ETag: \"v1\""; fail; }
[[ "$CODE1" == "200" ]] || { echo "FAIL: 1ª petición devolvió $CODE1, esperado 200"; fail; }

# 2ª petición con If-None-Match -> 304
CODE2=$(curl -s -o /dev/null -w "%{http_code}" -H 'If-None-Match: "v1"' "http://127.0.0.1:$PORT/recurso")
[[ "$CODE2" == "304" ]] || { echo "FAIL: 2ª petición devolvió $CODE2, esperado 304"; fail; }

# 3ª con ETag distinto -> 200
CODE3=$(curl -s -o /dev/null -w "%{http_code}" -H 'If-None-Match: "otro"' "http://127.0.0.1:$PORT/recurso")
[[ "$CODE3" == "200" ]] || { echo "FAIL: con ETag distinto devolvió $CODE3, esperado 200"; fail; }

echo "OK Tests pasaron"
