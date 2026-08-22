#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 4) - rate limiting.
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

grep -q '^GET /api HTTP/1\.1$' "$REQ" || { echo "FAIL: falta GET /api"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
if data.get("dentro_limite") != 200:
    print("FAIL: dentro_limite debe ser 200"); sys.exit(1)
if data.get("fuera_limite") != 429:
    print("FAIL: fuera_limite debe ser 429"); sys.exit(1)
if "Retry-After" not in str(data.get("header_reintento", "")):
    print("FAIL: header_reintento debe mencionar Retry-After"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8098
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/api" >/dev/null 2>&1 && break
  sleep 0.1
done

# Hacer 4 peticiones y comprobar códigos
C1=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/api")
C2=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/api")
C3=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/api")
C4=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/api")

[[ "$C1" == "200" ]] || { echo "FAIL: 1ª petición devolvió $C1, esperado 200"; fail; }
[[ "$C2" == "200" ]] || { echo "FAIL: 2ª petición devolvió $C2, esperado 200"; fail; }
[[ "$C3" == "200" ]] || { echo "FAIL: 3ª petición devolvió $C3, esperado 200"; fail; }
[[ "$C4" == "429" ]] || { echo "FAIL: 4ª petición devolvió $C4, esperado 429"; fail; }

# La 4ª debe tener Retry-After
HEAD4=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/api")
echo "$HEAD4" | grep -qi 'Retry-After' || { echo "FAIL: 429 sin Retry-After"; fail; }

echo "OK Tests pasaron"
