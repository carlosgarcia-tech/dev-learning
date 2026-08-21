#!/usr/bin/env bash
# test.sh — Ejercicio 06 (index y default_type): text/html y application/json.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((18500 + RANDOM % 1000))}
NGINX_BIN="${NGINX_BIN:-nginx}"
TMP_ROOT="$(mktemp -d)"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
ACC_FILE="$TMP_ROOT/access.log"
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
[ -f "$WEB_DIR/index.html" ] || fail "falta web/index.html"
[ -f "$WEB_DIR/api/data.json" ] || fail "falta web/api/data.json"
grep -q 'inicio' "$WEB_DIR/index.html" || fail "index.html debe contener 'inicio'"
grep -q 'ok' "$WEB_DIR/api/data.json" || fail "data.json debe contener ok"

grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF" || fail "falta events"
grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF" || fail "falta http"
grep -Eq '^[[:space:]]*server[[:space:]]*\{' "$CONF" || fail "falta server"
grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF" || fail "falta listen 8080"
grep -Eq '^[[:space:]]*root[[:space:]]+' "$CONF" || fail "falta root"
grep -Eq '^[[:space:]]*index[[:space:]]+index\.html' "$CONF" || fail "falta index index.html"
grep -Eq 'location[[:space:]]+/api/' "$CONF" || fail "falta location /api/"
grep -Eq 'default_type[[:space:]]+application/json' "$CONF" || fail "falta default_type application/json en /api/"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

# Generar un mime.types mínimo portable (por si /etc/nginx/mime.types no existe)
cat > "$MIME_TYPES" <<'EOF'
types {
    text/html                             html htm;
    text/css                              css;
    application/javascript                js;
    application/json                      json;
    image/png                             png;
    image/jpeg                            jpg jpeg;
}
EOF

# Sustituir root y el include de mime.types por paths controlados
awk -v web="$WEB_DIR" -v mime="$MIME_TYPES" '
    /^[[:space:]]*root[[:space:]]+/        { sub(/root[[:space:]]+[^;]+;/, "root " web ";") }
    /^[[:space:]]*include[[:space:]]+.*mime\.types/ { sub(/include[[:space:]]+[^;]+;/, "include " mime ";") }
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

ct_of() {
    curl -s -o /dev/null -D - "http://127.0.0.1:$PORT$1" | tr -d '\r' \
        | awk -F': ' 'tolower($1)=="content-type"{print $2}'
}
body_of() {
    curl -s -o /tmp_b_$$ -w "%{http_code}" "http://127.0.0.1:$PORT$1"
    cat /tmp_b_$$; rm -f /tmp_b_$$
}

CT_HTML=$(ct_of "/")
CT_JSON=$(ct_of "/api/data.json")
B_HTML=$(curl -s "http://127.0.0.1:$PORT/")
B_JSON=$(curl -s "http://127.0.0.1:$PORT/api/data.json")

echo "$B_HTML" | grep -q 'inicio' || fail "/ no contiene 'inicio' (vino: $B_HTML)"
echo "$B_JSON" | grep -q 'ok' || fail "/api/data.json no contiene ok (vino: $B_JSON)"
case "$CT_HTML" in text/html*) : ;; *) fail "/ Content-Type debería ser text/html, vino '$CT_HTML'" ;; esac
case "$CT_JSON" in application/json*) : ;; *) fail "/api/ Content-Type debería ser application/json, vino '$CT_JSON'" ;; esac

echo "OK Tests pasaron"
exit 0
