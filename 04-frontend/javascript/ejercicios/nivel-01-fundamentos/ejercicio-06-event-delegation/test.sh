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

check_html 'id="lista"' "ul con id lista"
check_html 'class="eliminar"' "botones eliminar"
check_html 'defer' "defer"

LI_COUNT=$(grep -o '<li' "index.html" | wc -l)
if [[ "$LI_COUNT" -lt 3 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas 3 li, encontrados: $LI_COUNT"
  exit 1
fi

check_js 'addEventListener' "addEventListener en lista"
check_js 'matches\|closest' "matches o closest"

echo "OK Tests pasaron"
