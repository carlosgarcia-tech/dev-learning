#!/usr/bin/env bash
set -euo pipefail

ARCHIVO="index.html"

if [[ ! -f "$ARCHIVO" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta el archivo $ARCHIVO"
  exit 1
fi

check() {
  if ! grep -qi "$1" "$ARCHIVO"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check "<!DOCTYPE html>" "DOCTYPE"
check "<html lang=\"es\">" "html con lang es"
check "<meta charset" "meta charset"
check "viewport" "meta viewport"
check "<title>" "title"
check "description" "meta description"
check "<h1>" "encabezado h1"
check "<p>" "parrafo p"

echo "OK Tests pasaron"
