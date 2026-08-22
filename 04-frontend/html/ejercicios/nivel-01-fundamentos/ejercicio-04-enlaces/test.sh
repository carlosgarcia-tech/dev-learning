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

check_count "<a " 4 "enlaces a"
check_count "https://" 2 "enlace absoluto https"
check_count "contacto.html" 1 "enlace relativo"
check_count 'target="_blank"' 1 'target blank'
check_count 'rel="noopener' 1 'rel noopener'
check_count '#seccion' 1 'ancla seccion'
check_count 'id="seccion"' 1 'destino del ancla'

echo "OK Tests pasaron"
