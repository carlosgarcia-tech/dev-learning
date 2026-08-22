#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/check.sh" ] || { echo "Falta check.sh"; exit 1; }
bash "$DIR/check.sh" "$DIR/check.sh" | grep -q "OK" || { echo "Debería imprimir OK para un archivo existente"; exit 1; }
bash "$DIR/check.sh" "$DIR/no-existe.xyz" 2>/dev/null | grep -q "ERROR" || { echo "Debería imprimir ERROR para archivo inexistente"; exit 1; }
echo "OK"
