#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 4) - HTTPS y TLS (explicación práctica).
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
SRV="server.sh"
REQ="peticiones.http"

for f in "$RESP" "$SRV" "$REQ"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v curl >/dev/null 2>&1 || { echo "FAIL: se requiere curl"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }

# Validar las respuestas conceptuales
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

def check_contains(key, needles):
    val = str(data.get(key, "")).lower()
    for n in needles:
        if n.lower() in val:
            return True
    return False

errors = []
if not check_contains("transporte", ["tls", "ssl"]):
    errors.append("transporte debe mencionar TLS o SSL")
if not check_contains("handshake", ["tls", "certificado"]):
    errors.append("handshake debe mencionar TLS o certificado")
if not check_contains("quien_emite", ["ca", "certificate authority"]):
    errors.append("quien_emite debe mencionar CA o Certificate Authority")
if str(data.get("header_https", "")).lower() != "strict-transport-security":
    errors.append("header_https debe ser 'Strict-Transport-Security'")
if data.get("cookie_secure_http") is not False and str(data.get("cookie_secure_http")).lower() != "false":
    errors.append("cookie_secure_http debe ser false")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)
print("OK respuestas conceptuales válidas")
PY

# Levantar servidor y comprobar que tiene HSTS
PORT=8099
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/" >/dev/null 2>&1 && break
  sleep 0.1
done

HEADERS=$(curl -s -D - -o /dev/null "http://127.0.0.1:$PORT/")
echo "$HEADERS" | grep -qi 'strict-transport-security' || { echo "FAIL: el servidor no envía HSTS"; fail; }

echo "OK Tests pasaron"
