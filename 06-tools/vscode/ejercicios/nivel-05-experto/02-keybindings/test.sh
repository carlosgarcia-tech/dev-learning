#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/keybindings.json" ] || { echo "Falta keybindings.json"; exit 1; }
node -p "require('./$DIR/keybindings.json')[0].command" | grep -q "commentLine" || { echo "Falta commentLine"; exit 1; }
echo "OK"
