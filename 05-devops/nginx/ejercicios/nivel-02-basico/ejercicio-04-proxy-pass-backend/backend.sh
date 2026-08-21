#!/usr/bin/env bash
# backend simulado: servidor HTTP mínimo en bash con nc que responde "backend-ok"
# Uso: bash backend.sh
# Escucha en bucle en el puerto 9001
PORT="${BACKEND_PORT:-9001}"
RESP="HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 11
Connection: close

backend-ok"

while true; do
    printf '%s' "$RESP" | nc -l -p "$PORT" -w 2 >/dev/null 2>&1 || sleep 0.2
done
