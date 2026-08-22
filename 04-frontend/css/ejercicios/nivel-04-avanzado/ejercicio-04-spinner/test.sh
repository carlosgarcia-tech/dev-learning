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

check_css '@keyframes' '@keyframes'
check_css 'spin' 'nombre spin'
check_css 'rotate(360deg)' 'rotate 360deg'
check_css 'animation' 'animation'
check_css 'infinite' 'infinite'
check_css 'linear' 'linear'
check_css 'border-radius: 50%' 'border-radius 50%'
check_css 'border-top-color' 'border-top-color'

echo "OK Tests pasaron"
