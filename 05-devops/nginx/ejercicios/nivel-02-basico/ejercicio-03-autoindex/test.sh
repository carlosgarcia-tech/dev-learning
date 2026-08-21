#!/usr/bin/env bash
# test.sh — Ejercicio 03 nivel-02 (autoindex): listado de directorio.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((18800 + RANDOM % 1000))}
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
[ -f "$WEB_DIR/descargas/file1.txt" ] || fail "falta web/descargas/file1.txt"
[ -f "$WEB_DIR/descargas/file2.txt" ] || fail "falta web/descargas/file2.txt"

grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF" || fail "falta events"
grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF" || fail "falta http"
grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF" || fail "falta listen 8080"
grep -Eq 'location[[:space:]]+/descargas/' "$CONF" || fail "falta location /descargas/"
grep -Eq '^[[:space:]]*autoindex[[:space:]]+on' "$CONF" || fail "falta autoindex on"
grep -Eq 'autoindex_exact_size[[:space:]]+off' "$CONF" || fail "falta autoindex_exact_size off"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

awk -v web="$WEB_DIR" '
    /^[[:space:]]*root[[:space:]]+/  { sub(/root[[:space:]]+[^;]+;/, "root " web ";") }
    /^[[:space:]]*alias[[:space:]]+/ { sub(/alias[[:space:]]+[^;]+;/, "alias " web "/descargas/;") }
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

BODY=$(curl -s "http://127.0.0.1:$PORT/descargas/")
echo "$BODY" | grep -q 'file1.txt' || fail "/descargas/ no lista file1.txt (vino: $BODY)"
echo "$BODY" | grep -q 'file2.txt' || fail "/descargas/ no lista file2.txt (vino: $BODY)"

echo "OK Tests pasaron"
exit 0
