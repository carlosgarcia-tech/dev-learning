#!/bin/bash
# Solución: clonar el origen, modificar README.md y commitear.
set -euo pipefail
ORIGIN="${1:-.}"
cd "$(dirname "$ORIGIN")"

git clone -q "$ORIGIN" clon
cd clon
echo "## Uso" >> README.md
git add README.md
git commit -q -m "docs: añade sección Uso"
