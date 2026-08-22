#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f "Saludo.jsx" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta Saludo.jsx"
  exit 1
fi

check() {
  if ! grep -qi "$1" "Saludo.jsx"; then
    echo "FAIL Tests fallaron"
    echo "No se encontro: $2"
    exit 1
  fi
}

check 'function Saludo\|const Saludo' "componente Saludo"
check 'nombre' "prop nombre"
check "mundo" "valor por defecto mundo"
check 'export default' "export default"

# Debe haber un valor por defecto (= 'mundo' o = "mundo")
if ! grep -qiE "nombre\s*=\s*['\"]mundo['\"]" "Saludo.jsx"; then
  echo "FAIL Tests fallaron"
  echo "Falta el valor por defecto: nombre = 'mundo'"
  exit 1
fi

echo "OK Tests pasaron"
