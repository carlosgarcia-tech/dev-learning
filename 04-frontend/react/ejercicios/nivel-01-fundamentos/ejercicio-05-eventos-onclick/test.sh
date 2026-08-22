#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Boton.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Boton.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Boton.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'function Boton\|const Boton' "componente Boton"
check 'onClick' "prop onClick"
check 'texto' "prop texto"
check '<button' "boton"
check 'export default' "export default"

echo "OK Tests pasaron"
