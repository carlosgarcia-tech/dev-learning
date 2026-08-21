#!/usr/bin/env bash
# backend que devuelve las cabeceras que recibe
PORT="${BACKEND_PORT:-9001}"
while true; do
    {
        # leer la petición del cliente
        read -r REQUEST_LINE
        HEADERS=""
        while IFS= read -r line; do
            line="${line%$'\r'}"
            [ -z "$line" ] && break
            HEADERS="$HEADERS$line\n"
        done
        BODY=$(printf "xff:%s" "$(echo -e "$HEADERS" | grep -i 'X-Forwarded-For' | head -1 || true)")
        printf 'HTTP/1.1 200 OK\r\n'
        printf 'Content-Type: text/plain\r\n'
        printf 'Content-Length: %d\r\n' "${#BODY}"
        printf 'Connection: close\r\n\r\n'
        printf '%s' "$BODY"
    } | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
