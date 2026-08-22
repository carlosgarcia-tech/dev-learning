#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "App.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta App.jsx"; exit 1; }
check() { grep -qi "$1" "App.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'createBrowserRouter' "createBrowserRouter"
check 'RouterProvider' "RouterProvider"
check "path: '/'" "ruta /"
check "path: '/about'\|path: \"about\"" "ruta /about"
check 'export default' "export default"
echo "OK Tests pasaron"
