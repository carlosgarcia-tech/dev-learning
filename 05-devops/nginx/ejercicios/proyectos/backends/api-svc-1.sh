#!/usr/bin/env bash
# api-svc instancia 1: backend simulado en el puerto 3002
PORT="${API1_PORT:-3002}"
RESP="HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 7
Connection: close

api-ok"
while true; do
    printf '%s' "$RESP" | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
