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
check_file "Boton.module.css"

check_css() {
  if ! grep -qi "$1" "Boton.module.css"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en Boton.module.css: $2"
    exit 1
  fi
}

check_css 'background' 'background'
check_css 'padding' 'padding'
check_css 'border-radius' 'border-radius'

CLASS_COUNT=$(grep -c '^\.' "Boton.module.css")
if [[ "$CLASS_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas al menos 2 clases en Boton.module.css, encontradas: $CLASS_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
