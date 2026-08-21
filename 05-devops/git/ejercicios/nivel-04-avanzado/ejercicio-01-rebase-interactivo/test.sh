#!/bin/bash
# Valida: 5 commits; mensajes en orden (reciente->antiguo): feat: commit final, wip 2, wip 3, wip 4, Commit inicial.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Exactamente 5 commits
COUNT=$(git -C "$REPO_DIR" rev-list --count HEAD)
if [ "$COUNT" -ne 5 ]; then
    echo "FAIL Tests fallaron"; echo "  Se esperaban 5 commits, hay $COUNT"; exit 1
fi

# 2. Orden de mensajes esperado (del más reciente al más antiguo)
EXPECTED="feat: commit final
wip 2
wip 3
wip 4
Commit inicial"
ACTUAL=$(git -C "$REPO_DIR" log --format="%s")
if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "FAIL Tests fallaron"
    echo "  Orden esperado:"; echo "$EXPECTED"
    echo "  Orden obtenido:"; echo "$ACTUAL"
    exit 1
fi

echo "OK Tests pasaron"
