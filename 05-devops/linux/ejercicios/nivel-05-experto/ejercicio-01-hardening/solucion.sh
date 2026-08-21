#!/usr/bin/env bash
set -uo pipefail

{
  echo "## SSH"
  if [ -f /etc/ssh/sshd_config ]; then
    echo "Configuración SSH encontrada en /etc/ssh/sshd_config"
    grep -E "^#?PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null || echo "PermitRootLogin no definido (recomendado: no)"
    grep -E "^#?PasswordAuthentication" /etc/ssh/sshd_config 2>/dev/null || echo "PasswordAuthentication no definido (recomendado: no)"
    echo "Recomendación: PermitRootLogin no y PasswordAuthentication no"
  else
    echo "/etc/ssh/sshd_config no encontrado"
  fi
  echo

  echo "## Servicios inseguros"
  systemctl list-unit-files 2>/dev/null | grep -E "rsh|telnet|rlogin" || echo "No se encontraron servicios inseguros (rsh, telnet, rlogin)"
  echo

  echo "## Permisos sensibles"
  echo "/etc/passwd: $(stat -c %a /etc/passwd 2>/dev/null || echo 'N/A') (esperado 644)"
  echo "/etc/shadow: $(stat -c %a /etc/shadow 2>/dev/null || echo 'N/A') (esperado 640 o 000)"
  echo "~/.ssh: $(stat -c %a "$HOME/.ssh" 2>/dev/null || echo 'N/A') (esperado 700)"
  echo

  echo "## Actualizaciones"
  if command -v apt >/dev/null 2>&1; then
    apt list --upgradable 2>/dev/null | head -10 || echo "No se pudo listar"
  elif command -v dnf >/dev/null 2>&1; then
    dnf check-update 2>/dev/null | head -10 || echo "No se pudo listar"
  else
    echo "Gestor de paquetes no reconocido"
  fi
  echo

  echo "## Firewall"
  if command -v ufw >/dev/null 2>&1; then
    ufw status 2>/dev/null || echo "ufw presente pero sin permisos"
  elif command -v iptables >/dev/null 2>&1; then
    iptables -L 2>/dev/null | head -5 || echo "iptables presente pero sin permisos"
  else
    echo "Ni ufw ni iptables disponibles"
  fi
} > hardening.txt

cat > aplicar.sh <<'EOF'
#!/usr/bin/env bash
# Hardening - ejecutar como root
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw enable
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys 2>/dev/null
EOF
chmod +x aplicar.sh
