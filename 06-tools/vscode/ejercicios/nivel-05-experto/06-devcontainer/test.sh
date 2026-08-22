#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.devcontainer/devcontainer.json" ] || { echo "Falta devcontainer.json"; exit 1; }
node -p "require('./$DIR/.devcontainer/devcontainer.json').postCreateCommand" | grep -q "pnpm install" || { echo "Falta postCreateCommand"; exit 1; }
echo "OK"
