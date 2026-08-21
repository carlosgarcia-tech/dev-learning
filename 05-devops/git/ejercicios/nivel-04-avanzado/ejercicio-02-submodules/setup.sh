#!/bin/bash
# Crea main-repo y lib-repo (bare) con un commit. Imprime: ruta_main\nruta_lib
set -euo pipefail
export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

TMP=$(mktemp -d)
MAIN="$TMP/main-repo"
LIB="$TMP/lib-repo.git"

# 1. lib-repo bare con un commit (mediante un seed)
SEED="$TMP/_seed_lib"
git init -q -b main "$SEED"
echo "contenido de lib" > "$SEED/lib.txt"
git -C "$SEED" add lib.txt
git -C "$SEED" commit -q -m "lib: commit inicial"
git init -q --bare "$LIB"
git -C "$SEED" remote add origin "$LIB"
git -C "$SEED" push -q origin main
rm -rf "$SEED"

# 2. main-repo con un commit
git init -q -b main "$MAIN"
echo "# Proyecto principal" > "$MAIN/README.md"
git -C "$MAIN" add README.md
git -C "$MAIN" commit -q -m "Commit inicial"

printf "%s\n%s\n" "$MAIN" "$LIB"
