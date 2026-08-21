#!/bin/bash
# Solución: crear app.js, añadirlo y commitearlo.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

echo 'console.log("hola");' > app.js
git add app.js
git commit -q -m "feat: añade app.js"
