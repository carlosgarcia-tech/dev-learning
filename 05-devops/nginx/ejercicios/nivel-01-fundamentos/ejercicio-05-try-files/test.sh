#!/usr/bin/env bash
# test.sh — Ejercicio 05 (try_files): fallback a index.html para SPAs.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((18400 + RANDOM % 1000))}
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
[ -f "$WEB_DIR/real.html" ] || fail "falta web/real.html"
grep -q 'SPA' "$WEB_DIR/index.html" || fail "index.html debe contener 'SPA'"
grep -q 'pagina real' "$WEB_DIR/real.html" || fail "real.html debe contener 'pagina real'"

grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF" || fail "falta events"
grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF" || fail "falta http"
grep -Eq '^[[:space:]]*server[[:space:]]*\{' "$CONF" || fail "falta server"
grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF" || fail "falta listen 8080"
grep -Eq '^[[:space:]]*root[[:space:]]+' "$CONF" || fail "falta root"
grep -Eq 'try_files[[:space:]]+\$uri[[:space:]]+\$uri/[[:space:]]+/index\.html' "$CONF" \
    || fail "falta 'try_files \$uri \$uri/ /index.html;' (el fallback debe ser /index.html)"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

awk -v web="$WEB_DIR" '/^[[:space:]]*root[[:space:]]+/{sub(/root[[:space:]]+[^;]+;/, "root " web ";")} {print}' "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

check() {
    local path="$1" want_status="$2" want_body="$3"
    local s b
    s=$(curl -s -o /tmp_b_$$ -w "%{http_code}" "http://127.0.0.1:$PORT$path")
    b=$(cat /tmp_b_$$ 2>/dev/null || true); rm -f /tmp_b_$$
    [ "$s" = "$want_status" ] || fail "$path: esperaba $want_status, vino $s"
    if [ -n "$want_body" ]; then
        echo "$b" | grep -q "$want_body" || fail "$path: body no contiene '$want_body' (vino: $b)"
    fi
}

check "/real.html" "200" "pagina real"
check "/ruta/inventada" "200" "SPA"

echo "OK Tests pasaron"
exit 0
