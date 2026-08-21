#!/bin/bash
# Valida los tres estados de archivos con git status --porcelain.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

STATUS=$(git -C "$REPO_DIR" status --porcelain)

# 1. README.md modificado, no staged (XY = " M")
if ! echo "$STATUS" | grep -qE "^ M README.md$"; then
    echo "FAIL Tests fallaron"; echo "  README.md debería estar modificado sin staginar (' M README.md')"; echo "$STATUS"; exit 1
fi

# 2. notas.txt untracked (XY = "??")
if ! echo "$STATUS" | grep -qE "^\?\? notas.txt$"; then
    echo "FAIL Tests fallaron"; echo "  notas.txt debería estar untracked ('?? notas.txt')"; echo "$STATUS"; exit 1
fi

# 3. app.js staged (XY = "M ")
if ! echo "$STATUS" | grep -qE "^M  app.js$"; then
    echo "FAIL Tests fallaron"; echo "  app.js debería estar staged ('M  app.js')"; echo "$STATUS"; exit 1
fi

# 4. Sigue habiendo 2 commits (no se crearon commits nuevos)
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 2 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 2 commits, hay $COUNT"; exit 1
fi

echo "OK Tests pasaron"
