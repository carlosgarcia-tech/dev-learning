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

check_css "box-sizing" "box-sizing"
check_css "border-box" "border-box"
check_css "content-box" "content-box"
check_css "width" "width"
check_css "padding" "padding"
check_css "border" "border"
check_css "margin" "margin"

# Reset universal
if ! grep -q '\*' "style.css"; then
  echo "FAIL Tests fallaron"
  echo "Falta reset universal (*)"
  exit 1
fi

echo "OK Tests pasaron"
