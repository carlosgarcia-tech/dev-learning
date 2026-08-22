#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 2) - query params.
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
grep -q '^GET /productos?categoria=electronica&orden=desc&limite=5 HTTP/1\.1$' "$REQ" \
  || { echo "FAIL: la request line no tiene los query params correctos"; fail; }
grep -qi '^Host: localhost:8083$' "$REQ" || { echo "FAIL: falta Host: localhost:8083"; fail; }
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Levantar servidor
PORT=8083
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/productos" >/dev/null 2>&1 && break
  sleep 0.1
done

RESP=$(curl -s "http://127.0.0.1:$PORT/productos?categoria=electronica&orden=desc&limite=5") \
  || { echo "FAIL: curl falló"; fail; }

python3 - "$RESP" "$EXP" <<'PY'
import json, sys
received, expected = sys.argv[1], sys.argv[2]
r = json.loads(received)
with open(expected, encoding="utf-8") as f:
    e = json.load(f)
if r != e:
    print("FAIL: la respuesta no coincide con expected.json")
    print("  recibido :", json.dumps(r, ensure_ascii=False))
    print("  esperado :", json.dumps(e, ensure_ascii=False))
    sys.exit(1)
print("OK Tests pasaron")
PY
