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

check_count "<img" 3 "imagenes img"

# alt vacio (decorativa)
if ! grep -q 'alt=""' "$ARCHIVO"; then
  echo "FAIL Tests fallaron"
  echo "Falta una imagen decorativa con alt vacio (alt=\"\")"
  exit 1
fi

# loading lazy
if ! grep -qi 'loading="lazy"' "$ARCHIVO"; then
  echo "FAIL Tests fallaron"
  echo "Falta loading=\"lazy\""
  exit 1
fi

# width y height
if ! grep -qi 'width=' "$ARCHIVO" || ! grep -qi 'height=' "$ARCHIVO"; then
  echo "FAIL Tests fallaron"
  echo "Falta width o height"
  exit 1
fi

# alt descriptivo (no vacio, no la palabra imagen)
DESC=$(grep -o 'alt="[^"]*"' "$ARCHIVO" | grep -v 'alt=""' | head -1)
if [[ -z "$DESC" ]]; then
  echo "FAIL Tests fallaron"
  echo "Falta alt descriptivo"
  exit 1
fi

if echo "$DESC" | grep -qi 'imagen'; then
  echo "FAIL Tests fallaron"
  echo "El alt no debe contener la palabra 'imagen'"
  exit 1
fi

echo "OK Tests pasaron"
