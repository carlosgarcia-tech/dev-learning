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
check_css 'grid-template-columns' 'grid-template-columns'
check_css '1fr' '1fr'
check_css 'gap' 'gap'

ITEMS=$(grep -o 'class="item"' "index.html" | wc -l)
if [[ "$ITEMS" -lt 6 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas 6 items, encontrados: $ITEMS"
  exit 1
fi

echo "OK Tests pasaron"
