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
check_file "style.css"

check_css() {
  if ! grep -qi "$1" "style.css"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en style.css: $2"
    exit 1
  fi
}

check_css ":root" "variables en :root"
check_css "var(" "uso de var()"
check_css "font-family" "font-family"
check_css "font-size" "font-size"
check_css "line-height" "line-height"
check_css "font-weight" "font-weight"

# Variables específicas
check_css --fuente "variable --fuente"
check_css --tamano "variable --tamano"
check_css --line-height "variable --line-height"

echo "OK Tests pasaron"
