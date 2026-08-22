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
check_css 'space-between' 'space-between'
check_css 'align-items: center' 'align-items center'
check_css 'gap' 'gap'

echo "OK Tests pasaron"
