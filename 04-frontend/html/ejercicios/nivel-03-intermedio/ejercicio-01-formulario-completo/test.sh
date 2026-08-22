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

check 'method="POST"' "method POST"
check "<fieldset" "fieldset"

LEGEND_COUNT=$(grep -o "<legend" "$ARCHIVO" | wc -l)
if [[ "$LEGEND_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Necesitas 2 legend, encontrados: $LEGEND_COUNT"
  exit 1
fi

check 'autocomplete="name"' "autocomplete name"
check 'autocomplete="email"' "autocomplete email"
check 'autocomplete="postal-code"' "autocomplete postal-code"
check "pattern=" "pattern"
check 'type="number"' "input number"
check "min=" "min"
check "max=" "max"
check "required" "required"

echo "OK Tests pasaron"
