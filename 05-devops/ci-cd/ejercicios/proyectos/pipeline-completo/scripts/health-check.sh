#!/usr/bin/env bash
set -euo pipefail

URL="${HEALTH_URL:-http://ci-cd-app-svc/health}"

for i in $(seq 1 10); do
    if curl -fsS "$URL" 2>/dev/null | grep -q '"ok"'; then
        echo "✅ Health check OK (intento $i)"
        exit 0
    fi
    echo "Intento $i fallido, reintentando en 5s..."
    sleep 5
done

echo "❌ Health check falló después de 10 intentos"
exit 1
