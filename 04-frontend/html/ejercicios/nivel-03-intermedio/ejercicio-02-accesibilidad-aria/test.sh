#!/usr/bin/env bash
set -euo pipefail

ARCHIVO="index.html"

if [[ ! -f "$ARCHIVO" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta el archivo $ARCHIVO"
  exit 1
fi

check_count() {
  local pat="$1" min="$2" name="$3"
  local n
  n=$(grep -o "$pat" "$ARCHIVO" | wc -l)
  if [[ "$n" -lt "$min" ]]; then
    echo "FAIL Tests fallaron"
    echo "$name: minimo $min, encontrados $n"
    exit 1
  fi
}

check_count 'aria-expanded' 2 "aria-expanded"
check_count 'aria-controls' 2 "aria-controls"
check_count 'role="region"' 2 'role region'
check_count 'aria-labelledby' 2 "aria-labelledby"
check_count 'hidden' 2 "hidden"

check() {
  if ! grep -qi "$1" "$ARCHIVO"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check "<button" "boton"
check "<script" "script"
check "addEventListener" "addEventListener"

echo "OK Tests pasaron"
