#!/usr/bin/env bash
# scripts/health-check.sh
set -euo pipefail
for i in $(seq 1 5); do
    if curl -fsS http://mi-app-svc/health; then
        echo "Health OK"
        exit 0
    fi
    echo "Intento $i fallido, reintentando en 5s..."
    sleep 5
done
echo "Health check falló después de 5 intentos"
exit 1
