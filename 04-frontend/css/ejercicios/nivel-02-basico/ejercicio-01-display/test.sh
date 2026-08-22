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

check_css 'display: block' 'display block'
check_css 'display: inline' 'display inline'
check_css 'display: inline-block' 'display inline-block'
check_css 'width' 'width en inline-block'
check_css 'height' 'height en inline-block'

echo "OK Tests pasaron"
