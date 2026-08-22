#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Buscador.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Buscador.jsx"; exit 1; }
check() { grep -qi "$1" "Buscador.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'useTransition' "useTransition"
check 'startTransition' "startTransition"
check 'isPending' "isPending"
check 'useState' "useState"
check 'export default' "export default"
echo "OK Tests pasaron"
