#!/usr/bin/env bash
# test.sh — Ejercicio 02 nivel-04 (redirect HTTP -> HTTPS).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
SSL_DIR="$PWD/ssl"
HTTP_PORT=${HTTP_PORT:-$((19900 + RANDOM % 500))}
HTTPS_PORT=${HTTPS_PORT:-$((20400 + RANDOM % 500))}
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

SERVERS=$(grep -Ec '^[[:space:]]*server[[:space:]]*\{' "$CONF" || true)
[ "$SERVERS" -ge 2 ] || fail "se esperaban >=2 server blocks (HTTP+HTTPS), hay $SERVERS"
grep -Eq 'listen[[:space:]]+80[^0-9]' "$CONF" || fail "falta 'listen 80' en el server HTTP"
grep -Eq 'return[[:space:]]+301[[:space:]]+https://' "$CONF" || fail "falta 'return 301 https://\$host\$request_uri'"
grep -Eq 'listen[[:space:]]+443[[:space:]]+ssl' "$CONF" || fail "falta 'listen 443 ssl'"
grep -Eq 'ssl_certificate' "$CONF" || fail "falta ssl_certificate"
grep -Eq 'ssl_protocols[[:space:]]+TLSv1\.2' "$CONF" || fail "falta ssl_protocols TLSv1.2"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

if [ ! -f "$SSL_DIR/selfsigned.crt" ]; then
    bash ssl/generate-cert.sh >/dev/null 2>&1 || fail "no se pudo generar el certificado"
fi

# Sustituir paths y puertos
sed -e "s#/ruta/abs/ssl#$SSL_DIR#g" \
    -e "s#/ruta/abs/a/web#$WEB_DIR#g" \
    -e "s#listen[[:space:]]\+80;#listen $HTTP_PORT;#" \
    -e "s#listen[[:space:]]\+443 ssl#listen $HTTPS_PORT ssl#" "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$HTTP_PORT/" 2>/dev/null && break
    sleep 0.1
done

STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$HTTP_PORT/")
LOC=$(curl -s -o /dev/null -D - "http://127.0.0.1:$HTTP_PORT/" | tr -d '\r' | awk -F': ' 'tolower($1)=="location"{print $2}')
[ "$STATUS" = "301" ] || fail "se esperaba 301, vino $STATUS"
echo "$LOC" | grep -qi 'https://' || fail "Location debería ser https:// (vino '$LOC')"

echo "OK Tests pasaron"
exit 0
