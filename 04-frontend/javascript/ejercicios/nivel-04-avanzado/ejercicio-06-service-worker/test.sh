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
check_file "sw.js"

check_js() {
  if ! grep -qi "$1" "script.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en script.js: $2"
    exit 1
  fi
}

check_sw() {
  if ! grep -qi "$1" "sw.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en sw.js: $2"
    exit 1
  fi
}

check_js 'serviceWorker' "serviceWorker"
check_js 'register' "register"

check_sw 'install' "evento install"
check_sw 'fetch' "evento fetch"

echo "OK Tests pasaron"
