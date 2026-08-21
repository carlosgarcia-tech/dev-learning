#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Uso: solucion.sh <origen> <destino>"
  exit 1
fi

ORIGEN="$1"
DESTINO="$2"
KEEP_DAYS="${KEEP_DAYS:-7}"

mkdir -p "$DESTINO"
timestamp=$(date +%Y-%m-%d-%H%M%S)
archivo="$DESTINO/backup-$timestamp.tar.gz"

tar czf "$archivo" -C "$ORIGEN" .
tamano=$(stat -c %s "$archivo")
echo "[$(date '+%F %T')] Backup creado: $archivo (tamaño: $tamano bytes)" >> "$DESTINO/backup.log"

find "$DESTINO" -name "backup-*.tar.gz" -mtime "+$KEEP_DAYS" -delete
