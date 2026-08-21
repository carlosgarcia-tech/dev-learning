#!/usr/bin/env bash
set -uo pipefail

cat > "$HOME/app.sh" <<'EOF'
#!/usr/bin/env bash
mkdir -p ~/.local/share/demo-app
while true; do
  date >> ~/.local/share/demo-app/salida.log
  sleep 1
done
EOF
chmod +x "$HOME/app.sh"

UNIT_DIR="$HOME/.config/systemd/user"
mkdir -p "$UNIT_DIR"
cat > "$UNIT_DIR/demo-app.service" <<'EOF'
[Unit]
Description=App de demostracion (escribe hora)

[Service]
Type=simple
ExecStart=%h/app.sh
Restart=on-failure
RestartSec=2s

[Install]
WantedBy=default.target
EOF

if systemctl --user list-units >/dev/null 2>&1; then
  systemctl --user daemon-reload 2>/dev/null || true
  systemctl --user start demo-app 2>/dev/null || true
  sleep 2
  systemctl --user is-active demo-app 2>/dev/null > estado.txt || echo "inactive" > estado.txt
  systemctl --user stop demo-app 2>/dev/null || true
else
  echo "inactive" > estado.txt
fi
