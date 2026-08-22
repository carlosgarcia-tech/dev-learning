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
check_file "utils.js"

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_html 'type="module"' "type module"

check_main() {
  if ! grep -qi "$1" "main.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en main.js: $2"
    exit 1
  fi
}

check_main 'import \* as' "import * as"
check_main 'utils' "namespace utils"

check_utils() {
  if ! grep -qi "$1" "utils.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en utils.js: $2"
    exit 1
  fi
}

EXPORT_COUNT=$(grep -c 'export' "utils.js")
if [[ "$EXPORT_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "utils.js necesita al menos 2 exports, encontrados: $EXPORT_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
