#!/usr/bin/env bash
# Tests de integración del proyecto "Servidor HTTP desde cero en Node.js".
# Valida el servidor arrancándolo y consultándolo con curl.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SERVER="server.js"

[[ -f "$SERVER" ]] || { echo "FAIL: falta $SERVER"; fail; }
command -v node >/dev/null 2>&1 || { echo "FAIL: se requiere node"; fail; }
command -v curl >/dev/null 2>&1 || { echo "FAIL: se requiere curl"; fail; }

PORT=3000
BASE="http://127.0.0.1:$PORT"

# Arrancar el servidor
node "$SERVER" &
SRV_PID=$!
cleanup() { kill "$SRV_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

# Esperar a que arranque
READY=0
for _ in $(seq 1 100); do
  if curl -s "$BASE/health" >/dev/null 2>&1; then
    READY=1
    break
  fi
  sleep 0.1
done
[[ "$READY" == "1" ]] || { echo "FAIL: el servidor no arrancó"; fail; }

echo "→ Test 1: GET /health"
HEALTH=$(curl -s "$BASE/health")
python3 -c "import json,sys; d=json.loads(sys.argv[1]); assert d['status']=='ok', d" "$HEALTH" \
  || { echo "FAIL: /health no devolvió {status:ok}"; fail; }

echo "→ Test 2: POST /auth/login"
LOGIN=$(curl -s -X POST "$BASE/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"1234"}')
TOKEN=$(python3 -c "import json,sys; print(json.loads(sys.argv[1]).get('token',''))" "$LOGIN") \
  || { echo "FAIL: login no devolvió token"; fail; }
[[ -n "$TOKEN" ]] || { echo "FAIL: login no devolvió token"; fail; }

echo "→ Test 3: GET /tasks con Bearer"
TASKS=$(curl -s -H "Authorization: Bearer $TOKEN" "$BASE/tasks")
ETAG=$(curl -s -D - -o /dev/null -H "Authorization: Bearer $TOKEN" "$BASE/tasks" | grep -i '^etag' | tr -d '\r' | awk '{print $2}')
python3 -c "import json,sys; d=json.loads(sys.argv[1]); assert isinstance(d,list) and len(d)>=1" "$TASKS" \
  || { echo "FAIL: /tasks no devolvió una lista"; fail; }
[[ -n "$ETAG" ]] || { echo "FAIL: /tasks no devolvió ETag"; fail; }

echo "→ Test 4: GET /tasks con If-None-Match -> 304"
CODE_304=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" -H "If-None-Match: $ETAG" "$BASE/tasks")
[[ "$CODE_304" == "304" ]] || { echo "FAIL: If-None-Match devolvió $CODE_304, esperado 304"; fail; }

echo "→ Test 5: GET /tasks sin token -> 401"
CODE_401=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/tasks")
[[ "$CODE_401" == "401" ]] || { echo "FAIL: sin token devolvió $CODE_401, esperado 401"; fail; }

echo "→ Test 6: POST /tasks -> 201 + Location"
HEAD_CREATE=$(curl -s -D - -o /dev/null -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" -d '{"titulo":"Nueva tarea"}' "$BASE/tasks")
CODE_CREATE=$(echo "$HEAD_CREATE" | head -1 | awk '{print $2}')
echo "$HEAD_CREATE" | grep -qi '^Location:' || { echo "FAIL: POST /tasks sin Location"; fail; }
[[ "$CODE_CREATE" == "201" ]] || { echo "FAIL: POST /tasks devolvió $CODE_CREATE, esperado 201"; fail; }

echo "→ Test 7: PATCH /tasks/1 -> 200"
CODE_PATCH=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" -d '{"hecho":true}' "$BASE/tasks/1")
[[ "$CODE_PATCH" == "200" ]] || { echo "FAIL: PATCH devolvió $CODE_PATCH, esperado 200"; fail; }

echo "→ Test 8: DELETE /tasks/999 -> 404"
CODE_DEL_404=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE -H "Authorization: Bearer $TOKEN" "$BASE/tasks/999")
[[ "$CODE_DEL_404" == "404" ]] || { echo "FAIL: DELETE inexistente devolvió $CODE_DEL_404, esperado 404"; fail; }

echo "→ Test 9: OPTIONS preflight CORS -> 204"
CODE_OPT=$(curl -s -o /dev/null -w "%{http_code}" -X OPTIONS "$BASE/tasks")
[[ "$CODE_OPT" == "204" ]] || { echo "FAIL: OPTIONS devolvió $CODE_OPT, esperado 204"; fail; }
HEAD_OPT=$(curl -s -D - -o /dev/null -X OPTIONS "$BASE/tasks")
echo "$HEAD_OPT" | grep -qi 'Access-Control-Allow-Origin' || { echo "FAIL: OPTIONS sin Access-Control-Allow-Origin"; fail; }

echo ""
echo "OK Tests pasaron"
