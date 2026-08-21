#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
cat > "$DEST/acceso.log" <<'EOF'
192.168.1.10 - - [20/May/2025:10:00:01] "GET /index.html" 200
192.168.1.11 - - [20/May/2025:10:00:05] "POST /api/login" 401
192.168.1.10 - - [20/May/2025:10:00:10] "GET /about" 200
192.168.1.12 - - [20/May/2025:10:00:15] "GET /index.html" 200
192.168.1.11 - - [20/May/2025:10:00:20] "POST /api/login" 200
192.168.1.13 - - [20/May/2025:10:00:25] "GET /favicon.ico" 404
192.168.1.10 - - [20/May/2025:10:00:30] "GET /css/main.css" 200
192.168.1.12 - - [20/May/2025:10:00:35] "POST /api/data" 500
EOF
