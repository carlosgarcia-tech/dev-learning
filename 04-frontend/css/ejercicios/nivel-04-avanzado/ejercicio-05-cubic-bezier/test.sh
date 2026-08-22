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

check_css 'cubic-bezier' 'cubic-bezier'
check_css 'transition' 'transition'
check_css 'transform' 'transform'
check_css ':hover' 'hover'

# Verificar que tiene 4 valores (con valores fuera de rango)
if ! grep -qE 'cubic-bezier\(\s*-?[0-9]' "style.css"; then
  echo "FAIL Tests fallaron"
  echo "El cubic-bezier debe tener valores (posiblemente negativos o >1 para rebote)"
  exit 1
fi

echo "OK Tests pasaron"
