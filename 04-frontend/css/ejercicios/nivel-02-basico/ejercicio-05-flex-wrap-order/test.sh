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

check_css 'display: flex' 'display flex'
check_css 'flex-wrap: wrap' 'flex-wrap wrap'
check_css 'gap' 'gap'
check_css 'order' 'order'

ORDER_COUNT=$(grep -o 'order' "style.css" | wc -l)
if [[ "$ORDER_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas al menos 2 order distintos, encontrados: $ORDER_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
