#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Hero.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Hero.jsx"; exit 1; }
check() { grep -qi "$1" "Hero.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check "import Image from 'next/image'\|import Image from \"next/image\"" "import Image"
check '<Image' "Image component"
check 'width' "width"
check 'height' "height"
check 'priority' "priority"
check 'export default' "export default"
echo "OK Tests pasaron"
