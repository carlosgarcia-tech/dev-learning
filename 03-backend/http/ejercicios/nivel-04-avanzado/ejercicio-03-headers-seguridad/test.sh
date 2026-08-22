#!/usr/bin/env bash
# Validación del ejercicio 03 (nivel 4) - headers de seguridad.
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

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }

# Validar respuesta.json tiene los 4 headers con valores clave
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
h = data.get("headers", {})
checks = [
    ("Strict-Transport-Security", "max-age"),
    ("X-Content-Type-Options", "nosniff"),
    ("X-Frame-Options", "DENY"),
    ("Content-Security-Policy", "default-src"),
]
for header, must_contain in checks:
    val = str(h.get(header, ""))
    if must_contain.lower() not in val.lower():
        print(f"FAIL: {header} debe contener '{must_contain}', recibido '{val}'"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8097
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/" >/dev/null 2>&1 && break
  sleep 0.1
done

HEADERS=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/")

echo "$HEADERS" | grep -qi 'strict-transport-security' || { echo "FAIL: falta HSTS"; fail; }
echo "$HEADERS" | grep -qi 'x-content-type-options: nosniff' || { echo "FAIL: falta X-Content-Type-Options: nosniff"; fail; }
echo "$HEADERS" | grep -qi 'x-frame-options: DENY' || { echo "FAIL: falta X-Frame-Options: DENY"; fail; }
echo "$HEADERS" | grep -qi 'content-security-policy' || { echo "FAIL: falta CSP"; fail; }

echo "OK Tests pasaron"
