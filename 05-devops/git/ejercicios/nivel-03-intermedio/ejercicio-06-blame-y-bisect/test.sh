#!/bin/bash
# Valida: .bisect-result contiene el hash del commit que introdujo BUG (c3).
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

# 2. El hash del culpable es el commit cuyo mensaje es "c3: introduce bug"
RESULT=$(cat "$REPO_DIR/.bisect-result" | tr -d '[:space:]')
CULPRIT_MSG=$(git -C "$REPO_DIR" log -1 --format="%s" "$RESULT" 2>/dev/null || echo "")
if [ "$CULPRIT_MSG" != "c3: introduce bug" ]; then
    echo "FAIL Tests fallaron"
    echo "  Commit identificado: '$CULPRIT_MSG'"
    echo "  Se esperaba el commit 'c3: introduce bug'"
    exit 1
fi

# 3. El commit identificado es el que introduce BUG (comprobar que en ese commit aparece BUG por primera vez)
if ! git -C "$REPO_DIR" show "$RESULT:bug.txt" | grep -q "^BUG$"; then
    echo "FAIL Tests fallaron"; echo "  El commit identificado no contiene BUG en bug.txt"; exit 1
fi
# Y el commit anterior NO lo contiene
PARENT=$(git -C "$REPO_DIR" rev-parse "$RESULT^" 2>/dev/null || echo "")
if [ -n "$PARENT" ]; then
    if git -C "$REPO_DIR" show "$PARENT:bug.txt" 2>/dev/null | grep -q "^BUG$"; then
        echo "FAIL Tests fallaron"; echo "  El commit padre ya tenía BUG (no es el culpable real)"; exit 1
    fi
fi

echo "OK Tests pasaron"
