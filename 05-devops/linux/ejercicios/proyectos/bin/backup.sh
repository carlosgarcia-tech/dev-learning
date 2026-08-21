#!/usr/bin/env bash
# backup.sh — Script de backup con compresión y rotación
# Uso: ./backup.sh [origen] [destino]
set -euo pipefail

# TODO: leer argumentos ORIGEN y DESTINO (o usar config/mon.conf por defecto)

# TODO: crear DESTINO si no existe

# TODO: crear backup-<timestamp>.tar.gz con tar czf

# TODO: registrar la operación en DESTINO/backup.log
# Formato: [timestamp] Backup creado: <archivo> (tamaño: N bytes)

# TODO: eliminar backups con más de KEEP_DAYS días
# find "$DESTINO" -name "backup-*.tar.gz" -mtime +$KEEP_DAYS -delete
# (no eliminar backup.log ni otros archivos)

echo "(starter) backup.sh no implementado todavía"
