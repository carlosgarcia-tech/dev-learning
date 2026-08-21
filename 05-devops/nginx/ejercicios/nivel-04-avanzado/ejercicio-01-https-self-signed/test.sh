#!/usr/bin/env bash
# test.sh — Ejercicio 01 nivel-04 (HTTPS self-signed).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
SSL_DIR="$PWD/ssl"
PORT=${TEST_PORT:-$((19800 + RANDOM % 500))}
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
grep -q 'hola https' "$WEB_DIR/index.html" || fail "index.html debe contener 'hola https'"

grep -Eq 'listen[[:space:]]+443[[:space:]]+ssl' "$CONF" || fail "falta 'listen 443 ssl'"
grep -Eq 'ssl_certificate' "$CONF" || fail "falta ssl_certificate"
grep -Eq 'ssl_certificate_key' "$CONF" || fail "falta ssl_certificate_key"
grep -Eq 'ssl_protocols[[:space:]]+TLSv1\.2' "$CONF" || fail "falta ssl_protocols TLSv1.2"
grep -Eq 'TLSv1\.3' "$CONF" || fail "falta TLSv1.3 en ssl_protocols"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

# Generar cert si no existe
if [ ! -f "$SSL_DIR/selfsigned.crt" ] || [ ! -f "$SSL_DIR/selfsigned.key" ]; then
    bash ssl/generate-cert.sh >/dev/null 2>&1 || fail "no se pudo generar el certificado (¿openssl?)"
fi

# Sustituir paths de ssl y root, y el puerto 443 por uno efímero
sed -e "s#/ruta/abs/ssl#$SSL_DIR#g" \
    -e "s#/ruta/abs/a/web#$WEB_DIR#g" \
    -e "s#listen[[:space:]]\+443 ssl#listen $PORT ssl#" "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -sk -o /dev/null "https://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

STATUS=$(curl -sk -o /tmp_b_$$ -w "%{http_code}" "https://127.0.0.1:$PORT/")
BODY=$(cat /tmp_b_$$); rm -f /tmp_b_$$
[ "$STATUS" = "200" ] || fail "se esperaba 200, vino $STATUS"
echo "$BODY" | grep -q 'hola https' || fail "body no contiene 'hola https' (vino: $BODY)"

echo "OK Tests pasaron"
exit 0
