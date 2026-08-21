#!/usr/bin/env bash
# test.sh — Ejercicio 01 (server-block): valida nginx.conf.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail

cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
PORT=${TEST_PORT:-$((18000 + RANDOM % 1000))}
NGINX_BIN="${NGINX_BIN:-nginx}"
TMP_ROOT="$(mktemp -d)"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
ACC_FILE="$TMP_ROOT/access.log"

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

if [ ! -f "$CONF" ]; then
    fail "no existe $CONF"
fi

# ---------- Validación de estructura (siempre) ----------
if ! grep -Eq '^[[:space:]]*events[[:space:]]*\{' "$CONF"; then
    fail "falta el bloque 'events { ... }'"
fi
if ! grep -Eq '^[[:space:]]*http[[:space:]]*\{' "$CONF"; then
    fail "falta el bloque 'http { ... }'"
fi
if ! grep -Eq '^[[:space:]]*server[[:space:]]*\{' "$CONF"; then
    fail "falta el bloque 'server { ... }'"
fi
if ! grep -Eq '^[[:space:]]*listen[[:space:]]+8080' "$CONF"; then
    fail "falta 'listen 8080;'"
fi
if ! grep -Eq '^[[:space:]]*location[[:space:]]+/' "$CONF"; then
    fail "falta 'location /'"
fi
if ! grep -Eq 'return[[:space:]]+200' "$CONF"; then
    fail "falta 'return 200 ...' que devuelva el body"
fi
if ! grep -Eq 'hola nginx' "$CONF"; then
    fail "el body debe contener 'hola nginx'"
fi

# ---------- Si nginx no está disponible, terminar con OK ----------
if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"
    exit 0
fi

# ---------- Validación con nginx real ----------
"$NGINX_BIN" -t -c "$PWD/$CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (sintaxis inválida). Ver $ERR_FILE"

"$NGINX_BIN" -c "$PWD/$CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

# esperar a que escuche
for _ in $(seq 1 30); do
    if curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null; then break; fi
    sleep 0.1
done

STATUS=$(curl -s -o /tmp_body_$$ -w "%{http_code}" "http://127.0.0.1:$PORT/")
BODY=$(cat /tmp_body_$$ 2>/dev/null || true)
rm -f /tmp_body_$$
CT=$(curl -s -o /dev/null -D - "http://127.0.0.1:$PORT/" | tr -d '\r' | awk -F': ' '/^[Cc]ontent-[Tt]ype/{print $2}')

[ "$STATUS" = "200" ] || fail "se esperaba HTTP 200, vino $STATUS"
[ "$BODY" = "hola nginx" ] || fail "body inesperado: '$BODY'"
case "$CT" in
    text/plain*) : ;;
    *) fail "Content-Type debería ser text/plain, vino '$CT'" ;;
esac

echo "OK Tests pasaron"
exit 0
