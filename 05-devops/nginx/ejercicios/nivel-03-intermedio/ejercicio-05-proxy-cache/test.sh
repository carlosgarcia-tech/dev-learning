#!/usr/bin/env bash
# test.sh — Ejercicio 05 nivel-03 (proxy_cache): MISS luego HIT.
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
PORT=${TEST_PORT:-$((19600 + RANDOM % 1000))}
NGINX_BIN="${NGINX_BIN:-nginx}"
B1_PORT="${BACKEND1_PORT:-9001}"
TMP_ROOT="$(mktemp -d)"
CACHE_DIR="$TMP_ROOT/cache"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
ACC_FILE="$TMP_ROOT/access.log"
RUN_CONF="$TMP_ROOT/run.conf"
B1_PID=""

cleanup() {
    if [ -f "$PID_FILE" ]; then
        "$NGINX_BIN" -s stop -g "pid $PID_FILE;" >/dev/null 2>&1 || true
        kill "$(cat "$PID_FILE" 2>/dev/null)" >/dev/null 2>&1 || true
        rm -f "$PID_FILE"
    fi
    [ -n "$B1_PID" ] && kill "$B1_PID" >/dev/null 2>&1 || true
    rm -rf "$TMP_ROOT"
}
trap cleanup EXIT
fail() { echo "FAIL Tests fallaron"; echo "  -> $1"; exit 1; }

[ -f "$CONF" ] || fail "no existe $CONF"
[ -f "backend.sh" ] || fail "falta backend.sh"

grep -Eq 'proxy_cache_path' "$CONF" || fail "falta proxy_cache_path"
grep -Eq 'keys_zone=api_cache' "$CONF" || fail "falta keys_zone=api_cache en proxy_cache_path"
grep -Eq 'proxy_cache[[:space:]]+api_cache' "$CONF" || fail "falta proxy_cache api_cache"
grep -Eq 'proxy_cache_valid[[:space:]]+200' "$CONF" || fail "falta proxy_cache_valid 200"
grep -Eq 'proxy_cache_key' "$CONF" || fail "falta proxy_cache_key"
grep -Eq 'X-Cache-Status' "$CONF" || fail "falta add_header X-Cache-Status"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

mkdir -p "$CACHE_DIR"
# Sustituir el path del cache y el puerto del backend
sed -e "s#/var/cache/nginx#$CACHE_DIR#g" \
    -e "s#/tmp/nginx_cache#$CACHE_DIR#g" \
    -e "s/127.0.0.1:9001/127.0.0.1:$B1_PORT/g" "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"

if command -v nc >/dev/null 2>&1; then
    BACKEND_PORT=$B1_PORT bash backend.sh >/dev/null 2>&1 &
    B1_PID=$!
    sleep 0.5
fi

"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/api/" 2>/dev/null && break
    sleep 0.1
done

if [ -n "$B1_PID" ]; then
    # Primera petición: MISS
    CS1=$(curl -s -o /dev/null -D - "http://127.0.0.1:$PORT/api/" | tr -d '\r' | awk -F': ' 'tolower($1)=="x-cache-status"{print $2}')
    # Segunda petición: HIT
    sleep 0.3
    CS2=$(curl -s -o /dev/null -D - "http://127.0.0.1:$PORT/api/" | tr -d '\r' | awk -F': ' 'tolower($1)=="x-cache-status"{print $2}')
    BODY=$(curl -s "http://127.0.0.1:$PORT/api/")
    echo "$BODY" | grep -q 'cached-data' || fail "body no contiene 'cached-data' (vino: $BODY)"
    case "$CS2" in HIT|EXPIRED) : ;; *) fail "segunda petición debería ser HIT, vino '$CS2' (primera: '$CS1')" ;; esac
fi

echo "OK Tests pasaron"
exit 0
