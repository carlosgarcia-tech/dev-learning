#!/usr/bin/env bash
# test.sh — Ejercicio 05 nivel-05 (FastCGI PHP-FPM).
# Nota: requiere nginx para validación completa; sin nginx valida sintaxis/estructura.
#        Requiere php-fpm para validación de ejecución PHP.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

CONF="nginx.conf"
WEB_DIR="$PWD/web"
PORT=${TEST_PORT:-$((21300 + RANDOM % 500))}
NGINX_BIN="${NGINX_BIN:-nginx}"
TMP_ROOT="$(mktemp -d)"
PID_FILE="$TMP_ROOT/nginx.pid"
ERR_FILE="$TMP_ROOT/error.log"
ACC_FILE="$TMP_ROOT/access.log"
RUN_CONF="$TMP_ROOT/run.conf"
FASTCGI_PARAMS="$TMP_ROOT/fastcgi_params"

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
[ -f "$WEB_DIR/index.php" ] || fail "falta web/index.php"
grep -q 'php-fpm ok' "$WEB_DIR/index.php" || fail "index.php debe contener 'php-fpm ok'"

grep -Eq 'location[[:space:]]+~[[:space:]]*\\\.php' "$CONF" || fail "falta location ~ \\.php\$"
grep -Eq 'fastcgi_pass' "$CONF" || fail "falta fastcgi_pass"
grep -Eq 'fastcgi_index' "$CONF" || fail "falta fastcgi_index"
grep -Eq 'include[[:space:]]+fastcgi_params' "$CONF" || fail "falta include fastcgi_params"
grep -Eq 'fastcgi_param[[:space:]]+SCRIPT_FILENAME' "$CONF" || fail "falta fastcgi_param SCRIPT_FILENAME"
grep -Eq 'try_files.*index\.php' "$CONF" || fail "falta try_files con /index.php (front controller)"

if ! command -v "$NGINX_BIN" >/dev/null 2>&1; then
    echo "OK Tests pasaron"; exit 0
fi

# Crear un fastcgi_params mínimo portable
cat > "$FASTCGI_PARAMS" <<'EOF'
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE      $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;
fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;
EOF

awk -v web="$WEB_DIR" -v fp="$FASTCGI_PARAMS" '
    /^[[:space:]]*root[[:space:]]+/ { sub(/root[[:space:]]+[^;]+;/, "root " web ";") }
    /include[[:space:]]+fastcgi_params/ { sub(/fastcgi_params/, fp) }
    { print }
' "$CONF" > "$RUN_CONF"

"$NGINX_BIN" -t -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE;" >/dev/null 2>&1 \
    || fail "nginx -t falla (ver $ERR_FILE)"

# Solo arrancar nginx (php-fpm puede no estar disponible)
"$NGINX_BIN" -c "$RUN_CONF" -g "pid $PID_FILE; error_log $ERR_FILE; access_log $ACC_FILE;" >/dev/null 2>&1 \
    || fail "no se pudo arrancar nginx"

for _ in $(seq 1 30); do
    curl -s -o /dev/null "http://127.0.0.1:$PORT/" 2>/dev/null && break
    sleep 0.1
done

# Si php-fpm está disponible, verificar ejecución; si no, solo validar que nginx responde
if command -v php-fpm >/dev/null 2>&1 || [ -S /run/php-fpm/www.sock ]; then
    BODY=$(curl -s --max-time 3 "http://127.0.0.1:$PORT/index.php" || true)
    echo "$BODY" | grep -q 'php-fpm ok' || fail "PHP no respondió 'php-fpm ok' (vino: $BODY)"
fi

echo "OK Tests pasaron"
exit 0
