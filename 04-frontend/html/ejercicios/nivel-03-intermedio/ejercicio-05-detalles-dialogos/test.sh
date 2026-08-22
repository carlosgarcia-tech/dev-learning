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

check_count "<details" 2 "details"
check_count "<summary" 2 "summary"

check() {
  if ! grep -qi "$1" "$ARCHIVO"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check "<dialog" "dialog"
check "showModal" "showModal"
check "close()" "close"

echo "OK Tests pasaron"
