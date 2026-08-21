#!/bin/bash
# Valida: main contiene docs.md, mensaje correcto, merge fue fast-forward.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. docs.md está en main
if ! git -C "$REPO_DIR" ls-tree -r main --name-only | grep -qx "docs.md"; then
    echo "FAIL Tests fallaron"; echo "  docs.md no está en main"; exit 1
fi

# 2. Último commit de main tiene el mensaje correcto
MSG=$(git -C "$REPO_DIR" log main -1 --format="%s")
if [ "$MSG" != "docs: añade docs.md" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'docs: añade docs.md', obtenido '$MSG'"; exit 1
fi

# 3. Fue fast-forward: el último commit de main NO es un merge commit (no tiene 2 padres)
PARENTS=$(git -C "$REPO_DIR" rev-list --parents -n 1 main | wc -w)
# rev-list --parents devuelve: <commit> <padre1> [padre2] => 2 palabras si 1 padre, 3 si 2 padres
if [ "$PARENTS" -gt 2 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaba merge fast-forward (1 padre), pero hay merge commit ($((PARENTS-1)) padres)"; exit 1
fi

echo "OK Tests pasaron"
