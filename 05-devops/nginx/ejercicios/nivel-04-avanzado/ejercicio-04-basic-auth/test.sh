#!/usr/bin/env bash
# test.sh — Ejercicio 04 nivel-04 (basic auth).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
AUTH_DIR="$PWD/auth"
PORT=${TEST_PORT:-$((20600 + RANDOM % 500))}
NGINX_BIN="${NGINX_BIN:-nginx}"
TMP_ROOT="$(mktemp -d)"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
ACC_FILE="$TMP_ROOT/access.log"
RUN_CONF="$TMP_ROOT/run.conf"

cleanup() {
    if [ -f "$PID_FILE" ]; then
        "$NGINX_BIN" -s stop -g "pid $PID_FILE;" >/dev/null 2>&1 || true
        kill "$(cat "$PID_FILE" 2>/dev/null)" >/dev/null 2>&1 || true
        rm -f "$PID_FILE"
    fi
    rm -rf "$TMP_ROOT"
}
trap cleanup EXIT
fail() { echo "FAIL Tests fallaron"; echo "  -> $1"; exit 1; }

[ -f "$CONF" ] || fail "no existe $CONF"
[ -f "auth/generate-htpasswd.sh" ] || fail "falta auth/generate-htpasswd.sh"
[ -f "$WEB_DIR/index.html" ] || fail "falta web/index.html"

grep -Eq 'location[[:space:]]+/admin' "$CONF" || fail "falta location /admin"
grep -Eq 'auth_basic' "$CONF" || fail "falta auth_basic"
grep -Eq 'auth_basic_user_file' "$CONF" || fail "falta auth_basic_user_file"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

# Generar .htpasswd si no existe
if [ ! -f "$AUTH_DIR/.htpasswd" ]; then
    (cd auth && bash generate-htpasswd.sh) >/dev/null 2>&1 || fail "no se pudo generar .htpasswd"
fi

awk -v web="$WEB_DIR" -v auth="$AUTH_DIR" '
    /^[[:space:]]*root[[:space:]]+/ { sub(/root[[:space:]]+[^;]+;/, "root " web ";") }
    /auth_basic_user_file/ { sub(/\/ruta\/abs\/auth\/\.htpasswd/, auth "/.htpasswd") }
    { print }
' "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

# Sin credenciales -> 401
ST_NOAUTH=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/admin")
[ "$ST_NOAUTH" = "401" ] || fail "/admin sin credenciales debería dar 401 (vino $ST_NOAUTH)"

# Con credenciales -> 200
ST_AUTH=$(curl -s -o /dev/null -w "%{http_code}" -u admin:secret123 "http://127.0.0.1:$PORT/admin")
[ "$ST_AUTH" = "200" ] || fail "/admin con credenciales debería dar 200 (vino $ST_AUTH)"

echo "OK Tests pasaron"
exit 0
