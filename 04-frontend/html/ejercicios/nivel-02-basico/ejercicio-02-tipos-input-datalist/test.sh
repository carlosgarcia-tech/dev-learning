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

check 'type="text"' "input text"
check 'type="email"' "input email"
check 'type="number"' "input number"
check 'type="date"' "input date"
check 'type="color"' "input color"
check 'type="range"' "input range"
check '<datalist' "datalist"
check 'list=' "input con list"

OPTS=$(grep -o '<option' "$ARCHIVO" | wc -l)
if [[ "$OPTS" -lt 3 ]]; then
  echo "FAIL Tests fallaron"
  echo "datalist necesita al menos 3 option, encontrados: $OPTS"
  exit 1
fi

echo "OK Tests pasaron"
