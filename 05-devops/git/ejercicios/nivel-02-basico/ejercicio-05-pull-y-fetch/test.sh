#!/bin/bash
# Valida: clon-b tiene nuevo.txt, 2 commits, último mensaje correcto.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

CLON_B=$(bash "$SCRIPT_DIR/setup.sh")
TMP_DIR="$(dirname "$CLON_B")"
trap 'rm -rf "$TMP_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$CLON_B"

# 1. nuevo.txt existe en clon-b
if [ ! -f "$CLON_B/nuevo.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  nuevo.txt no existe en clon-b"; exit 1
fi

# 2. 2 commits
COUNT=$(git -C "$CLON_B" rev-list --count HEAD)
if [ "$COUNT" -ne 2 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 2 commits, hay $COUNT"; exit 1
fi

# 3. Mensaje correcto
MSG=$(git -C "$CLON_B" log -1 --format="%s")
if [ "$MSG" != "feat: añade nuevo.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'feat: añade nuevo.txt', obtenido '$MSG'"; exit 1
fi

echo "OK Tests pasaron"
