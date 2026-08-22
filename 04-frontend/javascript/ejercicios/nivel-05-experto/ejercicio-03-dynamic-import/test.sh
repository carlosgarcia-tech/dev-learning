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
check_file "editor.js"

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_html 'type="module"' "type module"
check_html 'id="btn"' "boton"

check_main() {
  if ! grep -qi "$1" "main.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en main.js: $2"
    exit 1
  fi
}

check_main 'import(' "dynamic import"
check_main 'await' "await"
check_main 'editor.js' "import editor.js"

check_editor() {
  if ! grep -qi "$1" "editor.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en editor.js: $2"
    exit 1
  fi
}

check_editor 'export default' "export default en editor.js"

echo "OK Tests pasaron"
