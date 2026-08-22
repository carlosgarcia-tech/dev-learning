#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 3) - redirecciones 301 y 302.
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

grep -q '^GET /viejo HTTP/1\.1$' "$REQ" || { echo "FAIL: falta GET /viejo"; fail; }
grep -q '^GET /temp HTTP/1\.1$' "$REQ" || { echo "FAIL: falta GET /temp"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
r = data.get("rutas", {})
v = r.get("viejo", {})
t = r.get("temp", {})
if v.get("status") != 301 or v.get("location") != "/nuevo":
    print("FAIL: viejo debe ser 301 -> /nuevo"); sys.exit(1)
if t.get("status") != 302 or t.get("location") != "/nuevo":
    print("FAIL: temp debe ser 302 -> /nuevo"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8092
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/nuevo" >/dev/null 2>&1 && break
  sleep 0.1
done

# /viejo -> 301 + Location: /nuevo
HEAD_V=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/viejo")
CODE_V=$(echo "$HEAD_V" | head -1 | awk '{print $2}')
[[ "$CODE_V" == "301" ]] || { echo "FAIL: /viejo devolvió $CODE_V, esperado 301"; fail; }
echo "$HEAD_V" | grep -qi '^Location: /nuevo$' || { echo "FAIL: /viejo sin Location: /nuevo"; fail; }

# /temp -> 302 + Location: /nuevo
HEAD_T=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/temp")
CODE_T=$(echo "$HEAD_T" | head -1 | awk '{print $2}')
[[ "$CODE_T" == "302" ]] || { echo "FAIL: /temp devolvió $CODE_T, esperado 302"; fail; }
echo "$HEAD_T" | grep -qi '^Location: /nuevo$' || { echo "FAIL: /temp sin Location: /nuevo"; fail; }

echo "OK Tests pasaron"
