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

check_css 'rgb(' "color rgb"
check_css 'rgba(' "color rgba"
check_css 'hsl(' "color hsl"
check_css '#[0-9a-fA-F]\{6\}' "color hex"

# hex con alpha (8 digitos)
if ! grep -qiE '#[0-9a-fA-F]{8}' "style.css"; then
  echo "FAIL Tests fallaron"
  echo "Falta color hex con alpha (8 digitos)"
  exit 1
fi

echo "OK Tests pasaron"
