#!/usr/bin/env bash
# test.sh — Ejercicio 05 nivel-04 (security headers).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((20700 + RANDOM % 500))}
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

grep -Eq 'Strict-Transport-Security' "$CONF" || fail "falta HSTS (Strict-Transport-Security)"
grep -Eq 'max-age=31536000' "$CONF" || fail "HSTS max-age debe ser 31536000"
grep -Eq 'X-Frame-Options' "$CONF" || fail "falta X-Frame-Options"
grep -Eq 'SAMEORIGIN' "$CONF" || fail "X-Frame-Options debe ser SAMEORIGIN"
grep -Eq 'X-Content-Type-Options' "$CONF" || fail "falta X-Content-Type-Options"
grep -Eq 'nosniff' "$CONF" || fail "X-Content-Type-Options debe ser nosniff"
grep -Eq 'Referrer-Policy' "$CONF" || fail "falta Referrer-Policy"
grep -Eq 'always' "$CONF" || fail "las cabeceras deben llevar 'always'"

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

HEADERS=$(curl -s -o /dev/null -D - "http://127.0.0.1:$PORT/" | tr -d '\r')
echo "$HEADERS" | grep -qi 'Strict-Transport-Security' || fail "falta HSTS en la respuesta"
echo "$HEADERS" | grep -qi 'X-Frame-Options' || fail "falta X-Frame-Options en la respuesta"
echo "$HEADERS" | grep -qi 'X-Content-Type-Options' || fail "falta X-Content-Type-Options en la respuesta"
echo "$HEADERS" | grep -qi 'Referrer-Policy' || fail "falta Referrer-Policy en la respuesta"

echo "OK Tests pasaron"
exit 0
