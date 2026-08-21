#!/bin/bash
# Valida: worktree existe en la lista, feature contiene feature.txt, mensaje correcto.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
WT_DIR="$REPO_DIR/../wt-feature"
trap 'rm -rf "$REPO_DIR" "$WT_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. El worktree aparece en git worktree list
if ! git -C "$REPO_DIR" worktree list | grep -q "wt-feature"; then
    echo "FAIL Tests fallaron"; echo "  El worktree wt-feature no aparece en git worktree list"; exit 1
fi

# 2. La rama feature contiene feature.txt
if ! git -C "$REPO_DIR" ls-tree -r feature --name-only | grep -qx "feature.txt"; then
    echo "FAIL Tests fallaron"; echo "  feature no contiene feature.txt"; exit 1
fi

# 3. Último commit de feature
MSG=$(git -C "$REPO_DIR" log feature -1 --format="%s")
if [ "$MSG" != "feat: añade feature.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'feat: añade feature.txt', obtenido '$MSG'"; exit 1
fi

echo "OK Tests pasaron"
