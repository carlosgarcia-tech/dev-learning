#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"; systemctl --user stop demo 2>/dev/null || true' EXIT

cd "$TMP"
# Si no hay systemd de usuario disponible, los chequeos de estado se relajan.
HAS_USER_SYSTEMD=0
systemctl --user list-units >/dev/null 2>&1 && HAS_USER_SYSTEMD=1

bash "$HERE/solucion.sh"

fail=0
UNIT="$HOME/.config/systemd/user/demo.service"
[ -f "$UNIT" ] || { echo "FAIL: no se creó $UNIT"; fail=1; }
grep -q "ExecStart=/bin/sleep 600" "$UNIT" || { echo "FAIL: la unit no tiene ExecStart=/bin/sleep 600"; fail=1; }

if [ "$HAS_USER_SYSTEMD" -eq 1 ]; then
  [ -f estado_activo.txt ] || { echo "FAIL: falta estado_activo.txt"; fail=1; }
  [ -f estado_final.txt ] || { echo "FAIL: falta estado_final.txt"; fail=1; }
  final=$(cat estado_final.txt 2>/dev/null)
  [ "$final" = "inactive" ] || [ "$final" = "failed" ] || { echo "FAIL: estado_final.txt='$final', esperado inactive/failed"; fail=1; }
else
  echo "(info) systemd --user no disponible: se omite la verificación de estado activo/inactivo"
fi

# Limpieza
systemctl --user stop demo 2>/dev/null || true
rm -f "$UNIT"

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
