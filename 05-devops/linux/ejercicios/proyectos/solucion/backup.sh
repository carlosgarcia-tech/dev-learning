#!/usr/bin/env bash
# backup.sh — Script de backup con compresión y rotación (solución de referencia)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${MON_CONF:-$SCRIPT_DIR/../config/mon.conf}"

if [ -f "$CONF" ]; then
  # shellcheck disable=SC1090
  source "$CONF"
fi

ORIGEN="${1:-${BACKUP_ORIGEN:-/etc}}"
DESTINO="${2:-${BACKUP_DESTINO:-/tmp/backups}}"
KEEP_DAYS="${KEEP_DAYS:-7}"

mkdir -p "$DESTINO"
timestamp=$(date +%Y-%m-%d-%H%M%S)
archivo="$DESTINO/backup-$timestamp.tar.gz"

tar czf "$archivo" -C "$ORIGEN" . 2>/dev/null || tar czf "$archivo" "$ORIGEN" 2>/dev/null
tamano=$(stat -c %s "$archivo")
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "$ts script=backup status=OK archivo=$archivo tamano=$tamano" >> "$DESTINO/backup.log"

find "$DESTINO" -name "backup-*.tar.gz" -mtime "+$KEEP_DAYS" -delete 2>/dev/null || true

echo "Backup creado: $archivo ($tamano bytes)"
