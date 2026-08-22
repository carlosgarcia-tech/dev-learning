#!/usr/bin/env bash
# Validación del ejercicio 06 - Body en POST.
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
grep -q '^POST /productos HTTP/1\.1$' "$REQ" || { echo "FAIL: falta request line POST"; fail; }
grep -qi '^Host: localhost:8082$' "$REQ" || { echo "FAIL: falta Host"; fail; }
grep -qi '^Content-Type: application/json' "$REQ" || { echo "FAIL: falta Content-Type"; fail; }
grep -qi '^Content-Length: [0-9]\+$' "$REQ" || { echo "FAIL: falta Content-Length"; fail; }

# Validar que el Content-Length coincide con el body real
python3 - "$REQ" <<'PY'
import sys, re
with open(sys.argv[1], encoding="utf-8") as f:
    content = f.read()
# Separar headers y body por la primera línea en blanco
parts = content.split("\n\n", 1)
if len(parts) != 2 or not parts[1].strip():
    print("FAIL: no se encontró body separado por línea en blanco")
    sys.exit(1)
headers, body = parts
body = body.rstrip("\n")
m = re.search(r'^Content-Length:\s*(\d+)\s*$', headers, re.MULTILINE | re.IGNORECASE)
if not m:
    print("FAIL: no se pudo leer Content-Length"); sys.exit(1)
declared = int(m.group(1))
actual = len(body.encode("utf-8"))
if declared != actual:
    print(f"FAIL: Content-Length={declared} pero el body tiene {actual} bytes")
    print(f"  body: {body!r}")
    sys.exit(1)
print("OK Content-Length correcto")
PY

# Validar expected.json
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Levantar servidor y hacer el POST real
PORT=8082
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/productos" -X POST -d '{}' >/dev/null 2>&1 && break
  sleep 0.1
done

BODY='{"nombre":"Teclado","precio":49.99}'
RESP=$(curl -s -X POST "http://127.0.0.1:$PORT/productos" \
  -H "Content-Type: application/json" \
  -d "$BODY") || { echo "FAIL: curl POST falló"; fail; }

# Comparar la respuesta del servidor con el expected.json
python3 - "$RESP" "$EXP" <<'PY'
import json, sys
received, expected = sys.argv[1], sys.argv[2]
r = json.loads(received)
with open(expected, encoding="utf-8") as f:
    e = json.load(f)
if r != e:
    print("FAIL: la respuesta no coincide con expected.json")
    print("  recibido :", r)
    print("  esperado :", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
