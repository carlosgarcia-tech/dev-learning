#!/usr/bin/env bash
# api-svc instancia 2: backend simulado en el puerto 3003
PORT="${API2_PORT:-3003}"
RESP="HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 7
Connection: close

api-ok"
while true; do
    printf '%s' "$RESP" | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
