#!/bin/bash
# Valida: apps/web.txt existe; apps/api.txt y docs/leame.txt no.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

ORIGIN=$(bash "$SCRIPT_DIR/setup.sh")
TMP_DIR="$(dirname "$ORIGIN")"
CLON="$TMP_DIR/clon"
trap 'rm -rf "$TMP_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$ORIGIN"

# 1. apps/web.txt existe
if [ ! -f "$CLON/apps/web.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  apps/web.txt no existe (debería estar incluido)"; exit 1
fi

# 2. apps/api.txt NO existe (excluido por sparse-checkout)
if [ -f "$CLON/apps/api.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  apps/api.txt existe (debería estar excluido por sparse-checkout)"; exit 1
fi

# 3. docs/leame.txt NO existe
if [ -f "$CLON/docs/leame.txt" ]; then
    echo "FAIL Tests fallaron"; echo "  docs/leame.txt existe (debería estar excluido)"; exit 1
fi

echo "OK Tests pasaron"
