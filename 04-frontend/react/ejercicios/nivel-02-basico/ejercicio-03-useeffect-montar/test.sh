#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Mensaje.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Mensaje.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Mensaje.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'import.*useEffect.*from' "import useEffect"
check 'useEffect' "useEffect"
check 'console.log' "console.log"
check '\[\]' "array vacio"

echo "OK Tests pasaron"
