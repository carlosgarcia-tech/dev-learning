#!/bin/bash
# Crea main y feature que cambian la MISMA línea de README.md (conflicto garantizado).
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "Línea inicial" > README.md
git add README.md
git commit -q -m "Commit inicial"

# feature cambia la línea
git switch -c feature
echo "Línea feature" > README.md
git commit -q -am "feat: cambia línea en feature"

# main también cambia la misma línea
git switch main
echo "Línea main" > README.md
git commit -q -am "feat: cambia línea en main"

echo "$REPO_DIR"
