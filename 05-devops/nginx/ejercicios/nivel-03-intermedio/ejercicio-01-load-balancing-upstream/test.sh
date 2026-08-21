#!/usr/bin/env bash
# test.sh — Ejercicio 01 nivel-03 (load balancing upstream round-robin).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
PORT=${TEST_PORT:-$((19200 + RANDOM % 1000))}
NGINX_BIN="${NGINX_BIN:-nginx}"
B1_PORT="${BACKEND1_PORT:-9001}"
B2_PORT="${BACKEND2_PORT:-9002}"
TMP_ROOT="$(mktemp -d)"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
ACC_FILE="$TMP_ROOT/access.log"
RUN_CONF="$TMP_ROOT/run.conf"
B1_PID="" B2_PID=""

cleanup() {
    if [ -f "$PID_FILE" ]; then
        "$NGINX_BIN" -s stop -g "pid $PID_FILE;" >/dev/null 2>&1 || true
        kill "$(cat "$PID_FILE" 2>/dev/null)" >/dev/null 2>&1 || true
        rm -f "$PID_FILE"
    fi
    [ -n "$B1_PID" ] && kill "$B1_PID" >/dev/null 2>&1 || true
    [ -n "$B2_PID" ] && kill "$B2_PID" >/dev/null 2>&1 || true
    rm -rf "$TMP_ROOT"
}
trap cleanup EXIT
fail() { echo "FAIL Tests fallaron"; echo "  -> $1"; exit 1; }

[ -f "$CONF" ] || fail "no existe $CONF"
[ -f "backend1.sh" ] || fail "falta backend1.sh"
[ -f "backend2.sh" ] || fail "falta backend2.sh"

grep -Eq '^[[:space:]]*upstream[[:space:]]+' "$CONF" || fail "falta bloque upstream"
grep -Eq 'server[[:space:]]+127\.0\.0\.1:9001' "$CONF" || fail "falta server 127.0.0.1:9001 en upstream"
grep -Eq 'server[[:space:]]+127\.0\.0\.1:9002' "$CONF" || fail "falta server 127.0.0.1:9002 en upstream"
grep -Eq 'proxy_pass[[:space:]]+http://app_backend' "$CONF" || fail "falta proxy_pass http://app_backend"
grep -Eq 'proxy_set_header[[:space:]]+Host' "$CONF" || fail "falta proxy_set_header Host"
grep -Eq 'proxy_set_header[[:space:]]+X-Forwarded-For' "$CONF" || fail "falta proxy_set_header X-Forwarded-For"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

# Sustituir puertos de backend si se han sobreescrito via env
sed -e "s/127.0.0.1:9001/127.0.0.1:$B1_PORT/g" -e "s/127.0.0.1:9002/127.0.0.1:$B2_PORT/g" "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"

if command -v nc >/dev/null 2>&1; then
    BACKEND_PORT=$B1_PORT bash backend1.sh >/dev/null 2>&1 &
    B1_PID=$!
    BACKEND_PORT=$B2_PORT bash backend2.sh >/dev/null 2>&1 &
    B2_PID=$!
    sleep 0.5
fi

"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

# Si nc está disponible, verificar que ambos backends responden (round-robin)
if [ -n "$B1_PID" ] && [ -n "$B2_PID" ]; then
    RESPONSES=""
    for i in 1 2 3 4; do
        R=$(curl -s --max-time 2 "http://127.0.0.1:$PORT/" || true)
        RESPONSES="$RESPONSES $R"
        sleep 0.3
    done
    echo "$RESPONSES" | grep -q 'backend-1' || fail "no se recibió respuesta de backend-1 (round-robin)"
    echo "$RESPONSES" | grep -q 'backend-2' || fail "no se recibió respuesta de backend-2 (round-robin)"
fi

echo "OK Tests pasaron"
exit 0
