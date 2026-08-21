#!/bin/bash
# Valida: 2 commits, mensaje correcto, README.md con todo el contenido acumulado.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Exactamente 2 commits
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 2 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 2 commits, hay $COUNT"; exit 1
fi

# 2. Mensaje del último commit
MSG=$(git -C "$REPO_DIR" log -1 --format="%s")
if [ "$MSG" != "feat: completa documentación" ]; then
    echo "FAIL Tests fallaron"; echo "  Mensaje esperado 'feat: completa documentación', obtenido '$MSG'"; exit 1
fi

# 3. README.md contiene las tres secciones acumuladas
if ! grep -q "## Intro" "$REPO_DIR/README.md"; then
    echo "FAIL Tests fallaron"; echo "  README.md no contiene '## Intro' (se perdió contenido en el squash)"; exit 1
fi
if ! grep -q "## Uso" "$REPO_DIR/README.md"; then
    echo "FAIL Tests fallaron"; echo "  README.md no contiene '## Uso'"; exit 1
fi
if ! grep -q "## FAQ" "$REPO_DIR/README.md"; then
    echo "FAIL Tests fallaron"; echo "  README.md no contiene '## FAQ'"; exit 1
fi

echo "OK Tests pasaron"
