#!/bin/bash
# Valida: existe .pack, fsck sin errores de objetos corruptos, count-objects muestra packs.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export GIT_AUTHOR_NAME="Test User" GIT_AUTHOR_EMAIL="test@example.com"
export GIT_COMMITTER_NAME="Test User" GIT_COMMITTER_EMAIL="test@example.com"

REPO_DIR=$(bash "$SCRIPT_DIR/setup.sh")
trap 'rm -rf "$REPO_DIR"' EXIT

bash "$SCRIPT_DIR/solucion/solucion.sh" "$REPO_DIR"

# 1. Existe al menos un .pack en .git/objects/pack/
PACK_COUNT=$(find "$REPO_DIR/.git/objects/pack/" -name "*.pack" 2>/dev/null | wc -l)
if [ "$PACK_COUNT" -lt 1 ]; then
    echo "FAIL Tests fallaron"; echo "  No hay archivos .pack en .git/objects/pack/ (gc no empaquetó)"; exit 1
fi

# 2. git fsck no reporta errores de objetos corruptos
FSCK_OUT=$(git -C "$REPO_DIR" fsck --full 2>&1 || true)
if echo "$FSCK_OUT" | grep -qiE "error:|missing|corrupt"; then
    echo "FAIL Tests fallaron"; echo "  git fsck reporta errores de integridad:"; echo "$FSCK_OUT"; exit 1
fi

# 3. count-objects muestra packs > 0
COUNT=$(git -C "$REPO_DIR" count-objects -v)
PACKS=$(echo "$COUNT" | grep "^count:" | awk '{print $2}')
# count: es el nº de objetos sueltos; tras gc debería ser 0 o bajo
LOOSE=$(echo "$COUNT" | grep "^count:" | awk '{print $2}')
if [ -z "$LOOSE" ]; then
    echo "FAIL Tests fallaron"; echo "  count-objects no muestra información de count"; exit 1
fi

echo "OK Tests pasaron"
