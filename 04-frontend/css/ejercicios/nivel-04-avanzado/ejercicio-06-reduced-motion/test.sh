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
check_css 'animation' 'animation'
check_css 'prefers-reduced-motion' 'prefers-reduced-motion'
check_css 'animation-duration' 'animation-duration en reduced'
check_css 'transition-duration' 'transition-duration en reduced'

echo "OK Tests pasaron"
