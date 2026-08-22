#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/bashrc-extra.sh" ] || { echo "Falta bashrc-extra.sh"; exit 1; }
COUNT=$(grep -c "^alias" "$DIR/bashrc-extra.sh")
[ "$COUNT" -ge 3 ] || { echo "Se necesitan al menos 3 alias, hay $COUNT"; exit 1; }
echo "OK"
