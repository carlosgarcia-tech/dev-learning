#!/bin/bash
# Valida: clon existe con 2 commits, mensaje correcto, README.md modificado.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

ORIGIN_DIR=$(bash "$SCRIPT_DIR/setup.sh")
TMP_DIR="$(dirname "$ORIGIN_DIR")"
trap 'rm -rf "$TMP_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$ORIGIN_DIR"

CLON="$TMP_DIR/clon"

# 1. El clon existe y es un repo
if [ ! -d "$CLON/.git" ]; then
    echo "FAIL Tests fallaron"; echo "  No existe el clon en $CLON"; exit 1
fi

# 2. 2 commits
COUNT=$(git -C "$CLON" rev-list --count HEAD)
if [ "$COUNT" -ne 2 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 2 commits, hay $COUNT"; exit 1
fi

# 3. Mensaje del último commit
MSG=$(git -C "$CLON" log -1 --format="%s")
if [ "$MSG" != "docs: añade sección Uso" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'docs: añade sección Uso', obtenido '$MSG'"; exit 1
fi

# 4. README.md contiene la línea
if ! grep -q "^## Uso$" "$CLON/README.md"; then
    echo "FAIL Tests fallaron"; echo "  README.md no contiene '## Uso'"; exit 1
fi

echo "OK Tests pasaron"
