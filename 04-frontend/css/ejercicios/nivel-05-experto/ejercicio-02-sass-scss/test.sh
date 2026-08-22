#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "style.scss" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta style.scss"
  exit 1
fi

check_scss() {
  if ! grep -qi "$1" "style.scss"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro en style.scss: $2"
    exit 1
  fi
}

check_scss '\$' 'variable scss'
check_scss '&__' 'anidamiento con & (BEM)'
check_scss '&:hover' 'anidamiento con &:hover'
check_scss '\.tarjeta' 'selector .tarjeta'

# Al menos 2 variables
VAR_COUNT=$(grep -o '\$[a-zA-Z]' "style.scss" | wc -l)
if [[ "$VAR_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas al menos 2 variables \$, encontradas: $VAR_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
