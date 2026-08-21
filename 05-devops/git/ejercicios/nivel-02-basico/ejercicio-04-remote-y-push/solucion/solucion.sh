#!/bin/bash
# Solución: crear feature.js, commitear y push al remoto.
set -euo pipefail
CLON_DIR="${1:-.}"
cd "$CLON_DIR"

echo "export function feature() {}" > feature.js
git add feature.js
git commit -q -m "feat: añade feature.js"
git push -q origin HEAD
