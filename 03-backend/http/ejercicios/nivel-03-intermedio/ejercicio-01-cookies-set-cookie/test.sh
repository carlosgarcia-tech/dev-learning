#!/usr/bin/env bash
# Validación del ejercicio 01 (nivel 3) - cookies y Set-Cookie.
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

# Validar peticiones.http
grep -q '^POST /login HTTP/1\.1$' "$REQ" || { echo "FAIL: falta POST /login"; fail; }
grep -q '^GET /perfil HTTP/1\.1$' "$REQ" || { echo "FAIL: falta GET /perfil"; fail; }
grep -qi '^Cookie: sesion=abc123$' "$REQ" || { echo "FAIL: falta Cookie: sesion=abc123"; fail; }

# Validar respuesta.json
python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
a = data.get("atributos", {})
if a.get("HttpOnly") is not True:
    print("FAIL: HttpOnly debe ser true"); sys.exit(1)
if a.get("Secure") is not True:
    print("FAIL: Secure debe ser true"); sys.exit(1)
if a.get("SameSite") != "Lax":
    print("FAIL: SameSite debe ser 'Lax'"); sys.exit(1)
print("OK atributos válidos")
PY

# Levantar servidor
PORT=8089
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/perfil" >/dev/null 2>&1 && break
  sleep 0.1
done

# 1. Login debe devolver Set-Cookie con los atributos
HEADERS=$(curl -s -D - -o /dev/null -X POST "http://127.0.0.1:$PORT/login" \
  -H "Content-Type: application/json" -d '{"usuario":"ana","pass":"123"}')
echo "$HEADERS" | grep -qi 'Set-Cookie: sesion=abc123' || { echo "FAIL: falta Set-Cookie sesion"; fail; }
echo "$HEADERS" | grep -qi 'HttpOnly' || { echo "FAIL: cookie sin HttpOnly"; fail; }
echo "$HEADERS" | grep -qi 'Secure' || { echo "FAIL: cookie sin Secure"; fail; }
echo "$HEADERS" | grep -qi 'SameSite=Lax' || { echo "FAIL: cookie sin SameSite=Lax"; fail; }

# 2. GET /perfil SIN cookie -> 401
CODE_NO_COOKIE=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/perfil")
[[ "$CODE_NO_COOKIE" == "401" ]] || { echo "FAIL: /perfil sin cookie devolvió $CODE_NO_COOKIE, esperado 401"; fail; }

# 3. GET /perfil CON cookie -> 200
CODE_COOKIE=$(curl -s -o /dev/null -w "%{http_code}" -H "Cookie: sesion=abc123" "http://127.0.0.1:$PORT/perfil")
[[ "$CODE_COOKIE" == "200" ]] || { echo "FAIL: /perfil con cookie devolvió $CODE_COOKIE, esperado 200"; fail; }

echo "OK Tests pasaron"
