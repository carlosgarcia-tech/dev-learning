#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 2) - DELETE y 204.
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

grep -q '^DELETE /tareas/7 HTTP/1\.1$' "$REQ" || { echo "FAIL: falta request line DELETE"; fail; }
grep -qi '^Host: localhost:8086$' "$REQ" || { echo "FAIL: falta Host"; fail; }

python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }
python3 - "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    e = json.load(f)
if e.get("status") != 204:
    print("FAIL: expected.status debe ser 204"); sys.exit(1)
if "body" not in e or e["body"] is not None:
    print("FAIL: expected.body debe ser null"); sys.exit(1)
print("OK expected válido")
PY

# Levantar servidor y hacer DELETE
PORT=8086
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s -X DELETE "http://127.0.0.1:$PORT/tareas/7" -o /dev/null 2>&1 && break
  sleep 0.1
done

CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "http://127.0.0.1:$PORT/tareas/7") \
  || { echo "FAIL: curl falló"; fail; }
[[ "$CODE" == "204" ]] || { echo "FAIL: DELETE devolvió $CODE, esperado 204"; fail; }

echo "OK Tests pasaron"
