#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Tarjeta.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Tarjeta.jsx"; exit 1; }
check() { grep -qi "$1" "Tarjeta.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'memo' "React.memo o memo"
check 'titulo' "prop titulo"
check 'onClick' "prop onClick"
check 'export default' "export default"
echo "OK Tests pasaron"
