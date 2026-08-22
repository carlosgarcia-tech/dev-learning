#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 4) - Bearer y scopes.
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
grep -qi '^Authorization: Bearer admin-token' "$REQ" || { echo "FAIL: falta Bearer admin-token"; fail; }
grep -qi '^Authorization: Bearer user-token' "$REQ" || { echo "FAIL: falta Bearer user-token"; fail; }

python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; fail; }
python3 - "$RESP" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
esc = data.get("escenarios", {})
expected = {"admin_en_admin": 200, "user_en_admin": 403, "user_en_perfil": 200, "sin_token_en_perfil": 401}
for k, v in expected.items():
    if esc.get(k) != v:
        print(f"FAIL: {k} debe ser {v}, recibido {esc.get(k)}"); sys.exit(1)
print("OK respuesta válida")
PY

# Levantar servidor
PORT=8100
python3 "$SRV" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for _ in $(seq 1 50); do
  curl -s "http://127.0.0.1:$PORT/perfil" >/dev/null 2>&1 && break
  sleep 0.1
done

code() { curl -s -o /dev/null -w "%{http_code}" "$@"; }

# admin-token en /admin -> 200
C1=$(code -H "Authorization: Bearer admin-token" "http://127.0.0.1:$PORT/admin")
# user-token en /admin -> 403
C2=$(code -H "Authorization: Bearer user-token" "http://127.0.0.1:$PORT/admin")
# user-token en /perfil -> 200
C3=$(code -H "Authorization: Bearer user-token" "http://127.0.0.1:$PORT/perfil")
# sin token en /perfil -> 401
C4=$(code "http://127.0.0.1:$PORT/perfil")

[[ "$C1" == "200" ]] || { echo "FAIL: admin en /admin devolvió $C1, esperado 200"; fail; }
[[ "$C2" == "403" ]] || { echo "FAIL: user en /admin devolvió $C2, esperado 403"; fail; }
[[ "$C3" == "200" ]] || { echo "FAIL: user en /perfil devolvió $C3, esperado 200"; fail; }
[[ "$C4" == "401" ]] || { echo "FAIL: sin token devolvió $C4, esperado 401"; fail; }

echo "OK Tests pasaron"
