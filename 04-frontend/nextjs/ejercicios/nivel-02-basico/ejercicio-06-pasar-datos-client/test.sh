#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "page.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta page.jsx"; exit 1; }
[[ ! -f "Lista.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Lista.jsx"; exit 1; }
check_page() { grep -qi "$1" "page.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro en page.jsx: $2"; exit 1; }; }
check_lista() { grep -qi "$1" "Lista.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro en Lista.jsx: $2"; exit 1; }; }
check_page 'async' "async en page"
check_page 'fetch' "fetch en page"
check_page 'items' "items como props"
check_lista "'use client'" "use client en Lista"
check_lista 'useState' "useState en Lista"
check_lista 'items' "prop items"
echo "OK Tests pasaron"
