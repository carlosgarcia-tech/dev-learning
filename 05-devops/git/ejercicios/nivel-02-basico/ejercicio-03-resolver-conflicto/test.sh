#!/bin/bash
# Valida: conflicto resuelto, línea correcta, merge commit con 2 padres y mensaje correcto.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. No hay conflicto pendiente (clean)
if [ -n "$(git -C "$REPO_DIR" status --porcelain)" ]; then
    echo "FAIL Tests fallaron"; echo "  Quedan cambios sin commitear:"; git -C "$REPO_DIR" status --porcelain; exit 1
fi

# 2. README.md contiene la línea correcta y sin marcadores de conflicto
CONTENT=$(cat "$REPO_DIR/README.md")
if [ "$CONTENT" != "Línea feature" ]; then
    echo "FAIL Tests fallaron"; echo "  README.md esperado 'Línea feature', obtenido:"; echo "$CONTENT"; exit 1
fi
if grep -qE "^(<<<<<<<|=======|>>>>>>>)" "$REPO_DIR/README.md"; then
    echo "FAIL Tests fallaron"; echo "  README.md aún contiene marcadores de conflicto"; exit 1
fi

# 3. Último commit es merge commit con mensaje correcto
MSG=$(git -C "$REPO_DIR" log -1 --format="%s")
if [ "$MSG" != "merge: integra feature" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'merge: integra feature', obtenido '$MSG'"; exit 1
fi

# 4. Tiene 2 padres (merge commit)
PARENTS=$(git -C "$REPO_DIR" rev-list --parents -n 1 HEAD | wc -w)
if [ "$PARENTS" -ne 3 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaba merge commit (2 padres), hay $((PARENTS-1))"; exit 1
fi

echo "OK Tests pasaron"
