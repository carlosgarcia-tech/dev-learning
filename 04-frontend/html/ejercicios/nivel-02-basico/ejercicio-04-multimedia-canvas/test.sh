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

check "<audio" "audio"
check "controls" "controls en audio/video"
check "<source" "source"
check "<video" "video"
check "poster=" "poster en video"
check "<canvas" "canvas"
check "width=" "width en canvas"
check "height=" "height en canvas"
check "<script" "script"
check "getContext" "getContext"
check "fillRect" "fillRect"

echo "OK Tests pasaron"
