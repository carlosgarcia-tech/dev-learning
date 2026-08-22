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

check_js() {
  if ! grep -qi "$1" "script.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en script.js: $2"
    exit 1
  fi
}

check_js 'AbortController' "AbortController"
check_js 'signal' "signal"
check_js 'abort' "abort"
check_js 'AbortError' "AbortError"
check_js 'catch' "catch"

echo "OK Tests pasaron"
