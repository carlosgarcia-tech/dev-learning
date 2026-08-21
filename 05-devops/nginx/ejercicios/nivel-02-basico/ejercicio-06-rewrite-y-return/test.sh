#!/usr/bin/env bash
# test.sh — Ejercicio 06 nivel-02 (rewrite y return): 301, 200 directo y rewrite.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((19100 + RANDOM % 1000))}
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
grep -q 'pagina reescrita' "$WEB_DIR/index.html" || fail "index.html debe contener 'pagina reescrita'"

grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF" || fail "falta events"
grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF" || fail "falta http"
grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF" || fail "falta listen 8080"
grep -Eq 'return[[:space:]]+301[[:space:]]+/new' "$CONF" || fail "falta return 301 /new"
grep -Eq 'return[[:space:]]+200' "$CONF" || fail "falta return 200"
grep -Eq 'rewrite[[:space:]]+\^/v1' "$CONF" || fail "falta rewrite ^/v1/(.*)\$"

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

# /old -> 301 con Location: /new
ST_OLD=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/old")
LOC=$(curl -s -o /dev/null -D - "http://127.0.0.1:$PORT/old" | tr -d '\r' | awk -F': ' 'tolower($1)=="location"{print $2}')
[ "$ST_OLD" = "301" ] || fail "/old debería dar 301 (vino $ST_OLD)"
echo "$LOC" | grep -q '/new' || fail "/old Location debería ser /new (vino '$LOC')"

# /new -> 200 "nueva ruta"
ST_NEW=$(curl -s -o /tmp_b_$$ -w "%{http_code}" "http://127.0.0.1:$PORT/new")
B_NEW=$(cat /tmp_b_$$); rm -f /tmp_b_$$
[ "$ST_NEW" = "200" ] || fail "/new debería dar 200 (vino $ST_NEW)"
echo "$B_NEW" | grep -q 'nueva ruta' || fail "/new body debería contener 'nueva ruta' (vino '$B_NEW')"

# /v1/index.html -> 200 "pagina reescrita" (gracias al rewrite)
ST_V1=$(curl -s -o /tmp_b_$$ -w "%{http_code}" "http://127.0.0.1:$PORT/v1/index.html")
B_V1=$(cat /tmp_b_$$); rm -f /tmp_b_$$
[ "$ST_V1" = "200" ] || fail "/v1/index.html debería dar 200 (vino $ST_V1)"
echo "$B_V1" | grep -q 'pagina reescrita' || fail "/v1/index.html body debería contener 'pagina reescrita' (vino '$B_V1')"

echo "OK Tests pasaron"
exit 0
