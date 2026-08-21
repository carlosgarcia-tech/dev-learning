#!/usr/bin/env bash
# test.sh — Ejercicio 05 nivel-02 (location regex): imágenes, css y bloqueo php.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((19000 + RANDOM % 1000))}
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
[ -f "$WEB_DIR/logo.svg" ] || fail "falta web/logo.svg"
[ -f "$WEB_DIR/app.css" ] || fail "falta web/app.css"
[ -f "$WEB_DIR/index.html" ] || fail "falta web/index.html"

grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF" || fail "falta events"
grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF" || fail "falta http"
grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF" || fail "falta listen 8080"
grep -Eq 'location[[:space:]]+~\*' "$CONF" || fail "falta location con regex (~*)"
grep -Eq 'location[[:space:]]+~\*[[:space:]]+\\\.php' "$CONF" || fail "falta location ~* \\.php\$"
grep -Eq 'return[[:space:]]+403' "$CONF" || fail "falta return 403 para php"
grep -Eq 'expires[[:space:]]+30d' "$CONF" || fail "falta expires 30d para imágenes"
grep -Eq 'expires[[:space:]]+1y' "$CONF" || fail "falta expires 1y para css/js"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

cat > "$MIME_TYPES" <<'EOF'
types {
    text/html html htm;
    text/css css;
    image/svg+xml svg;
    image/png png;
}
EOF

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

cc_of() {
    curl -s -o /dev/null -D - "http://127.0.0.1:$PORT$1" | tr -d '\r' \
        | awk -F': ' 'tolower($1)=="cache-control"{print $2}'
}
status_of() {
    curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT$1"
}

CC_SVG=$(cc_of "/logo.svg")
CC_CSS=$(cc_of "/app.css")
ST_PHP=$(status_of "/evil.php")

echo "$CC_SVG" | grep -qi 'max-age' || fail "/logo.svg Cache-Control debe tener max-age (vino '$CC_SVG')"
echo "$CC_CSS" | grep -qi 'max-age=31536000' || fail "/app.css debe tener max-age=31536000 (vino '$CC_CSS')"
[ "$ST_PHP" = "403" ] || fail "/evil.php debería dar 403 (vino $ST_PHP)"

echo "OK Tests pasaron"
exit 0
