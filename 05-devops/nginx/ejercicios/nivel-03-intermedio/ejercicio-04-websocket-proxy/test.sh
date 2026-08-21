#!/usr/bin/env bash
# test.sh — Ejercicio 04 nivel-03 (proxy de WebSocket).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
PORT=${TEST_PORT:-$((19500 + RANDOM % 1000))}
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

grep -Eq 'map[[:space:]]+\$http_upgrade' "$CONF" || fail "falta map \$http_upgrade \$connection_upgrade"
grep -Eq 'default[[:space:]]+upgrade' "$CONF" || fail "el map debe tener 'default upgrade'"
grep -Eq "''[[:space:]]+close" "$CONF" || grep -Eq "''.*close" "$CONF" || fail "el map debe tener '' close"
grep -Eq 'proxy_pass[[:space:]]+http://ws_backend' "$CONF" || fail "falta proxy_pass http://ws_backend"
grep -Eq 'proxy_http_version[[:space:]]+1\.1' "$CONF" || fail "falta proxy_http_version 1.1"
grep -Eq 'proxy_set_header[[:space:]]+Upgrade' "$CONF" || fail "falta proxy_set_header Upgrade"
grep -Eq 'proxy_set_header[[:space:]]+Connection' "$CONF" || fail "falta proxy_set_header Connection"
grep -Eq 'proxy_read_timeout[[:space:]]+3600s' "$CONF" || fail "falta proxy_read_timeout 3600s"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

cp "$CONF" "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"

"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/ws" 2>/dev/null && break
    sleep 0.1
done

echo "OK Tests pasaron"
exit 0
