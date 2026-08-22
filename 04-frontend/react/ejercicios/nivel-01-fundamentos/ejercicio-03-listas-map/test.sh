#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "ListaTareas.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta ListaTareas.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "ListaTareas.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'function ListaTareas\|const ListaTareas' "componente ListaTareas"
check 'tareas' "prop tareas"
check '.map' "map"
check 'key=' "key"
check '<li' "li"
check 'export default' "export default"

echo "OK Tests pasaron"
