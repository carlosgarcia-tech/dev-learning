#!/bin/bash
# Crea un remoto bare y dos clones. clon-a sube un commit extra; el estudiante hace pull en clon-b.
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

TMP=$(mktemp -d)
REMOTE="$TMP/remote.git"

# 1. Remoto con commit inicial
SEED="$TMP/_seed"
git init -q -b main "$SEED"
cd "$SEED"
echo "# Proyecto" > README.md
git add README.md
git commit -q -m "Commit inicial"
git init -q --bare "$REMOTE"
git -C "$SEED" remote add origin "$REMOTE"
git -C "$SEED" push -q origin main
rm -rf "$SEED"

# 2. clon-a añade y sube un commit
git clone -q "$REMOTE" "$TMP/clon-a"
cd "$TMP/clon-a"
echo "nuevo" > nuevo.txt
git add nuevo.txt
git commit -q -m "feat: añade nuevo.txt"
git push -q origin main

# 3. clon-b sin el commit extra
git clone -q "$REMOTE" "$TMP/clon-b"

echo "$TMP/clon-b"
