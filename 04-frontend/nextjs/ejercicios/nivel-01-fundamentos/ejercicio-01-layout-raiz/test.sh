#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "layout.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta layout.jsx"; exit 1; }
check() { grep -qi "$1" "layout.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'metadata' "metadata"
check 'title' "title"
check 'description' "description"
check 'RootLayout' "RootLayout"
check 'html' "html"
check 'lang="es"' "lang es"
check 'children' "children"
check 'export default' "export default"
echo "OK Tests pasaron"
