#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 2) - códigos 201 y 204.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
EXP="expected.json"
SRV="server.sh"
REQ="peticiones.http"

for f in "$RESP" "$EXP" "$SRV" "$REQ"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v curl >/dev/null 2>&1 || { echo "FAIL: se requiere curl"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Validar respuesta.json contra expected.json
python3 - "$RESP" "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    r = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    e = json.load(f)
esc = r.get("escenarios")
if not isinstance(esc, dict):
    print("FAIL: falta el objeto 'escenarios'"); sys.exit(1)
errors = []
for k, v in e["escenarios"].items():
    if esc.get(k) != v:
        errors.append(f"'{k}': esperado {v}, recibido {esc.get(k)}")
if errors:
    for er in errors:
        print("  -", er)
    sys.exit(1)
print("OK escenarios válidos")
PY

# Levantar servidor y comprobar códigos reales
PORT=8088
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/recursos/1" >/dev/null 2>&1 && break
  sleep 0.1
done

code() { curl -s -o /dev/null -w "%{http_code}" "$@"; }

C1=$(code -X POST "http://127.0.0.1:$PORT/recursos" -H "Content-Type: application/json" -d '{"nombre":"Nuevo"}')
C2=$(code -X DELETE "http://127.0.0.1:$PORT/recursos/1")
C3=$(code -X POST "http://127.0.0.1:$PORT/recursos-sin-body" -H "Content-Type: application/json" -d '{"nombre":"Otro"}')
C4=$(code "http://127.0.0.1:$PORT/recursos/1")
C5=$(code -X PUT "http://127.0.0.1:$PORT/recursos/1" -H "Content-Type: application/json" -d '{"nombre":"Actualizado"}')
C6=$(code -X DELETE "http://127.0.0.1:$PORT/recursos/999")

[[ "$C1" == "201" ]] || { echo "FAIL: POST /recursos devolvió $C1, esperado 201"; fail; }
[[ "$C2" == "204" ]] || { echo "FAIL: DELETE /recursos/1 devolvió $C2, esperado 204"; fail; }
[[ "$C3" == "204" ]] || { echo "FAIL: POST /recursos-sin-body devolvió $C3, esperado 204"; fail; }
[[ "$C4" == "200" ]] || { echo "FAIL: GET /recursos/1 devolvió $C4, esperado 200"; fail; }
[[ "$C5" == "200" ]] || { echo "FAIL: PUT /recursos/1 devolvió $C5, esperado 200"; fail; }
[[ "$C6" == "404" ]] || { echo "FAIL: DELETE /recursos/999 devolvió $C6, esperado 404"; fail; }

echo "OK Tests pasaron"
