#!/bin/bash
# Solución: crear .gitignore, archivos a ignorar, y commitear el .gitignore.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

printf "*.log\nnode_modules/\n" > .gitignore
echo "debug" > debug.log
mkdir -p node_modules
echo "{}" > node_modules/paquete.json

git add .gitignore
git commit -q -m "chore: añade .gitignore"
