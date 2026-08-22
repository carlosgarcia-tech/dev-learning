#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ ! -f "Formulario.jsx" ]] && { echo "FAIL Tests fallaron"; echo "Falta Formulario.jsx"; exit 1; }
check() { grep -qi "$1" "Formulario.jsx" || { echo "FAIL Tests fallaron"; echo "No se encontro: $2"; exit 1; }; }
check 'zodResolver' "zodResolver"
check 'z.object\|z\.object' "schema zod"
check 'resolver' "resolver en useForm"
check 'min' "validacion min"
check 'email' "validacion email"
check 'export default' "export default"
echo "OK Tests pasaron"
