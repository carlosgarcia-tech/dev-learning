#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Navbar.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Navbar.jsx"; exit 1; }
check() { grep -qi "$1" "Navbar.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check "import Link from 'next/link'\|import Link from \"next/link\"" "import Link"
check 'Link' "Link"
check 'href=' "href"
check 'export default' "export default"
echo "OK Tests pasaron"
