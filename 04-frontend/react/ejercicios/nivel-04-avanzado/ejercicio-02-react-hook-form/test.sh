#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Formulario.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Formulario.jsx"; exit 1; }
check() { grep -qi "$1" "Formulario.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'useForm' "useForm"
check 'register' "register"
check 'handleSubmit' "handleSubmit"
check 'errors' "errors"
check 'required' "required"
check 'export default' "export default"
echo "OK Tests pasaron"
