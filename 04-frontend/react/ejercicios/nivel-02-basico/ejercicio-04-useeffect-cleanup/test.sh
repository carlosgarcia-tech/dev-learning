#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Reloj.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Reloj.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Reloj.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'useState' "useState"
check 'useEffect' "useEffect"
check 'setInterval' "setInterval"
check 'clearInterval' "clearInterval"
check 'return' "return cleanup"

echo "OK Tests pasaron"
