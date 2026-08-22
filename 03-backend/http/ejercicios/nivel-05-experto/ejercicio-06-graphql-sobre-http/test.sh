#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 5) - GraphQL sobre HTTP.
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
grep -q '^POST /graphql HTTP/1\.1$' "$REQ" || { echo "FAIL: falta POST /graphql"; fail; }
grep -qi '^Content-Type: application/json' "$REQ" || { echo "FAIL: falta Content-Type"; fail; }

# Validar que el body tiene la query
python3 - "$REQ" <<'PY'
import sys, json, re
with open(sys.argv[1], encoding="utf-8") as f:
    content = f.read()
parts = content.split("\n\n", 1)
if len(parts) != 2 or not parts[1].strip():
    print("FAIL: falta body"); sys.exit(1)
try:
    body = json.loads(parts[1].strip())
except Exception as e:
    print(f"FAIL: el body no es JSON válido: {e}"); sys.exit(1)
q = body.get("query", "")
if "producto" not in q or "id" not in q:
    print("FAIL: la query debe pedir producto(id: ...)"); sys.exit(1)
print("OK query válida")
PY

# Validar expected.json
python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }
python3 - "$EXP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    e = json.load(f)
p = e.get("data", {}).get("producto", {})
if p.get("id") != 1 or p.get("nombre") != "Teclado":
    print("FAIL: expected.data.producto debe tener id=1, nombre=Teclado"); sys.exit(1)
print("OK expected válido")
PY

# Levantar servidor y hacer la query real
PORT=8103
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s -X POST "http://127.0.0.1:$PORT/graphql" -d '{}' >/dev/null 2>&1 && break
  sleep 0.1
done

RESP=$(curl -s -X POST "http://127.0.0.1:$PORT/graphql" \
  -H "Content-Type: application/json" \
  -d '{"query":"{ producto(id: 1) { id nombre precio } }"}') \
  || { echo "FAIL: curl falló"; fail; }

python3 - "$RESP" "$EXP" <<'PY'
import json, sys
received, expected = sys.argv[1], sys.argv[2]
r = json.loads(received)
with open(expected, encoding="utf-8") as f:
    e = json.load(f)
prod = r.get("data", {}).get("producto", {})
exp_prod = e["data"]["producto"]
# Comparar campos clave (id, nombre, precio)
for k in ("id", "nombre", "precio"):
    if prod.get(k) != exp_prod.get(k):
        print(f"FAIL: producto.{k} = {prod.get(k)} != {exp_prod.get(k)}"); sys.exit(1)
print("OK Tests pasaron")
PY
