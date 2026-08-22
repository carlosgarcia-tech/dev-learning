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

check_css 'clamp' 'funcion clamp'

CLAMP_COUNT=$(grep -o 'clamp' "style.css" | wc -l)
if [[ "$CLAMP_COUNT" -lt 3 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas 3 clamp (h1, h2, p), encontrados: $CLAMP_COUNT"
  exit 1
fi

check_css 'vw' 'unidad vw en clamp'

echo "OK Tests pasaron"
