#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
cat > "$DEST/config.conf" <<'EOF'
# Configuracion de la app
host = localhost
puerto = 8080
debug = true
nivel = DEBUG
nombre = app-vieja
# Fin
EOF
