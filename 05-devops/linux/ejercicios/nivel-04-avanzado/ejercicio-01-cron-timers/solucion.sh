#!/usr/bin/env bash
set -euo pipefail

echo "30 2 * * * /usr/local/bin/backup.sh" > tarea.cron
echo "0 3 * * 0 /usr/local/bin/limpiar.sh" > limpieza.cron

cat > backup.timer <<'EOF'
[Unit]
Description=Backup diario

[Timer]
OnCalendar=*-*-* 02:30:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat > backup.service <<'EOF'
[Unit]
Description=Backup diario

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
EOF
