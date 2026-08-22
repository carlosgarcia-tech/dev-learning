#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Contador.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Contador.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Contador.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'import.*useState.*from' "import useState"
check 'useState' "useState"
check 'setCuenta\|setCount' "setter"
check 'onClick' "onClick"
check 'export default' "export default"

echo "OK Tests pasaron"
