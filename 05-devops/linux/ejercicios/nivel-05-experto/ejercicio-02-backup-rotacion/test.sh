#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Crear datos de origen
mkdir -p "$TMP/origen"
printf 'datos importantes\n' > "$TMP/origen/datos.txt"
printf 'config\n'         > "$TMP/origen/config.conf"
mkdir -p "$TMP/origen/sub"
printf 'subarchivo\n'     > "$TMP/origen/sub/x.txt"

# Crear un backup viejo (>7 días) que debería eliminarse
mkdir -p "$TMP/backups"
touch -d "10 days ago" "$TMP/backups/backup-2024-01-01-000000.tar.gz"
tar czf "$TMP/backups/backup-2024-01-01-000000.tar.gz" -C "$TMP/origen" .
touch -d "10 days ago" "$TMP/backups/backup-2024-01-01-000000.tar.gz"
# Crear un archivo no-backup que NO debe eliminarse
echo "log viejo" > "$TMP/backups/backup.log"

cd "$TMP"
# KEEP_DAYS=7 para que el de 10 días se elimine
KEEP_DAYS=7 bash "$HERE/solucion.sh" origen backups

fail=0
# Debe existir un backup nuevo
nuevos=$(find backups -name "backup-*.tar.gz" -newer backups/backup.log 2>/dev/null | wc -l)
[ "$nuevos" -ge 1 ] || { echo "FAIL: no se creó un backup nuevo"; fail=1; }

# El backup viejo (>7 días) debe haberse eliminado
[ ! -f "backups/backup-2024-01-01-000000.tar.gz" ] || { echo "FAIL: el backup viejo no se eliminó"; fail=1; }

# El log NO debe eliminarse
[ -f "backups/backup.log" ] || { echo "FAIL: backup.log fue eliminado"; fail=1; }

# El log debe contener el nombre del backup creado
grep -q "Backup creado" "backups/backup.log" || { echo "FAIL: backup.log no registra el backup"; fail=1; }

# El backup nuevo debe contener datos.txt
backup_creado=$(find backups -name "backup-*.tar.gz" -newer backups/backup.log | head -1)
if [ -n "$backup_creado" ]; then
  tar tzf "$backup_creado" | grep -q "datos.txt" || { echo "FAIL: el backup no contiene datos.txt"; fail=1; }
  tar tzf "$backup_creado" | grep -q "sub/x.txt" || { echo "FAIL: el backup no contiene sub/x.txt"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
