#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Navbar.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Navbar.jsx"; exit 1; }
check() { grep -qi "$1" "Navbar.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'Link' "Link"
check 'NavLink' "NavLink"
check 'to=' "to="
check 'export default' "export default"
echo "OK Tests pasaron"
