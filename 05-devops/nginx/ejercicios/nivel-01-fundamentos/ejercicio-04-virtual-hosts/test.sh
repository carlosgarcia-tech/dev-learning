#!/usr/bin/env bash
# test.sh — Ejercicio 04 (virtual hosts): app1.local y app2.local + default 444.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((18300 + RANDOM % 1000))}
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
[ -f "$WEB_DIR/app1/index.html" ] || fail "falta web/app1/index.html"
[ -f "$WEB_DIR/app2/index.html" ] || fail "falta web/app2/index.html"

# Contar server blocks y validar estructura
SERVERS=$(grep -Ec '^[[:space:]]*server[[:space:]]*\{' "$CONF" || true)
[ "$SERVERS" -ge 3 ] || fail "se esperaban >=3 server blocks, hay $SERVERS"
grep -Eq 'listen[[:space:]]+8080[[:space:]]+default_server' "$CONF" || fail "falta 'listen 8080 default_server'"
grep -Eq 'server_name[[:space:]]+app1\.local' "$CONF" || fail "falta server_name app1.local"
grep -Eq 'server_name[[:space:]]+app2\.local' "$CONF" || fail "falta server_name app2.local"
grep -Eq 'return[[:space:]]+444' "$CONF" || fail "falta return 444 en el default"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

awk -v web="$WEB_DIR" '/^[[:space:]]*root[[:space:]]+/{sub(/root[[:space:]]+[^;]+;/, "root " web "/app1;")} /app1/{print; next} {print}' "$CONF" > "$RUN_CONF" 2>/dev/null || cp "$CONF" "$RUN_CONF"
# En realidad, sustituir cada root por la carpeta correspondiente es complejo con awk.
# Simplificación: dejar que el usuario use $PWD/web en su config; el test sustituye rutas relativas.
sed "s#/ruta/abs/a/web#$WEB_DIR#g; s#$PWD/web#$WEB_DIR#g" "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" -H "Host: app1.local" 2>/dev/null && break
    sleep 0.1
done

check_host() {
    local host="$1" want_body="$2"
    local b
    b=$(curl -s "http://127.0.0.1:$PORT/" -H "Host: $host" 2>/dev/null || true)
    echo "$b" | grep -q "$want_body" || fail "Host $host: body no contiene '$want_body' (vino: $b)"
}
check_host "app1.local" "app1"
check_host "app2.local" "app2"

# default host: 444 cierra la conexión -> curl falla con código 000
DEF=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:$PORT/" -H "Host: desconocido.local" 2>/dev/null || true)
[ "$DEF" = "000" ] || [ "$DEF" = "444" ] || fail "host desconocido debería dar 444/cierre (vino $DEF)"

echo "OK Tests pasaron"
exit 0
