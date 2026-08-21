#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"; systemctl --user stop demo-app 2>/dev/null || true; rm -f "$HOME/app.sh" "$HOME/.config/systemd/user/demo-app.service"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -x "$HOME/app.sh" ] || { echo "FAIL: app.sh no existe o no es ejecutable"; fail=1; }
grep -q "while true" "$HOME/app.sh" || { echo "FAIL: app.sh no contiene bucle while true"; fail=1; }
grep -q "sleep 1" "$HOME/app.sh" || { echo "FAIL: app.sh no contiene sleep 1"; fail=1; }

UNIT="$HOME/.config/systemd/user/demo-app.service"
[ -f "$UNIT" ] || { echo "FAIL: no se creó $UNIT"; fail=1; }
grep -q "Type=simple" "$UNIT" || { echo "FAIL: la unit no tiene Type=simple"; fail=1; }
grep -q "Restart=on-failure" "$UNIT" || { echo "FAIL: la unit no tiene Restart=on-failure"; fail=1; }
grep -q "WantedBy=default.target" "$UNIT" || { echo "FAIL: la unit no tiene WantedBy=default.target"; fail=1; }
grep -q "ExecStart=%h/app.sh" "$UNIT" || { echo "FAIL: la unit no tiene ExecStart=%h/app.sh"; fail=1; }

[ -f "estado.txt" ] || { echo "FAIL: no se creó estado.txt"; fail=1; }

# Si systemd --user está disponible, el servicio debería haber llegado a estar activo y escrito en el log
if systemctl --user list-units >/dev/null 2>&1; then
  [ "$(cat estado.txt)" = "active" ] || { echo "FAIL: estado.txt=$(cat estado.txt), esperado active"; fail=1; }
  [ -f "$HOME/.local/share/demo-app/salida.log" ] || { echo "FAIL: el servicio no escribió salida.log"; fail=1; }
else
  echo "(info) systemd --user no disponible: se omite verificación de estado activo"
fi

# Limpieza
systemctl --user stop demo-app 2>/dev/null || true
rm -f "$HOME/app.sh" "$HOME/.config/systemd/user/demo-app.service"
rm -rf "$HOME/.local/share/demo-app"

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
