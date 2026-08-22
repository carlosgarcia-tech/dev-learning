#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

check_file() {
  if [[ ! -f "$1" ]]; then
    echo "FAIL Tests fallaron"
    echo "Falta $1"
    exit 1
  fi
}

check_file "index.html"
check_file "style.css"

check_css() {
  if ! grep -qi "$1" "style.css"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en style.css: $2"
    exit 1
  fi
}

check_css 'display: grid' 'display grid'
check_css '@media' 'media query'
check_css 'min-width: 768px' 'breakpoint 768px'
check_css 'min-width: 1024px' 'breakpoint 1024px'

# Debe usar min-width (mobile-first), no max-width
if grep -qi 'max-width' "style.css"; then
  echo "FAIL Tests fallaron"
  echo "Usa min-width (mobile-first), no max-width"
  exit 1
fi

ITEMS=$(grep -o 'class="item"' "index.html" | wc -l)
if [[ "$ITEMS" -lt 6 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas 6 items, encontrados: $ITEMS"
  exit 1
fi

echo "OK Tests pasaron"
