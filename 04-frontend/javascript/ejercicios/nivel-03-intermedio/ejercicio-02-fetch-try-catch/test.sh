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

check_html 'id="loader"' "div loader"
check_html 'id="error"' "div error"
check_html 'defer' "defer"

check_js 'fetch' "fetch"
check_js 'try' "try"
check_js 'catch' "catch"
check_js 'res.ok\|!res.ok' "res.ok"
check_js 'throw' "throw"
check_js 'finally' "finally"

echo "OK Tests pasaron"
