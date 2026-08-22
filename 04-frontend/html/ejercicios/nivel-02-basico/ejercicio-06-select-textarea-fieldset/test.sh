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

check "<fieldset" "fieldset"
check "<legend" "legend"
check "<select" "select"
check "<optgroup" "optgroup"
check "<textarea" "textarea"
check "rows=" "rows en textarea"
check "maxlength=" "maxlength"

RADIO_COUNT=$(grep -o 'type="radio"' "$ARCHIVO" | wc -l)
if [[ "$RADIO_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan radios, minimo 2, encontrados: $RADIO_COUNT"
  exit 1
fi

CHECK_COUNT=$(grep -o 'type="checkbox"' "$ARCHIVO" | wc -l)
if [[ "$CHECK_COUNT" -lt 2 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan checkboxes, minimo 2, encontrados: $CHECK_COUNT"
  exit 1
fi

echo "OK Tests pasaron"
