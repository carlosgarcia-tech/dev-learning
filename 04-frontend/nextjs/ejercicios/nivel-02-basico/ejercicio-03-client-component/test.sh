#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Contador.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Contador.jsx"; exit 1; }
check() { grep -qi "$1" "Contador.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check "'use client'" "use client"
check 'useState' "useState"
check 'export default' "export default"
echo "OK Tests pasaron"
