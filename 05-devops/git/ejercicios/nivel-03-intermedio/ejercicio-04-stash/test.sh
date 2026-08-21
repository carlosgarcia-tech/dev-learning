#!/bin/bash
# Valida: README.md contiene TODO y hay cambios sin commitear (working tree dirty).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. README.md contiene la línea TODO
if ! grep -q "^## TODO$" "$REPO_DIR/README.md"; then
    echo "FAIL Tests fallaron"; echo "  README.md no contiene '## TODO'"; exit 1
fi

# 2. Working tree dirty (cambios sin commitear)
if [ -z "$(git -C "$REPO_DIR" status --porcelain)" ]; then
    echo "FAIL Tests fallaron"; echo "  El working tree está limpio, se esperaban cambios sin commitear"; exit 1
fi

# 3. Sigue habiendo 1 commit (no se crearon commits nuevos)
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 1 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 1 commit, hay $COUNT"; exit 1
fi

echo "OK Tests pasaron"
