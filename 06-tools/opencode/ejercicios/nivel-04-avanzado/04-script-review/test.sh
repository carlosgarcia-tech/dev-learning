#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/review.sh" ] || { echo "Falta review.sh"; exit 1; }
grep -q "opencode" "$DIR/review.sh" || { echo "No menciona opencode"; exit 1; }
echo "OK"
