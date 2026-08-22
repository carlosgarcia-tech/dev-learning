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

check "<header" "header"
check "<nav" "nav"
check "<main" "main"
check "<article" "article"
check "<section" "section"
check "<aside" "aside"
check "<footer" "footer"
check "<h1" "h1 en header"
check "<h2" "h2 en article"
check "<h3" "h3 en section"

echo "OK Tests pasaron"
