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

check 'useState' "useState"
check 'nombre' "campo nombre"
check 'email' "campo email"
check 'onChange' "onChange"
check '\.\.\.' "spread operator"
check 'export default' "export default"

echo "OK Tests pasaron"
