#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Uso: solucion.sh <nota>"
  exit 2
fi

nota="$1"
if ! [[ "$nota" =~ ^[0-9]+$ ]]; then
  echo "Error: nota invalida"
  exit 1
fi

if [ "$nota" -ge 90 ] && [ "$nota" -le 100 ]; then
  echo "Excelente"
elif [ "$nota" -ge 60 ] && [ "$nota" -le 89 ]; then
  echo "Aprobado"
elif [ "$nota" -ge 0 ] && [ "$nota" -le 59 ]; then
  echo "Reprobado"
else
  echo "Error: nota invalida"
  exit 1
fi
