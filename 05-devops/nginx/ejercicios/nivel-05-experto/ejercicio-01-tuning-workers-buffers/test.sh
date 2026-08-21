#!/usr/bin/env bash
# test.sh — Ejercicio 01 nivel-05 (tuning de workers y buffers).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
PORT=${TEST_PORT:-$((20900 + RANDOM % 500))}
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

grep -Eq '^[[:space:]]*worker_processes[[:space:]]+auto' "$CONF" || fail "falta 'worker_processes auto'"
grep -Eq 'worker_rlimit_nofile[[:space:]]+65535' "$CONF" || fail "falta 'worker_rlimit_nofile 65535'"
grep -Eq 'worker_connections[[:space:]]+4096' "$CONF" || fail "falta 'worker_connections 4096' en events"
grep -Eq 'multi_accept[[:space:]]+on' "$CONF" || fail "falta 'multi_accept on' en events"
grep -Eq 'sendfile[[:space:]]+on' "$CONF" || fail "falta 'sendfile on'"
grep -Eq 'tcp_nopush[[:space:]]+on' "$CONF" || fail "falta 'tcp_nopush on'"
grep -Eq 'tcp_nodelay[[:space:]]+on' "$CONF" || fail "falta 'tcp_nodelay on'"
grep -Eq 'keepalive_timeout[[:space:]]+65' "$CONF" || fail "falta 'keepalive_timeout 65'"
grep -Eq 'keepalive_requests[[:space:]]+1000' "$CONF" || fail "falta 'keepalive_requests 1000'"
grep -Eq 'client_body_buffer_size[[:space:]]+16k' "$CONF" || fail "falta 'client_body_buffer_size 16k'"
grep -Eq 'client_max_body_size[[:space:]]+10m' "$CONF" || fail "falta 'client_max_body_size 10m'"
grep -Eq 'proxy_buffer_size[[:space:]]+16k' "$CONF" || fail "falta 'proxy_buffer_size 16k'"
grep -Eq 'proxy_buffers[[:space:]]+8[[:space:]]+16k' "$CONF" || fail "falta 'proxy_buffers 8 16k'"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

cp "$CONF" "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

BODY=$(curl -s "http://127.0.0.1:$PORT/")
echo "$BODY" | grep -q 'tuned' || fail "body no contiene 'tuned' (vino: $BODY)"

echo "OK Tests pasaron"
exit 0
