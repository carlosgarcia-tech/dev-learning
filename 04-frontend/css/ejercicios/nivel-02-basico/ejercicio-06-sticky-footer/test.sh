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
check_css 'flex-direction: column' 'flex-direction column'
check_css 'min-height: 100vh' 'min-height 100vh'
check_css 'flex: 1' 'flex 1 en main'

echo "OK Tests pasaron"
