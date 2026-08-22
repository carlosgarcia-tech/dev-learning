#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "useLocalStorage.js" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta useLocalStorage.js"
  exit 1
fi

check() {
  if ! grep -qi "$1" "useLocalStorage.js"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'useState' "useState"
check 'useEffect' "useEffect"
check 'localStorage' "localStorage"
check 'getItem' "getItem"
check 'setItem' "setItem"
check 'JSON.parse' "JSON.parse"
check 'JSON.stringify' "JSON.stringify"
check 'export' "export"
check 'return' "return"

echo "OK Tests pasaron"
