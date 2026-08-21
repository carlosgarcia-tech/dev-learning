#!/bin/bash
# Solución: dejar archivos en los tres estados pedidos.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

echo "## Licencia" >> README.md        # modified, unstaged
echo "notas" > notas.txt               # untracked
echo "// nuevo" >> app.js              # modified
git add app.js                         # staged (sin commitear)
