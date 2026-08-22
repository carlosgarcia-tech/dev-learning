#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "error.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta error.jsx"; exit 1; }
check() { grep -qi "$1" "error.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check "'use client'" "use client"
check 'error' "prop error"
check 'reset' "prop reset"
check 'onClick' "onClick reset"
check 'export default' "export default"
echo "OK Tests pasaron"
