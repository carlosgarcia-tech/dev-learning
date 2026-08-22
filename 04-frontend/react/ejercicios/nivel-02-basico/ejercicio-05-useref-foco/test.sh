#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Formulario.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Formulario.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Formulario.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'useRef' "useRef"
check 'inputRef' "inputRef"
check 'useEffect' "useEffect"
check 'focus' "focus"
check 'ref=' "ref en input"

echo "OK Tests pasaron"
