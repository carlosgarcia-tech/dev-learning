#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Login.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Login.jsx"; exit 1; }
check() { grep -qi "$1" "Login.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'useNavigate' "useNavigate"
check 'navigate' "navigate"
check 'dashboard' "navigate a dashboard"
check 'export default' "export default"
echo "OK Tests pasaron"
