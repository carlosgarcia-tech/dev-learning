#!/bin/bash
# Solución: modificar, stash, y pop.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

echo "## TODO" >> README.md
git stash
git stash pop
