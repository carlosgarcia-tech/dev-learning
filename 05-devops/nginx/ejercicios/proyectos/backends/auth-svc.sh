#!/usr/bin/env bash
# auth-svc: backend simulado de autenticación en el puerto 3001
PORT="${AUTH_PORT:-3001}"
RESP="HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 7
Connection: close

auth-ok"
while true; do
    printf '%s' "$RESP" | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
