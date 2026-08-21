#!/usr/bin/env bash
# test.sh — Ejercicio 01 nivel-02 (gzip): verifica Content-Encoding: gzip.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((18600 + RANDOM % 1000))}
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
[ -f "$WEB_DIR/app.css" ] || fail "falta web/app.css"
SIZE=$(wc -c < "$WEB_DIR/app.css")
[ "$SIZE" -ge 300 ] || fail "web/app.css debe tener >=300 bytes (tiene $SIZE)"

grep -Eq '^[[:space:]]*gzip[[:space:]]+on' "$CONF" || fail "falta 'gzip on'"
grep -Eq 'gzip_types' "$CONF" || fail "falta gzip_types"
grep -Eq 'gzip_min_length' "$CONF" || fail "falta gzip_min_length"
echo "$CONF" | grep -Eq 'text/css' || grep -q 'text/css' "$CONF" || fail "gzip_types debe incluir text/css"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

cat > "$MIME_TYPES" <<'EOF'
types {
    text/html html htm;
    text/css css;
    application/javascript js;
    application/json json;
    image/svg+xml svg;
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

CE=$(curl -s -o /dev/null -D - -H "Accept-Encoding: gzip" "http://127.0.0.1:$PORT/app.css" | tr -d '\r' \
    | awk -F': ' 'tolower($1)=="content-encoding"{print $2}')
case "$CE" in gzip) : ;; *) fail "no se encontró Content-Encoding: gzip (vino '$CE'). ¿gzip_min_length demasiado alto?" ;; esac

echo "OK Tests pasaron"
exit 0
