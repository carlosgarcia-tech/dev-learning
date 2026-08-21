#!/usr/bin/env bash
# test.sh — Ejercicio 06 nivel-05 (configuración de producción completa).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
NGINX_BIN="${NGINX_BIN:-nginx}"
TMP_ROOT="$(mktemp -d)"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
RUN_CONF="$TMP_ROOT/run.conf"
MIME_TYPES="$TMP_ROOT/mime.types"

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

# ---------- Validación de estructura (todas las directivas requeridas) ----------
grep -Eq 'worker_processes[[:space:]]+auto' "$CONF" || fail "falta worker_processes auto"
grep -Eq 'worker_connections[[:space:]]+4096' "$CONF" || fail "falta worker_connections 4096"
grep -Eq 'multi_accept[[:space:]]+on' "$CONF" || fail "falta multi_accept on"
grep -Eq 'server_tokens[[:space:]]+off' "$CONF" || fail "falta server_tokens off"
grep -Eq 'gzip[[:space:]]+on' "$CONF" || fail "falta gzip on"
grep -Eq 'gzip_types' "$CONF" || fail "falta gzip_types"
grep -Eq 'limit_req_zone' "$CONF" || fail "falta limit_req_zone"
grep -Eq 'proxy_cache_path' "$CONF" || fail "falta proxy_cache_path"
grep -Eq 'upstream[[:space:]]+backend' "$CONF" || fail "falta upstream backend"
grep -Eq 'max_fails=3' "$CONF" || fail "falta max_fails=3 en upstream"
grep -Eq 'fail_timeout=30s' "$CONF" || fail "falta fail_timeout=30s en upstream"
grep -Eq 'keepalive[[:space:]]+32' "$CONF" || fail "falta keepalive 32 en upstream"
grep -Eq 'return[[:space:]]+301[[:space:]]+https://' "$CONF" || fail "falta return 301 https:// en server HTTP"
grep -Eq 'listen[[:space:]]+443[[:space:]]+ssl[[:space:]]+http2' "$CONF" || fail "falta 'listen 443 ssl http2'"
grep -Eq 'ssl_protocols[[:space:]]+TLSv1\.2' "$CONF" || fail "falta ssl_protocols TLSv1.2"
grep -Eq 'TLSv1\.3' "$CONF" || fail "falta TLSv1.3"
grep -Eq 'Strict-Transport-Security' "$CONF" || fail "falta HSTS"
grep -Eq 'X-Frame-Options' "$CONF" || fail "falta X-Frame-Options"
grep -Eq 'X-Content-Type-Options' "$CONF" || fail "falta X-Content-Type-Options"
grep -Eq 'proxy_pass[[:space:]]+http://backend' "$CONF" || fail "falta proxy_pass http://backend en /api/"
grep -Eq 'proxy_cache[[:space:]]+cache' "$CONF" || fail "falta proxy_cache cache en /api/"
grep -Eq 'limit_req[[:space:]]+zone=api' "$CONF" || fail "falta limit_req zone=api en /api/"
grep -Eq 'request_time' "$CONF" || fail "falta request_time en log_format"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

# ---------- Validación con nginx -t ----------
cat > "$MIME_TYPES" <<'EOF'
types {
    text/html html htm;
    text/css css;
    application/javascript js;
    application/json json;
    image/svg+xml svg;
}
EOF

# Sustituir paths para que nginx -t no falle por rutas inexistentes
sed -e "s#include[[:space:]]\+mime\.types#include $MIME_TYPES#" \
    -e "s#/etc/nginx/ssl/app.crt#$TMP_ROOT/dummy.crt#" \
    -e "s#/etc/nginx/ssl/app.key#$TMP_ROOT/dummy.key#" \
    -e "s#/var/cache/nginx#$TMP_ROOT/cache#" \
    -e "s#/var/log/nginx#$TMP_ROOT/logs#" \
    -e "s#/var/www/app#$TMP_ROOT/www#" \
    "$CONF" > "$RUN_CONF"
mkdir -p "$TMP_ROOT/cache" "$TMP_ROOT/logs" "$TMP_ROOT/www"

# Generar cert dummy
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout "$TMP_ROOT/dummy.key" -out "$TMP_ROOT/dummy.crt" \
  -days 1 -subj "/CN=localhost" 2>/dev/null || true

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"

echo "OK Tests pasaron"
exit 0
