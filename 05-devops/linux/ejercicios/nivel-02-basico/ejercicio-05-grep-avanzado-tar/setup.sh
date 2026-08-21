#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/logs"
cat > "$DEST/logs/app.log" <<'EOF'
[2025-01-01 10:00:00] INFO  Arrancando la app
[2025-01-01 10:00:05] debug  debug mode activado
[2025-01-01 10:01:00] ERROR Fallo en módulo X
[2025-01-01 10:02:00] WARNING Memoria alta
[2025-01-01 10:03:00] ERROR Timeout en base de datos
EOF
cat > "$DEST/logs/server.log" <<'EOF'
[2025-01-01 09:00:00] INFO  Servidor listo
[2025-01-01 09:05:00] debug  variable de entorno
[2025-01-01 09:10:00] WARNING Conexión lenta
[2025-01-01 09:15:00] ERROR Puerto en uso
EOF
