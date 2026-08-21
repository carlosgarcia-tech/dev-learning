#!/usr/bin/env bash
# test.sh — Ejercicio 06 nivel-04 (geo IP block).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((20800 + RANDOM % 500))}
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
[ -f "$WEB_DIR/index.html" ] || fail "falta web/index.html"

grep -Eq '^[[:space:]]*geo[[:space:]]+\$' "$CONF" || fail "falta directiva geo"
grep -Eq 'allow[[:space:]]+' "$CONF" || fail "falta 'allow' en location /admin"
grep -Eq 'deny[[:space:]]+all' "$CONF" || fail "falta 'deny all' en location /admin"
# verificar que hay algún bloqueo por geo (if con return 403)
grep -Eq 'return[[:space:]]+403' "$CONF" || fail "falta 'return 403' para bloquear"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

awk -v web="$WEB_DIR" '
    /^[[:space:]]*root[[:space:]]+/ { sub(/root[[:space:]]+[^;]+;/, "root " web ";") }
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

# /admin deniega a IPs externas (127.0.0.1 no está en 10.0.0.0/8) -> 403
ST_ADMIN=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/admin")
[ "$ST_ADMIN" = "403" ] || fail "/admin debería dar 403 a IPs externas (vino $ST_ADMIN)"

# / funciona (127.0.0.1 no está en la lista de bloqueo del geo)
ST_HOME=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/")
[ "$ST_HOME" = "200" ] || fail "/ debería dar 200 (vino $ST_HOME)"

echo "OK Tests pasaron"
exit 0
