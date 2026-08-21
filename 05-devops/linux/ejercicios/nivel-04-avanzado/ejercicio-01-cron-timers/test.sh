#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
grep -qx '30 2 \* \* \* /usr/local/bin/backup.sh' tarea.cron || { echo "FAIL: tarea.cron incorrecto -> $(cat tarea.cron)"; fail=1; }
grep -qx '0 3 \* \* 0 /usr/local/bin/limpiar.sh' limpieza.cron || { echo "FAIL: limpieza.cron incorrecto -> $(cat limpieza.cron)"; fail=1; }
grep -q 'OnCalendar=\*-\*- 02:30:00\|OnCalendar=\*-\*-\* 02:30:00' backup.timer || { echo "FAIL: backup.timer sin OnCalendar"; fail=1; }
grep -q 'Persistent=true' backup.timer || { echo "FAIL: backup.timer sin Persistent=true"; fail=1; }
grep -q 'ExecStart=/usr/local/bin/backup.sh' backup.service || { echo "FAIL: backup.service sin ExecStart"; fail=1; }
grep -q 'Type=oneshot' backup.service || { echo "FAIL: backup.service sin Type=oneshot"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
