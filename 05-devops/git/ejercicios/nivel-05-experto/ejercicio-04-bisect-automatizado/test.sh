#!/bin/bash
# Valida: .bisect-result con hash del culpable (c5), el padre no tiene BUG.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Existe .bisect-result
if [ ! -f "$REPO_DIR/.bisect-result" ]; then
    echo "FAIL Tests fallaron"; echo "  No existe .bisect-result"; exit 1
fi

# 2. El hash corresponde al commit c5
RESULT=$(cat "$REPO_DIR/.bisect-result" | tr -d '[:space:]')
MSG=$(git -C "$REPO_DIR" log -1 --format="%s" "$RESULT" 2>/dev/null || echo "")
if [ "$MSG" != "c5: introduce bug" ]; then
    echo "FAIL Tests fallaron"
    echo "  Commit identificado: '$MSG'"
    echo "  Se esperaba 'c5: introduce bug'"
    exit 1
fi

# 3. El commit contiene BUG
if ! git -C "$REPO_DIR" show "$RESULT:app.txt" | grep -q "^BUG$"; then
    echo "FAIL Tests fallaron"; echo "  El commit identificado no contiene BUG en app.txt"; exit 1
fi

# 4. El commit padre NO contiene BUG
PARENT=$(git -C "$REPO_DIR" rev-parse "$RESULT^" 2>/dev/null || echo "")
if [ -n "$PARENT" ]; then
    if git -C "$REPO_DIR" show "$PARENT:app.txt" 2>/dev/null | grep -q "^BUG$"; then
        echo "FAIL Tests fallaron"; echo "  El commit padre ya tenía BUG (no es el culpable real)"; exit 1
    fi
fi

echo "OK Tests pasaron"
