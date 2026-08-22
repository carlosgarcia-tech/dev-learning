#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 2) - Accept y content negotiation.
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

grep -qi '^Accept: application/json$' "$REQ" || { echo "FAIL: falta Accept: application/json"; fail; }
grep -qi '^Accept: application/xml$' "$REQ" || { echo "FAIL: falta Accept: application/xml"; fail; }

python3 -m json.tool "$EXP" >/dev/null 2>&1 || { echo "FAIL: $EXP no es JSON válido"; fail; }

# Levantar servidor
PORT=8087
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/dato" >/dev/null 2>&1 && break
  sleep 0.1
done

# Consultar Content-Type real para cada Accept
CT_JSON=$(curl -s -D - -o /dev/null -H "Accept: application/json" "http://127.0.0.1:$PORT/dato" | grep -i '^content-type' | tr -d '\r')
CT_XML=$(curl -s -D - -o /dev/null -H "Accept: application/xml" "http://127.0.0.1:$PORT/dato" | grep -i '^content-type' | tr -d '\r')

python3 - "$EXP" "$CT_JSON" "$CT_XML" <<'PY'
import json, sys
exp_file, ct_json, ct_xml = sys.argv[1], sys.argv[2], sys.argv[3]
with open(exp_file, encoding="utf-8") as f:
    e = json.load(f)

def base_ct(line):
    # "Content-Type: application/json; charset=utf-8" -> "application/json"
    if not line:
        return ""
    val = line.split(":", 1)[1].strip()
    return val.split(";")[0].strip().lower()

errors = []
if base_ct(ct_json) != e["json"].lower():
    errors.append(f"json: esperado {e['json']}, recibido {base_ct(ct_json)}")
if base_ct(ct_xml) != e["xml"].lower():
    errors.append(f"xml: esperado {e['xml']}, recibido {base_ct(ct_xml)}")

if errors:
    for er in errors:
        print("  -", er)
    sys.exit(1)
print("OK Tests pasaron")
PY
