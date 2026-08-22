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
check_file "index.js"
check_file "math.js"
check_file "string.js"

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_html 'type="module"' "type module"

check_barrel() {
  if ! grep -qi "$1" "index.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.js: $2"
    exit 1
  fi
}

check_barrel "export.*from './math.js'" "re-export de math.js"
check_barrel "export.*from './string.js'" "re-export de string.js"

check_main() {
  if ! grep -qi "$1" "main.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en main.js: $2"
    exit 1
  fi
}

check_main "from './index.js'" "import desde index.js"

echo "OK Tests pasaron"
