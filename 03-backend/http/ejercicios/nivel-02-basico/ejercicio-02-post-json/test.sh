#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 2) - POST con JSON.
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

grep -q '^POST /usuarios HTTP/1\.1$' "$REQ" || { echo "FAIL: falta request line POST"; fail; }
grep -qi '^Host: localhost:8084$' "$REQ" || { echo "FAIL: falta Host"; fail; }
grep -qi '^Content-Type: application/json' "$REQ" || { echo "FAIL: falta Content-Type"; fail; }
grep -qi '^Content-Length: [0-9]\+$' "$REQ" || { echo "FAIL: falta Content-Length"; fail; }

# Verificar Content-Length vs body
python3 - "$REQ" <<'PY'
import sys, re
with open(sys.argv[1], encoding="utf-8") as f:
    content = f.read()
parts = content.split("\n\n", 1)
if len(parts) != 2 or not parts[1].strip():
    print("FAIL: falta body"); sys.exit(1)
headers, body = parts
body = body.rstrip("\n")
m = re.search(r'^Content-Length:\s*(\d+)\s*$', headers, re.MULTILINE | re.IGNORECASE)
declared = int(m.group(1))
actual = len(body.encode("utf-8"))
if declared != actual:
    print(f"FAIL: Content-Length={declared} pero body={actual} bytes")
    sys.exit(1)
print("OK Content-Length correcto")
PY

python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Validar estructura del expected
python3 - "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    e = json.load(f)
if e.get("status") != 201:
    print("FAIL: expected.status debe ser 201"); sys.exit(1)
b = e.get("body", {})
if not (b.get("id") == 1 and b.get("nombre") == "Ana" and b.get("activo") is True):
    print("FAIL: expected.body no tiene los campos esperados"); sys.exit(1)
print("OK expected válido")
PY

# Levantar servidor y hacer POST
PORT=8084
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/usuarios" -X POST -d '{}' >/dev/null 2>&1 && break
  sleep 0.1
done

BODY='{"nombre":"Ana","email":"ana@ejemplo.com"}'
OUT=$(curl -s -w "\n%{http_code}" -X POST "http://127.0.0.1:$PORT/usuarios" \
  -H "Content-Type: application/json" -d "$BODY") || { echo "FAIL: curl falló"; fail; }

python3 - "$OUT" "$EXP" <<'PY'
import json, sys
out, exp_file = sys.argv[1], sys.argv[2]
lines = out.rsplit("\n", 1)
body, status = lines[0], int(lines[1])
with open(exp_file, encoding="utf-8") as f:
    e = json.load(f)
if status != e["status"]:
    print(f"FAIL: status {status} != {e['status']}"); sys.exit(1)
r = json.loads(body)
if r != e["body"]:
    print("FAIL: el body no coincide con expected.body")
    print("  recibido :", r); print("  esperado :", e["body"]); sys.exit(1)
print("OK Tests pasaron")
PY
