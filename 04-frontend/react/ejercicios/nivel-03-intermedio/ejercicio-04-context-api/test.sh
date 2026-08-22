#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "TemaContext.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta TemaContext.jsx"; exit 1; }
check() { grep -qi "$1" "TemaContext.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'createContext' "createContext"
check 'Provider' "Provider"
check 'useState' "useState"
check 'useContext' "useContext"
check 'useTema' "hook useTema"
check 'export' "export"
echo "OK Tests pasaron"
