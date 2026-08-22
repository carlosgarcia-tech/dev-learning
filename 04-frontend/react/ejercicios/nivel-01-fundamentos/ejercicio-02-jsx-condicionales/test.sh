#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Saludo.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Saludo.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Saludo.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'function Saludo\|const Saludo' "componente Saludo"
check 'nombre' "prop nombre"
check 'logueado' "prop logueado"
check '?' "operador ternario"
check 'export default' "export default"

echo "OK Tests pasaron"
