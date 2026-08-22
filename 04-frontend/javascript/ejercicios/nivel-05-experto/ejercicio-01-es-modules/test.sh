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
check_file "main.js"
check_file "math.js"

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_html 'type="module"' "type module"
check_html 'main.js' "src main.js"

check_main() {
  if ! grep -qi "$1" "main.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en main.js: $2"
    exit 1
  fi
}

check_main 'import' "import"
check_main "from './math.js'\|from \"./math.js\"" "import from math.js"
check_main 'sumar' "funcion sumar"

check_math() {
  if ! grep -qi "$1" "math.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en math.js: $2"
    exit 1
  fi
}

check_math 'export' "export"
check_math 'sumar' "funcion sumar"

echo "OK Tests pasaron"
