#!/usr/bin/env bash
# backend 2 simulado: responde "backend-2" en el puerto 9002
PORT="${BACKEND_PORT:-9002}"
RESP="HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 10
Connection: close

backend-2"
while true; do
    printf '%s' "$RESP" | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
