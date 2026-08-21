#!/bin/bash
# Valida: .gitignore con reglas, commiteado; debug.log y node_modules/ ignorados.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. .gitignore existe y commiteado
if [ ! -f "$REPO_DIR/.gitignore" ]; then
    echo "FAIL Tests fallaron"; echo "  .gitignore no existe"; exit 1
fi
if ! git -C "$REPO_DIR" ls-files --error-unmatch .gitignore >/dev/null 2>&1; then
    echo "FAIL Tests fallaron"; echo "  .gitignore no está commiteado"; exit 1
fi

# 2. Contiene las reglas
if ! grep -q "^\*\.log$" "$REPO_DIR/.gitignore"; then
    echo "FAIL Tests fallaron"; echo "  .gitignore no contiene '*.log'"; exit 1
fi
if ! grep -q "^node_modules/" "$REPO_DIR/.gitignore"; then
    echo "FAIL Tests fallaron"; echo "  .gitignore no contiene 'node_modules/'"; exit 1
fi

# 3. Mensaje del commit
MSG=$(git -C "$REPO_DIR" log -1 --format="%s")
if [ "$MSG" != "chore: añade .gitignore" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'chore: añade .gitignore', obtenido '$MSG'"; exit 1
fi

# 4. debug.log existe en disco pero está ignorado
if [ ! -f "$REPO_DIR/debug.log" ]; then
    echo "FAIL Tests fallaron"; echo "  debug.log no existe en disco"; exit 1
fi
if git -C "$REPO_DIR" status --porcelain | grep -q "debug.log"; then
    echo "FAIL Tests fallaron"; echo "  debug.log aparece como untracked (debería ignorarse)"; exit 1
fi

# 5. node_modules existe en disco pero está ignorado
if [ ! -d "$REPO_DIR/node_modules" ]; then
    echo "FAIL Tests fallaron"; echo "  node_modules/ no existe en disco"; exit 1
fi
if git -C "$REPO_DIR" status --porcelain | grep -q "node_modules"; then
    echo "FAIL Tests fallaron"; echo "  node_modules/ aparece como untracked (debería ignorarse)"; exit 1
fi

echo "OK Tests pasaron"
