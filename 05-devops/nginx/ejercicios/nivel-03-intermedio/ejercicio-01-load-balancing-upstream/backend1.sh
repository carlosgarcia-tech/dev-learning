#!/usr/bin/env bash
# backend 1 simulado: responde "backend-1" en el puerto 9001
PORT="${BACKEND_PORT:-9001}"
RESP="HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 10
Connection: close

backend-1"
while true; do
    printf '%s' "$RESP" | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
