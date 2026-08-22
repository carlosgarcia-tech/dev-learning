#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "layout.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta layout.jsx"; exit 1; }
check() { grep -qi "$1" "layout.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'next/font' "import next/font"
check 'subsets' "subsets"
check 'variable' "variable"
check 'className' "className con font variable"
check 'export default' "export default"
echo "OK Tests pasaron"
