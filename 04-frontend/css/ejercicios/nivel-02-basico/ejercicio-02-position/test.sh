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

check_css 'position: relative' 'position relative'
check_css 'position: absolute' 'position absolute'
check_css 'position: fixed' 'position fixed'
check_css 'position: sticky' 'position sticky'
check_css 'top:' 'top'
check_css 'z-index' 'z-index'

echo "OK Tests pasaron"
