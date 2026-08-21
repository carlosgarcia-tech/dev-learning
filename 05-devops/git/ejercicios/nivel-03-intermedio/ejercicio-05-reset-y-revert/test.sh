#!/bin/bash
# Valida: último commit es revert: deshace a.txt; a.txt no está tracked; b.txt existe sin commitear.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Último commit es revert: deshace a.txt
MSG=$(git -C "$REPO_DIR" log -1 --format="%s")
if [ "$MSG" != "revert: deshace a.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  Último commit esperado 'revert: deshace a.txt', obtenido '$MSG'"; exit 1
fi

# 2. a.txt no está tracked en el HEAD actual (fue revertido)
if git -C "$REPO_DIR" ls-tree -r HEAD --name-only | grep -qx "a.txt"; then
    echo "FAIL Tests fallaron"; echo "  a.txt sigue en HEAD (el revert no funcionó)"; exit 1
fi

# 3. b.txt existe en disco pero NO está commiteado (cambios sin commitear)
if [ ! -f "$REPO_DIR/b.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  b.txt no existe en disco (se perdió con el reset)"; exit 1
fi
if git -C "$REPO_DIR" ls-tree -r HEAD --name-only | grep -qx "b.txt"; then
    echo "FAIL Tests fallaron"; echo "  b.txt está commiteado (debería estar solo en working tree)"; exit 1
fi

# 4. b.txt aparece como cambio sin commitear
if ! git -C "$REPO_DIR" status --porcelain | grep -q "b.txt"; then
    echo "FAIL Tests fallaron"; echo "  b.txt no aparece en status como cambio sin commitear"; exit 1
fi

echo "OK Tests pasaron"
