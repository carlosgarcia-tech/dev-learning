#!/usr/bin/env bash
set -uo pipefail

UNIT_DIR="$HOME/.config/systemd/user"
mkdir -p "$UNIT_DIR"

cat > "$UNIT_DIR/demo.service" <<'EOF'
[Unit]
Description=Servicio de demostracion

[Service]
Type=simple
ExecStart=/bin/sleep 600

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload 2>/dev/null || true
systemctl --user start demo 2>/dev/null || true
systemctl --user is-active demo 2>/dev/null > estado_activo.txt || true
systemctl --user is-enabled demo 2>/dev/null > estado_habilitado.txt || true
systemctl --user stop demo 2>/dev/null || true
systemctl --user is-active demo 2>/dev/null > estado_final.txt || true
