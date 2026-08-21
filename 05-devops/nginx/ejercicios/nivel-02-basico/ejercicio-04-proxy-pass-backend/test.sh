#!/usr/bin/env bash
# test.sh — Ejercicio 04 nivel-02 (proxy_pass a backend simulado).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((18900 + RANDOM % 1000))}
NGINX_BIN="${NGINX_BIN:-nginx}"
BACKEND_PORT="${BACKEND_PORT:-9001}"
TMP_ROOT="$(mktemp -d)"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
ACC_FILE="$TMP_ROOT/access.log"
RUN_CONF="$TMP_ROOT/run.conf"
BACKEND_PID=""

cleanup() {
    if [ -f "$PID_FILE" ]; then
        "$NGINX_BIN" -s stop -g "pid $PID_FILE;" >/dev/null 2>&1 || true
        kill "$(cat "$PID_FILE" 2>/dev/null)" >/dev/null 2>&1 || true
        rm -f "$PID_FILE"
    fi
    [ -n "$BACKEND_PID" ] && kill "$BACKEND_PID" >/dev/null 2>&1 || true
    rm -rf "$TMP_ROOT"
}
trap cleanup EXIT
fail() { echo "FAIL Tests fallaron"; echo "  -> $1"; exit 1; }

[ -f "$CONF" ] || fail "no existe $CONF"
[ -f "$WEB_DIR/index.html" ] || fail "falta web/index.html"
[ -f "backend.sh" ] || fail "falta backend.sh"

grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF" || fail "falta events"
grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF" || fail "falta http"
grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF" || fail "falta listen 8080"
grep -Eq 'location[[:space:]]+/api/' "$CONF" || fail "falta location /api/"
grep -Eq 'proxy_pass[[:space:]]+http' "$CONF" || fail "falta proxy_pass http://..."

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

awk -v web="$WEB_DIR" '
    /^[[:space:]]*root[[:space:]]+/ { sub(/root[[:space:]]+[^;]+;/, "root " web ";") }
    { print }
' "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"

# arrancar backend simulado si nc está disponible
if command -v nc >/dev/null 2>&1; then
    bash backend.sh >/dev/null 2>&1 &
    BACKEND_PID=$!
    sleep 0.5
fi

"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

# frontend
F=$(curl -s "http://127.0.0.1:$PORT/")
echo "$F" | grep -q 'frontend' || fail "/ no contiene 'frontend' (vino: $F)"

# backend (solo si nc está disponible y el backend responde)
if [ -n "$BACKEND_PID" ]; then
    B=$(curl -s --max-time 3 "http://127.0.0.1:$PORT/api/" || true)
    echo "$B" | grep -q 'backend-ok' || fail "/api/ no contiene 'backend-ok' (vino: $B)"
fi

echo "OK Tests pasaron"
exit 0
