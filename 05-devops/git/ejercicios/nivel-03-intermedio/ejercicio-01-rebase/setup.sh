#!/bin/bash
# Crea main y feature divergentes (cada una con un commit que la otra no tiene).
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(mktemp -d)
cd "$REPO_DIR"
git init -q -b main
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"

# main avanza
git switch main
echo "function home() {}" > home.js
git add home.js
git commit -q -m "feat: añade home"

# feature diverge desde el commit inicial
git switch -c feature HEAD~1
echo "function feature() {}" > feature.js
git add feature.js
git commit -q -m "feat: añade feature.js"

# El estudiante está en feature
git switch feature

echo "$REPO_DIR"
