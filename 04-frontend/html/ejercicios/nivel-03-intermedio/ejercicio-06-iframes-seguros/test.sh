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

check_count "<iframe" 2 "iframes"
check_count 'title=' 2 "title en iframes"
check_count 'loading="lazy"' 1 'loading lazy'
check_count 'sandbox' 1 'sandbox'
check_count 'width=' 1 'width'
check_count 'height=' 1 'height'

echo "OK Tests pasaron"
