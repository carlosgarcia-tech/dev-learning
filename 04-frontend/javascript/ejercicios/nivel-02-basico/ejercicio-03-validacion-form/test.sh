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

check_html 'name="nombre"' "input nombre"
check_html 'name="email"' "input email"
check_html 'id="error"' "div error"
check_html 'defer' "defer"

check_js 'preventDefault' "preventDefault"
check_js 'length' "length"
check_js 'test' "regex test"
check_js '@' "regex email"

echo "OK Tests pasaron"
