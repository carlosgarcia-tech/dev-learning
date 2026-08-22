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

check_file "package.json"
check_file "index.html"
check_file "vite.config.js"
check_file "src/main.js"

check_pkg() {
  if ! grep -qi "$1" "package.json"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en package.json: $2"
    exit 1
  fi
}

check_pkg 'vite' "vite en dependencies"
check_pkg '"dev"' "script dev"
check_pkg '"build"' "script build"

check_html() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en index.html: $2"
    exit 1
  fi
}

check_html 'type="module"' "type module"
check_html '/src/main.js' "src main.js"

check_config() {
  if ! grep -qi "$1" "vite.config.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en vite.config.js: $2"
    exit 1
  fi
}

check_config 'defineConfig' "defineConfig"
check_config 'export default' "export default"

echo "OK Tests pasaron"
