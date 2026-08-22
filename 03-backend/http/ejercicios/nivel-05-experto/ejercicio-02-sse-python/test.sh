#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 5) - SSE con python3.
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

grep -q '^GET /events HTTP/1\.1$' "$REQ" || { echo "FAIL: falta GET /events"; fail; }
grep -qi '^Accept: text/event-stream$' "$REQ" || { echo "FAIL: falta Accept: text/event-stream"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
if data.get("content_type") != "text/event-stream":
    print("FAIL: content_type debe ser 'text/event-stream'"); sys.exit(1)
if "data:" not in str(data.get("formato_evento", "")):
    print("FAIL: formato_evento debe mencionar 'data:'"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8102
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s --max-time 1 "http://127.0.0.1:$PORT/events" >/dev/null 2>&1 && break
  sleep 0.1
done

# Leer headers y los primeros eventos
HEADERS=$(curl -s -D - -o /dev/null --max-time 2 "http://127.0.0.1:$PORT/events")
echo "$HEADERS" | grep -qi 'Content-Type: text/event-stream' \
  || { echo "FAIL: el servidor no devuelve Content-Type: text/event-stream"; fail; }

# Leer algunos eventos del body (con timeout)
BODY=$(curl -s --max-time 4 "http://127.0.0.1:$PORT/events" 2>/dev/null || true)
echo "$BODY" | grep -q '^data:' || { echo "FAIL: no se recibieron eventos 'data:'"; fail; }
# Cada evento separado por doble nueva línea
echo "$BODY" | grep -Pq 'data:.*\n\n' || { echo "FAIL: los eventos no se separan con doble \\n"; fail; }

echo "OK Tests pasaron"
