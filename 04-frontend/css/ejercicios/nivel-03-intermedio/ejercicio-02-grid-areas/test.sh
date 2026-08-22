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
check_css 'grid-template-areas' 'grid-template-areas'
check_css 'grid-area: header' 'area header'
check_css 'grid-area: nav' 'area nav'
check_css 'grid-area: main' 'area main'
check_css 'grid-area: aside' 'area aside'
check_css 'grid-area: footer' 'area footer'
check_css 'min-height: 100vh' 'min-height 100vh'
check_css 'gap' 'gap'

echo "OK Tests pasaron"
