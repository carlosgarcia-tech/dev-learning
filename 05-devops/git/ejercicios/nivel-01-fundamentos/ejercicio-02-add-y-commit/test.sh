#!/bin/bash
# Valida: app.js existe con contenido, está commiteado, 2 commits, mensaje correcto.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. app.js existe y con el contenido correcto
if [ ! -f "$REPO_DIR/app.js" ]; then
    echo "FAIL Tests fallaron"; echo "  app.js no existe"; exit 1
fi
CONTENT=$(cat "$REPO_DIR/app.js")
if [ "$CONTENT" != 'console.log("hola");' ]; then
    echo "FAIL Tests fallaron"; echo "  Contenido de app.js incorrecto: '$CONTENT'"; exit 1
fi

# 2. app.js commiteado
if ! git -C "$REPO_DIR" ls-files --error-unmatch app.js >/dev/null 2>&1; then
    echo "FAIL Tests fallaron"; echo "  app.js no está commiteado"; exit 1
fi

# 3. Exactamente 2 commits
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 2 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 2 commits, hay $COUNT"; exit 1
fi

# 4. Mensaje del último commit
MSG=$(git -C "$REPO_DIR" log -1 --format="%s")
if [ "$MSG" != "feat: añade app.js" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'feat: añade app.js', obtenido '$MSG'"; exit 1
fi

echo "OK Tests pasaron"
