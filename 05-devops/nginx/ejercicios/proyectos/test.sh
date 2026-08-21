#!/usr/bin/env bash
# test.sh — Proyecto final: Reverse proxy de producción para microservicios.
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
LOG_DIR="$TMP_ROOT/logs"
CACHE_DIR="$TMP_ROOT/cache"

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

# ---------- Validación de estructura ----------
# nginx.conf principal
grep -Eq 'worker_processes[[:space:]]+auto' "$CONF" || fail "nginx.conf: falta worker_processes auto"
grep -Eq 'worker_connections[[:space:]]+4096' "$CONF" || fail "nginx.conf: falta worker_connections 4096"
grep -Eq 'server_tokens[[:space:]]+off' "$CONF" || fail "nginx.conf: falta server_tokens off"
grep -Eq 'include[[:space:]]+conf.d/\*\.conf' "$CONF" || fail "nginx.conf: falta include conf.d/*.conf"

# conf.d/00-upstreams.conf
F="conf.d/00-upstreams.conf"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'upstream[[:space:]]+auth_backend' "$F" || fail "$F: falta upstream auth_backend"
grep -Eq 'upstream[[:space:]]+api_backend' "$F" || fail "$F: falta upstream api_backend"
grep -Eq 'upstream[[:space:]]+web_backend' "$F" || fail "$F: falta upstream web_backend"
grep -Eq 'max_fails=3' "$F" || fail "$F: falta max_fails=3"
grep -Eq 'fail_timeout=30s' "$F" || fail "$F: falta fail_timeout=30s"
grep -Eq 'keepalive[[:space:]]+32' "$F" || fail "$F: falta keepalive 32"

# conf.d/01-rate-limiting.conf
F="conf.d/01-rate-limiting.conf"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'limit_req_zone' "$F" || fail "$F: falta limit_req_zone"
grep -Eq 'zone=auth' "$F" || fail "$F: falta zone=auth"
grep -Eq 'zone=api' "$F" || fail "$F: falta zone=api"

# conf.d/02-cache.conf
F="conf.d/02-cache.conf"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'proxy_cache_path' "$F" || fail "$F: falta proxy_cache_path"
grep -Eq 'keys_zone=api_cache' "$F" || fail "$F: falta keys_zone=api_cache"

# conf.d/03-logging.conf
F="conf.d/03-logging.conf"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'log_format' "$F" || fail "$F: falta log_format"
grep -Eq 'request_time' "$F" || fail "$F: falta request_time en log_format"

# conf.d/10-auth.conf
F="conf.d/10-auth.conf"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'return[[:space:]]+301[[:space:]]+https://' "$F" || fail "$F: falta redirect HTTP->HTTPS"
grep -Eq 'listen[[:space:]]+443[[:space:]]+ssl[[:space:]]+http2' "$F" || fail "$F: falta listen 443 ssl http2"
grep -Eq 'ssl_protocols[[:space:]]+TLSv1\.2' "$F" || fail "$F: falta ssl_protocols TLSv1.2"
grep -Eq 'TLSv1\.3' "$F" || fail "$F: falta TLSv1.3"
grep -Eq 'Strict-Transport-Security' "$F" || fail "$F: falta HSTS"
grep -Eq 'X-Frame-Options' "$F" || fail "$F: falta X-Frame-Options"
grep -Eq 'proxy_pass[[:space:]]+http://auth_backend' "$F" || fail "$F: falta proxy_pass http://auth_backend"
grep -Eq 'limit_req[[:space:]]+zone=auth' "$F" || fail "$F: falta limit_req zone=auth"

# conf.d/11-api.conf
F="conf.d/11-api.conf"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'proxy_pass[[:space:]]+http://api_backend' "$F" || fail "$F: falta proxy_pass http://api_backend"
grep -Eq 'proxy_cache[[:space:]]+api_cache' "$F" || fail "$F: falta proxy_cache api_cache"
grep -Eq 'limit_req[[:space:]]+zone=api' "$F" || fail "$F: falta limit_req zone=api"
grep -Eq 'proxy_set_header[[:space:]]+Host' "$F" || fail "$F: falta proxy_set_header Host"
grep -Eq 'proxy_set_header[[:space:]]+X-Forwarded-For' "$F" || fail "$F: falta proxy_set_header X-Forwarded-For"

# conf.d/12-web.conf
F="conf.d/12-web.conf"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'proxy_pass[[:space:]]+http://web_backend' "$F" || fail "$F: falta proxy_pass http://web_backend"

# logrotate
F="logrotate/nginx"
[ -f "$F" ] || fail "falta $F"
grep -Eq 'daily' "$F" || fail "$F: falta daily"
grep -Eq 'rotate[[:space:]]+30' "$F" || fail "$F: falta rotate 30"
grep -Eq 'postrotate' "$F" || fail "$F: falta postrotate"
grep -Eq 'USR1' "$F" || fail "$F: falta kill -USR1 en postrotate"

# backends
for b in auth-svc api-svc-1 api-svc-2 web-svc; do
    [ -f "backends/$b.sh" ] || fail "falta backends/$b.sh"
done

# ssl
[ -f "ssl/generate-cert.sh" ] || fail "falta ssl/generate-cert.sh"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

# ---------- Validación con nginx -t ----------
mkdir -p "$LOG_DIR" "$CACHE_DIR"

cat > "$MIME_TYPES" <<'EOF'
types {
    text/html html htm;
    text/css css;
    application/javascript js;
    application/json json;
    image/svg+xml svg;
}
EOF

# Generar cert si no existe
if [ ! -f "ssl/proxy.crt" ]; then
    bash ssl/generate-cert.sh >/dev/null 2>&1 || fail "no se pudo generar el certificado"
fi

# Copar config a tmp y sustituir paths
mkdir -p "$TMP_ROOT/conf.d" "$TMP_ROOT/envs"
cp "$CONF" "$RUN_CONF"
cp conf.d/*.conf "$TMP_ROOT/conf.d/"

# Sustituir paths absolutos por tmp en los conf.d
for f in "$TMP_ROOT"/conf.d/*.conf; do
    sed -i \
        -e "s#/var/cache/nginx#$CACHE_DIR#g" \
        -e "s#/var/log/nginx#$LOG_DIR#g" \
        "$f"
done

# Sustituir en el nginx.conf: mime.types y rutas
sed -i \
    -e "s#include[[:space:]]\+mime\.types#include $MIME_TYPES#" \
    "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"

echo "OK Tests pasaron"
exit 0
