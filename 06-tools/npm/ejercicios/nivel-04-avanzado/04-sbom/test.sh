#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
if [ -f "$DIR/sbom.json" ] || [ -f "$DIR/respuesta.txt" ]; then
  echo "OK"
else
  echo "Falta sbom.json o respuesta.txt"; exit 1
fi
