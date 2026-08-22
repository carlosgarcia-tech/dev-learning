#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/encontrados.txt" ] || { echo "Falta encontrados.txt"; exit 1; }
grep -q "\.md" "$DIR/encontrados.txt" || { echo "No se encontraron .md"; exit 1; }
echo "OK"
