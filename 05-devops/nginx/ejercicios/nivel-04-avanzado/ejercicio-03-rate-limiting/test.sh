#!/usr/bin/env bash
# test.sh — Ejercicio 03 nivel-04 (rate limiting con limit_req).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((20500 + RANDOM % 500))}
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

grep -Eq 'limit_req_zone' "$CONF" || fail "falta limit_req_zone"
grep -Eq 'zone=api_limit' "$CONF" || fail "falta zone=api_limit"
grep -Eq 'rate=5r/s' "$CONF" || fail "falta rate=5r/s"
grep -Eq 'limit_req[[:space:]]+zone=api_limit' "$CONF" || fail "falta limit_req zone=api_limit"
grep -Eq 'burst=10' "$CONF" || fail "falta burst=10"
grep -Eq 'nodelay' "$CONF" || fail "falta nodelay"

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

# Lanzar 30 peticiones rápidas a /api/ y comprobar que alguna da 429 o 503
LIMITED=0
for i in $(seq 1 30); do
    S=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/api/" 2>/dev/null || echo "000")
    case "$S" in 429|503) LIMITED=$((LIMITED+1)) ;; esac
done
[ "$LIMITED" -gt 0 ] || fail "se esperaba que algunas peticiones fueran limitadas (429/503), ninguna lo fue"

echo "OK Tests pasaron"
exit 0
