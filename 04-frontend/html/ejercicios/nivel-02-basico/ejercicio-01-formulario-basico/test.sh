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

check '<form' "form"
check 'method="POST"' "method POST"
check 'action=' "action"
check 'type="text"' "input text"
check 'type="email"' "input email"
check 'type="password"' "input password"
check '<button type="submit"' "boton submit"

# 3 labels con for asociados
LABELS=$(grep -o '<label for=' "$ARCHIVO" | wc -l)
if [[ "$LABELS" -lt 3 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan labels con for, encontrados: $LABELS"
  exit 1
fi

# 3 required
REQ=$(grep -o 'required' "$ARCHIVO" | wc -l)
if [[ "$REQ" -lt 3 ]]; then
  echo "FAIL Tests fallaron"
  echo "Faltan campos required, encontrados: $REQ"
  exit 1
fi

echo "OK Tests pasaron"
