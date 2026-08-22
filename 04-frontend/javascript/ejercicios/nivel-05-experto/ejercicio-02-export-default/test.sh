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
check_file "logger.js"

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_html 'type="module"' "type module"

check_logger() {
  if ! grep -qi "$1" "logger.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en logger.js: $2"
    exit 1
  fi
}

check_logger 'export default' "export default"

check_main() {
  if ! grep -qi "$1" "main.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en main.js: $2"
    exit 1
  fi
}

check_main 'import logger' "import logger (sin llaves)"
check_main "from './logger.js'\|from \"./logger.js\"" "from logger.js"

echo "OK Tests pasaron"
