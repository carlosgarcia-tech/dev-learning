#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
cat > "$DEST/ventas.csv" <<'EOF'
producto,cantidad,precio
manzana,10,0.50
pan,5,1.20
leche,3,1.00
pan,8,1.20
manzana,20,0.50
EOF
