#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "index.html" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta index.html"
  exit 1
fi

check() {
  if ! grep -qi "$1" "index.html"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check '<style>' 'style inline (critical CSS)'
check 'body' 'body en critical CSS'
check 'media="print"' 'media print'
check "onload" 'onload para cargar sin bloquear'
check '<noscript>' 'noscript fallback'
check '<link' 'link al CSS'

echo "OK Tests pasaron"
