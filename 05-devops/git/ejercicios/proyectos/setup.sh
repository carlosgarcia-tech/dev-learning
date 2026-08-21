#!/bin/bash
# Crea el repo inicial + remote simulado (bare) y copia los archivos starter.
# Imprime: ruta_repo\nruta_remote
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)

REPO="$TMP/repo"
REMOTE="$TMP/remote.git"

# 1. Repo bare (remote simulado)
git init -q --bare "$REMOTE"

# 2. Repo de trabajo
git init -q -b main "$REPO"
cd "$REPO"
git config user.name "Test User"
git config user.email "test@example.com"

# Copiar starter
cp -r "$SCRIPT_DIR/starter/." .
chmod +x .githooks/pre-commit .githooks/commit-msg scripts/generate-changelog.sh
git config core.hooksPath .githooks

# Commit inicial con main.js
git add app/main.js
git commit -q -m "feat: commit inicial con app"

# Añadir remote
git remote add origin "$REMOTE"

printf "%s\n%s\n" "$REPO" "$REMOTE"
