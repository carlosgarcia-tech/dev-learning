#!/usr/bin/env bash
# test.sh — Ejercicio 04 nivel-05 (map y geo para bloqueo por IP).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((21200 + RANDOM % 500))}
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

grep -Eq '^[[:space:]]*geo[[:space:]]+\$' "$CONF" || fail "falta directiva geo"
grep -Eq '^[[:space:]]*map[[:space:]]+\$' "$CONF" || fail "falta directiva map"
grep -Eq 'allow' "$CONF" || fail "el map debe tener 'allow'"
grep -Eq 'deny' "$CONF" || fail "el map debe tener 'deny'"
# contar rangos con valor 1 en el geo
COUNT_1=$(grep -Ec '[[:space:]]+1;?$' "$CONF" || true)
[ "$COUNT_1" -ge 2 ] || fail "geo debe tener al menos 2 rangos con valor 1 (hay $COUNT_1)"
grep -Eq 'return[[:space:]]+403' "$CONF" || fail "falta 'return 403' para el bloqueo"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

awk -v web="$WEB_DIR" '
    /^[[:space:]]*root[[:space:]]+/ { sub(/root[[:space:]]+[^;]+;/, "root " web ";") }
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

# 127.0.0.1 no está en los rangos bloqueados -> 200
ST=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/")
[ "$ST" = "200" ] || fail "/ debería dar 200 para IP no bloqueada (vino $ST)"

echo "OK Tests pasaron"
exit 0
