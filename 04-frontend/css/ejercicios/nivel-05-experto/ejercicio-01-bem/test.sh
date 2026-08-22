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

check_both() {
  if ! grep -qi "$1" "index.html" || ! grep -qi "$1" "style.css"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en ambos archivos: $2"
    exit 1
  fi
}

check_both 'tarjeta' 'bloque tarjeta'
check_both 'tarjeta__titulo' 'elemento tarjeta__titulo'
check_both 'tarjeta__boton' 'elemento tarjeta__boton'
check_both 'tarjeta--destacada\|tarjeta__boton--primario' 'modificador BEM'

echo "OK Tests pasaron"
