#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/package-lock.json" ] || { echo "Falta package-lock.json"; exit 1; }
echo "OK"
