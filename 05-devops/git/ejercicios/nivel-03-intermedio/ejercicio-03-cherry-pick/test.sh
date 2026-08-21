#!/bin/bash
# Valida: main contiene hotfix.js, último mensaje correcto, no trajo docs.md.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. main contiene hotfix.js
if ! git -C "$REPO_DIR" ls-tree -r main --name-only | grep -qx "hotfix.js"; then
    echo "FAIL Tests fallaron"; echo "  main no contiene hotfix.js"; exit 1
fi

# 2. Último commit de main es el fix
MSG=$(git -C "$REPO_DIR" log main -1 --format="%s")
if [ "$MSG" != "fix: corrige bug crítico" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'fix: corrige bug crítico', obtenido '$MSG'"; exit 1
fi

# 3. main NO debe contener docs.md (solo se trajo el hotfix, no toda la rama)
if git -C "$REPO_DIR" ls-tree -r main --name-only | grep -qx "docs.md"; then
    echo "FAIL Tests fallaron"; echo "  main contiene docs.md (no debería, solo se cherry-pickea el hotfix)"; exit 1
fi

echo "OK Tests pasaron"
