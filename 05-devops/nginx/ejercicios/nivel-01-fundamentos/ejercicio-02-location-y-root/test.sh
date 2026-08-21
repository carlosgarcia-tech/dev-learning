#!/usr/bin/env bash
# test.sh — Ejercicio 02 (location y root): sirve web/index.html.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail

cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((18100 + RANDOM % 1000))}
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

fail() {
    echo "FAIL Tests fallaron"
    echo "  -> $1"
    exit 1
}

[ -f "$CONF" ] || fail "no existe $CONF"
[ -f "$WEB_DIR/index.html" ] || fail "falta web/index.html"

# ---------- Validación de estructura ----------
grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF" || fail "falta bloque events"
grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF"   || fail "falta bloque http"
grep -Eq '^[[:space:]]*server[[:space:]]*\{' "$CONF" || fail "falta bloque server"
grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF" || fail "falta listen 8080"
grep -Eq '^[[:space:]]*location[[:space:]]+/' "$CONF"  || fail "falta location /"
grep -Eq '^[[:space:]]*root[[:space:]]+' "$CONF"       || fail "falta directiva root"
grep -Eq '^[[:space:]]*index[[:space:]]+index\.html' "$CONF" || fail "falta index index.html"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"
    exit 0
fi

# ---------- Validación con nginx real ----------
# Sustituir cualquier root relativo/placeholder por el path absoluto real
awk -v web="$WEB_DIR" '
    /^[[:space:]]*root[[:space:]]+/ {
        sub(/root[[:space:]]+[^;]+;/, "root " web ";")
    }
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

STATUS=$(curl -s -o /tmp_body_$$ -w "%{http_code}" "http://127.0.0.1:$PORT/")
BODY=$(cat /tmp_body_$$ 2>/dev/null || true)
rm -f /tmp_body_$$

[ "$STATUS" = "200" ] || fail "se esperaba 200, vino $STATUS"
[ "$BODY" = "pagina de inicio" ] || fail "body inesperado: '$BODY'"

echo "OK Tests pasaron"
exit 0
