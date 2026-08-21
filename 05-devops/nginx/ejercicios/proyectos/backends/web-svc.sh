#!/usr/bin/env bash
# web-svc: backend simulado de frontend en el puerto 3004
PORT="${WEB_PORT:-3004}"
RESP="HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 7
Connection: close

web-ok"
while true; do
    printf '%s' "$RESP" | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
