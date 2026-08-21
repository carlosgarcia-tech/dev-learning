#!/bin/bash
# Valida: 3 commits, último es feat: tercero, c.txt presente.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. 3 commits
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 3 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 3 commits, hay $COUNT"; exit 1
fi

# 2. Último commit
MSG=$(git -C "$REPO_DIR" log -1 --format="%s")
if [ "$MSG" != "feat: tercero" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'feat: tercero', obtenido '$MSG'"; exit 1
fi

# 3. c.txt presente
if [ ! -f "$REPO_DIR/c.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  c.txt no existe (no se recuperó)"; exit 1
fi

echo "OK Tests pasaron"
