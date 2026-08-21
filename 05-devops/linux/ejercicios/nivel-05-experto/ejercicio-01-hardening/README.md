# Ejercicio 01 — Script de hardening básico

- **Nivel:** 5/5
- **Tema:** *hardening*, SSH, permisos, servicios, firewall, chequeos de seguridad
- **Tiempo estimado:** 40 min

## Enunciado

Escribe `solucion.sh` que genere un **informe de hardening** (`hardening.txt`) y un **script de aplicación** (`aplicar.sh`) listo para ejecutar. Como no queremos modificar el sistema real, el script solo *genera* recomendaciones y comandos, no los ejecuta.

El informe `hardening.txt` debe contener **5 secciones** con chequeos y recomendaciones:

1. `## SSH` — comprueba si existe `/etc/ssh/sshd_config`; recomienda `PermitRootLogin no` y `PasswordAuthentication no`.
2. `## Servicios inseguros` — lista servicios potencialmente peligrosos (rsh, telnet, rlogin) con `systemctl list-unit-files`.
3. `## Permisos sensibles` — verifica permisos de `/etc/passwd` (debe ser `644`), `/etc/shadow` (debe ser `640` o `000`) y `~/.ssh` (debe ser `700`).
4. `## Actualizaciones` — muestra si hay paquetes actualizables (`apt list --upgradable` o equivalente).
5. `## Firewall` — indica si `ufw` o `iptables` están activos.

El script `aplicar.sh` debe contener (sin ejecutarlos) los comandos recomendados:

```bash
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
```

## Requisitos

- [ ] `hardening.txt` existe, no está vacío y contiene las 5 secciones (`## SSH`, `## Servicios inseguros`, `## Permisos sensibles`, `## Actualizaciones`, `## Firewall`).
- [ ] `aplicar.sh` existe, es ejecutable y contiene `PermitRootLogin no` y `ufw enable`.
- [ ] El script no falla aunque algunos comandos no estén disponibles.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa bloques `{ ... } > hardening.txt` para agrupar la salida.
- `[ -f /etc/ssh/sshd_config ]` comprueba si el archivo existe.
- `stat -c %a /etc/passwd` da los permisos en octal.
- `command -v ufw` comprueba si ufw existe.
- Envuelve cada chequeo con `2>/dev/null || echo "no disponible"`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
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
```

</details>
