#!/usr/bin/env bash
set -euo pipefail

cat > reglas.sh <<'EOF'
#!/usr/bin/env bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow from 192.168.1.0/24 to any port 5432
ufw deny 3306
ufw enable
EOF
chmod +x reglas.sh

if command -v ufw >/dev/null 2>&1; then
  sudo ufw status verbose > resumen.txt 2>/dev/null || ufw status verbose > resumen.txt 2>/dev/null || echo "ufw no disponible" > resumen.txt
else
  echo "ufw no disponible" > resumen.txt
fi
