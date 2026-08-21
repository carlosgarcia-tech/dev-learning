#!/bin/bash
# Valida: README.md modificado sin commitear, working tree dirty, 2 commits, diff contiene la línea.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. README.md contiene la línea
if ! grep -q "^## Instalación$" "$REPO_DIR/README.md"; then
    echo "FAIL Tests fallaron"; echo "  README.md no contiene '## Instalación'"; exit 1
fi

# 2. Working tree debe estar dirty (cambios sin commitear)
if [ -z "$(git -C "$REPO_DIR" status --porcelain)" ]; then
    echo "FAIL Tests fallaron"; echo "  El working tree está limpio, se esperaban cambios sin commitear"; exit 1
fi

# 3. Sigue habiendo 2 commits
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 2 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 2 commits, hay $COUNT"; exit 1
fi

# 4. git diff contiene la línea añadida
if ! git -C "$REPO_DIR" diff -- README.md | grep -q "+## Instalación"; then
    echo "FAIL Tests fallaron"; echo "  git diff no muestra la línea añadida"; exit 1
fi

echo "OK Tests pasaron"
