#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Padre.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Padre.jsx"; exit 1; }
check() { grep -qi "$1" "Padre.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'useCallback' "useCallback"
check 'useState' "useState"
check 'handleClick' "handleClick"
check 'export default' "export default"
echo "OK Tests pasaron"
