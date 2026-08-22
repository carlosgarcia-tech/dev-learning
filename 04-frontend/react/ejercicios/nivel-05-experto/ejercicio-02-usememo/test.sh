#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Lista.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Lista.jsx"; exit 1; }
check() { grep -qi "$1" "Lista.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'useMemo' "useMemo"
check 'useState' "useState"
check 'filter' "filter"
check 'items' "items"
check 'export default' "export default"
echo "OK Tests pasaron"
