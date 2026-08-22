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
check_file "script.js"

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_js() {
  if ! grep -qi "$1" "script.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en script.js: $2"
    exit 1
  fi
}

check_html 'src="script.js"' "enlace al script"
check_html 'defer' "atributo defer"
check_html 'id="titulo"' "h1 con id titulo"
check_html 'class="texto"' "parrafos con clase texto"

check_js 'querySelector' "querySelector"
check_js 'querySelectorAll' "querySelectorAll"
check_js 'console.log' "console.log"

echo "OK Tests pasaron"
