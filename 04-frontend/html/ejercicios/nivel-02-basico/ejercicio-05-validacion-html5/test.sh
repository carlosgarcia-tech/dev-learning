#!/usr/bin/env bash
set -euo pipefail

ARCHIVO="index.html"

if [[ ! -f "$ARCHIVO" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta el archivo $ARCHIVO"
  exit 1
fi

check() {
  if ! grep -qi "$1" "$ARCHIVO"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check "required" "required"
check 'type="email"' "input email"
check "minlength" "minlength"
check 'type="number"' "input number"
check "min=" "min"
check "max=" "max"
check "pattern=" "pattern"
check '<button type="submit"' "boton submit"

echo "OK Tests pasaron"
