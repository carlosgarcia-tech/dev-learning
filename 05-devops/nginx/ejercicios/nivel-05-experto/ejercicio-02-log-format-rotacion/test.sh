#!/usr/bin/env bash
# test.sh — Ejercicio 02 nivel-05 (log format y rotación).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
LOG_DIR="$PWD/logs"
PORT=${TEST_PORT:-$((21000 + RANDOM % 500))}
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
[ -f "logrotate/nginx" ] || fail "falta logrotate/nginx"

grep -Eq 'log_format' "$CONF" || fail "falta log_format"
grep -Eq 'request_time' "$CONF" || fail "log_format debe incluir \$request_time"
grep -Eq 'upstream_response_time' "$CONF" || fail "log_format debe incluir \$upstream_response_time"
grep -Eq 'access_log.*main' "$CONF" || fail "falta access_log con formato main"
grep -Eq 'error_log.*warn' "$CONF" || fail "falta error_log con nivel warn"

grep -Eq 'daily' "logrotate/nginx" || fail "logrotate debe tener 'daily'"
grep -Eq 'rotate[[:space:]]+14' "logrotate/nginx" || fail "logrotate debe tener 'rotate 14'"
grep -Eq 'compress' "logrotate/nginx" || fail "logrotate debe tener 'compress'"
grep -Eq 'postrotate' "logrotate/nginx" || fail "logrotate debe tener 'postrotate'"
grep -Eq 'USR1' "logrotate/nginx" || fail "logrotate postrotate debe usar kill -USR1"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

mkdir -p "$LOG_DIR"
sed -e "s#/ruta/logs#$LOG_DIR#g" "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

BODY=$(curl -s "http://127.0.0.1:$PORT/")
echo "$BODY" | grep -q 'logged' || fail "body no contiene 'logged' (vino: $BODY)"

# verificar que el access.log tiene el formato (con rt=)
sleep 0.3
grep -q 'rt=' "$LOG_DIR/access.log" 2>/dev/null || fail "access.log no contiene 'rt=' (formato no aplicado)"

echo "OK Tests pasaron"
exit 0
