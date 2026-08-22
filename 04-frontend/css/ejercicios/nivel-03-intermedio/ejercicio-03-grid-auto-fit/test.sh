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
check_css 'auto-fit' 'auto-fit'
check_css 'minmax' 'minmax'
check_css 'gap' 'gap'

CARDS=$(grep -o 'class="card"' "index.html" | wc -l)
if [[ "$CARDS" -lt 6 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas 6 cards, encontrados: $CARDS"
  exit 1
fi

echo "OK Tests pasaron"
