#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Tarjeta.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Tarjeta.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Tarjeta.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'function Tarjeta\|const Tarjeta' "componente Tarjeta"
check 'titulo' "prop titulo"
check 'descripcion' "prop descripcion"
check 'className' "className"
check '<h2' "h2"
check '<p' "parrafo p"
check 'export default' "export default"

echo "OK Tests pasaron"
