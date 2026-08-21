#!/bin/bash
# Valida: feature contiene home.js, último commit es feat: añade feature.js, historia lineal.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. feature contiene home.js (commit de main integrado)
if ! git -C "$REPO_DIR" ls-tree -r feature --name-only | grep -qx "home.js"; then
    echo "FAIL Tests fallaron"; echo "  feature no contiene home.js (rebase no integró main)"; exit 1
fi

# 2. Último commit de feature es feat: añade feature.js
MSG=$(git -C "$REPO_DIR" log feature -1 --format="%s")
if [ "$MSG" != "feat: añade feature.js" ]; then
    echo "FAIL Tests fallaron"; echo "  Último commit esperado 'feat: añade feature.js', obtenido '$MSG'"; exit 1
fi

# 3. feature contiene feature.js
if ! git -C "$REPO_DIR" ls-tree -r feature --name-only | grep -qx "feature.js"; then
    echo "FAIL Tests fallaron"; echo "  feature no contiene feature.js"; exit 1
fi

# 4. Historia lineal: ningún commit de feature tiene 2 padres
MERGE_COMMITS=$(git -C "$REPO_DIR" rev-list --merges feature | wc -l)
if [ "$MERGE_COMMITS" -ne 0 ]; then
    echo "FAIL Tests fallaron"; echo "  feature tiene $MERGE_COMMITS merge commit(s), se esperaba historia lineal"; exit 1
fi

echo "OK Tests pasaron"
