#!/bin/bash
# Valida: repositorio inicializado, 1 commit, README.md commiteado, mensaje correcto.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User"
export GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User"
export GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Debe ser un repositorio git
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "FAIL Tests fallaron"
    echo "  No se encontró .git/ — el repositorio no está inicializado"
    exit 1
fi

# 2. Debe haber exactamente 1 commit
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 1 ]; then
    echo "FAIL Tests fallaron"
    echo "  Se esperaban 1 commit, hay $COUNT"
    exit 1
fi

# 3. El mensaje del commit debe ser "Commit inicial"
MSG=$(git -C "$REPO_DIR" log -1 --format="%s")
if [ "$MSG" != "Commit inicial" ]; then
    echo "FAIL Tests fallaron"
    echo "  Mensaje esperado: 'Commit inicial', obtenido: '$MSG'"
    exit 1
fi

# 4. README.md debe estar commiteado (tracked)
if ! git -C "$REPO_DIR" ls-files --error-unmatch README.md >/dev/null 2>&1; then
    echo "FAIL Tests fallaron"
    echo "  README.md no está commiteado"
    exit 1
fi

echo "OK Tests pasaron"
