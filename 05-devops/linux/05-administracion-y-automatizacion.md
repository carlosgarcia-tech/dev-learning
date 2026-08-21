# 05 — Administración y automatización

## Objetivos

- [ ] Programar tareas con `cron`, `crontab` y `at`.
- [ ] Crear y gestionar *systemd timers* como alternativa a `cron`.
- [ ] Gestionar logs con `rsyslog`, `logrotate` y `journald`.
- [ ] Monitorizar el sistema básicamente (CPU, disco, red, procesos).
- [ ] Configurar cuotas de disco y entender LVM.
- [ ] Gestionar servicios y unidades de `systemd`.
- [ ] Aplicar *hardening* básico de seguridad.
- [ ] Automatizar tareas recurrentes con scripts.
- [ ] Diagnosticar problemas de rendimiento.
- [ ] Usar `strace`, `lsof` e `inotify` para inspección avanzada.
- [ ] Paralelizar tareas con `xargs` y GNU `parallel`.
- [ ] Conocer los niveles de ejecución (*runlevels* / *targets*).

## Apuntes

### cron y crontab

`cron` ejecuta comandos programados en segundo plano. Cada usuario tiene su **crontab**:

```bash
crontab -l                      # listar tus tareas
crontab -e                      # editar (abre $EDITOR)
crontab -r                      # borrar todas tus tareas
crontab -l -u ana               # ver las de otro usuario (root)
```

Formato de una línea crontab (5 campos de tiempo + comando):

```
# min  hora  día-mes  mes  día-semana  comando
# 0-59  0-23  1-31     1-12  0-7 (0 y 7 = domingo)
*/5 * * * * /usr/local/bin/check.sh        # cada 5 minutos
0 2 * * * /opt/scripts/backup.sh           # a las 02:00 cada día
0 0 * * 0 /opt/scripts/limpieza.sh         # cada domingo a medianoche
30 8 * * 1-5 /opt/scripts/diario.sh        # 08:30 de lunes a viernes
0 0 1 * * /opt/scripts/mensual.sh          # día 1 de cada mes a medianoche
0 */6 * * * /opt/scripts/sextil.sh        # cada 6 horas
0 0 1 1 * /opt/scripts/anual.sh            # 1 de enero
```

Sintaxis especial:

| Cadena | Equivale a |
|---|---|
| `@reboot` | al arrancar el sistema |
| `@yearly` / `@annually` | `0 0 1 1 *` |
| `@monthly` | `0 0 1 * *` |
| `@weekly` | `0 0 * * 0` |
| `@daily` / `@midnight` | `0 0 * * *` |
| `@hourly` | `0 * * * *` |

> En `cron`, **los porcentajes `%` son saltos de línea**: `date +%F` dentro de crontab debe escaparse como `date +\%F`. Las rutas son mínimas: usa rutas absolutas y redirige salida a un log.

### at (ejecución diferida)

`at` ejecuta un comando **una sola vez** en un momento dado:

```bash
echo "backup.sh" | at 23:00            # a las 23:00 de hoy
echo "reboot" | at now + 30 minutes    # dentro de 30 minutos
echo "alerta" | at 2am tomorrow         # mañana a las 2:00
atq                                    # ver trabajos pendientes
atrm 3                                 # borrar trabajo nº 3
```

### systemd timers

Los *timers* de systemd son la alternativa moderna a cron. Tienen mejor integración con logs (`journalctl`), dependencias y precisión.

Un *timer* se compone de dos archivos: un `.service` (lo que se ejecuta) y un `.timer` (cuándo). Ejemplo `/etc/systemd/system/backup.service`:

```ini
[Unit]
Description=Backup diario

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

Y `/etc/systemd/system/backup.timer`:

```ini
[Unit]
Description=Backup diario a las 2:00

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true
AccuracySec=1min

[Install]
WantedBy=timers.target
```

Gestión:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now backup.timer
systemctl list-timers --all
systemctl status backup.timer
journalctl -u backup.service
```

`OnCalendar` admite valores como `daily`, `weekly`, `*-*-* 02:00:00`, `mon..fri 09:00`. `Persistent=true` hace que se ejecute al arrancar si se perdió (como `anacron`).

### Logs: rsyslog, logrotate, journald

**rsyslog** escribe logs tradicionales en `/var/log/`:

```bash
cat /var/log/syslog              # Debian/Ubuntu: log general
cat /var/log/messages            # RHEL/Fedora: log general
tail -f /var/log/auth.log        # inicios de sesión (Debian)
tail -f /var/log/secure          # inicios de sesión (RHEL)
logger "Mensaje desde script"   # enviar un mensaje a syslog
```

Prioridades `syslog`: `emerg`, `alert`, `crit`, `err`, `warning`, `notice`, `info`, `debug`.

**logrotate** rota, comprime y borra logs antiguos para que no llenen el disco:

```bash
cat /etc/logrotate.conf          # config global
ls /etc/logrotate.d/             # configs por servicio
# ejemplo de /etc/logrotate.d/miapp:
/var/log/miapp/*.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
    create 0640 www-data www-data
}
sudo logrotate -d /etc/logrotate.d/miapp    # dry-run (debug)
sudo logrotate -f /etc/logrotate.d/miapp    # forzar rotación ahora
```

**journald** (visto en la guía 03) centraliza logs en binario, consultables con `journalctl`:

```bash
journalctl --since "1 hour ago" -p err
journalctl -u nginx --since today
journalctl --vacuum-size=500M            # limitar tamaño total
journalctl --vacuum-time=30d             # borrar mayores de 30 días
```

### Monitoreo básico

Métricas clave y dónde verlas:

| Recurso | Comando rápido | Comando detallado |
|---|---|---|
| Carga CPU | `uptime` | `top`, `htop`, `mpstat` |
| Memoria | `free -h` | `vmstat 1`, `top` |
| Disco (uso) | `df -h` | `du -sh *` |
| Disco (I/O) | `iostat 1` | `iotop` |
| Red | `ip -s link` | `iftop`, `nload` |
| Procesos | `ps aux` | `htop`, `top` |

```bash
uptime                          # load average
vmstat 1 5                      # memoria/CPU cada 1 s, 5 veces
iostat -x 1                     # I/O por dispositivo
sar -u 1 3                      # CPU histórico (paquete sysstat)
top -b -n1 | head -20           # snapshot no interactivo (scripts)
ps aux --sort=-%cpu | head      # top CPU
ps aux --sort=-%mem | head      # top memoria
```

### Cuotas de disco

Las **cuotas** limitan el espacio o inodos por usuario/grupo:

```bash
sudo apt install quota          # instalar herramientas
# 1. Activar cuotas en /etc/fstab: usrquota,grpquota
#    /dev/sda1  /home  ext4  defaults,usrquota,grpquota  0  0
sudo mount -o remount /home
sudo quotacheck -cum /home      # crear archivos de cuota
sudo quotaon -v /home           # activar
sudo edquota -u ana             # asignar límite a un usuario
quota -u ana                    # ver tu propia cuota
repquota /home                  # resumen de todos
```

Límites *soft* (avisa, se puede superar un tiempo) y *hard* (límite estricto).

### LVM (Logical Volume Manager)

LVM abstrae el disco en *volúmenes físicos* (PV) → *grupos de volúmenes* (VG) → *volúmenes lógicos* (LV), permitiendo redimensionar en caliente.

```bash
sudo pvcreate /dev/sdb                  # crear PV
sudo vgcreate vg_datos /dev/sdb         # crear VG
sudo lvcreate -L 20G -n lv_datos vg_datos   # crear LV de 20G
sudo mkfs.ext4 /dev/vg_datos/lv_datos   # formatear
sudo mount /dev/vg_datos/lv_datos /mnt/datos

sudo lvextend -L +10G /dev/vg_datos/lv_datos  # ampliar +10G
sudo resize2fs /dev/vg_datos/lv_datos   # redimensionar FS ext4
sudo xfs_growfs /mnt/datos              # redimensionar FS xfs

pvs / vgs / lvs                         # ver estado
```

Ventajas: snapshots, redimensionado sin desmontar, agrupar discos físicos.

### Gestión de servicios

Ya visto en la guía 03; recordatorio de unidades avanzadas:

```bash
systemctl list-units --type=service             # servicios activos
systemctl list-unit-files --state=enabled       # habilitados al boot
systemctl list-dependencies nginx               # árbol de dependencias
systemctl cat nginx                             # ver el archivo .service
systemctl edit nginx                            # override (drop-in)
systemctl reset-failed                          # limpiar units fallidos
systemctl daemon-reload                         # tras modificar .service
```

Estructura de un `.service` (`/etc/systemd/system/miapp.service`):

```ini
[Unit]
Description=Mi aplicación
After=network.target

[Service]
Type=simple
User=miapp
WorkingDirectory=/opt/miapp
ExecStart=/usr/bin/python3 /opt/miapp/app.py
Restart=on-failure
RestartSec=5s
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

### Hardening básico

Medidas de seguridad esenciales en un servidor:

- **Actualizaciones**: `sudo apt update && sudo apt upgrade` periódico.
- **SSH**: deshabilitar login por contraseña y root. En `/etc/ssh/sshd_config`:
  ```
  PermitRootLogin no
  PasswordAuthentication no
  ```
  Luego `sudo systemctl restart ssh`.
- **Firewall**: `ufw default deny incoming && ufw allow 22 && ufw enable`.
- **Fail2ban**: bloquea IPs tras varios intentos fallidos de SSH.
- **Mínimos privilegios**: no trabajar como root; usar `sudo` para tareas concretas.
- **Deshabilitar servicios innecesarios**: `systemctl disable --now cups`.
- **Permisos estrictos**: `/etc/shadow` 640, `~/.ssh` 700, claves privadas 600.
- **Auditoría**: `cat /var/log/auth.log`, `last`, `journalctl -u ssh`.

```bash
# ver intentos de acceso fallidos
sudo grep "Failed password" /var/log/auth.log | tail
last                            # últimos inicios de sesión
lastb                           # intentos fallidos
```

### Automatización con scripts

Un buen script de automatización debe:

1. Empezar con `#!/usr/bin/env bash` y `set -euo pipefail`.
2. Usar variables al inicio, rutas absolutas y funciones.
3. Tener logging (con `logger` o a archivo).
4. Gestionar errores y *exit codes*.
5. Ser idempotente (poder ejecutarse varias veces sin romper).

```bash
#!/usr/bin/env bash
set -euo pipefail
readonly LOG="/var/log/miapp.log"
log() { echo "[$(date +'%F %T')] $*" | tee -a "$LOG"; }

backup() {
  local src="$1" dest="$2"
  log "Iniciando backup de $src"
  tar czf "$dest/backup-$(date +%F).tar.gz" -C "$src" .
  log "Backup completado"
}

backup /var/www /backup
```

### Diagnóstico de rendimiento

Metodología general:

1. **¿Qué falla?** CPU, memoria, disco o red. Empieza por `uptime`, `free`, `df`.
2. **¿Quién consume?** `top`/`htop` para procesos, `du` para disco.
3. **¿Cuello de botella?** `iostat`, `vmstat`, `iotop`.
4. **¿Hay errores en logs?** `journalctl -p err`, `/var/log/`.

```bash
uptime                          # ¿load average alto?
free -h                         # ¿memoria agotada?
df -h                           # ¿disco lleno?
top -o %CPU                     # ¿quién chupa CPU?
top -o %MEM                     # ¿quién chupa memoria?
iostat -x 1                    # ¿disco saturado? (%util alto)
vmstat 1 5                     # swap, I/O, context switches
ps auxf                         # árbol de procesos
```

Reglas generales: si `load average` >> nº de CPUs y `%wa` (I/O wait en `top`) alto → disco lento. Si `free` casi 0 y `swap` en uso → falta RAM. Si `iostat` `%util` ~100% → disco saturado.

### strace

`strace` rastrea las **llamadas al sistema** (*syscalls*) que hace un proceso: útil para ver por qué se cuelga, qué archivos abre, qué red hace.

```bash
strace -e trace=openat cat /etc/passwd    # solo llamadas openat
strace -p 1234                            # a un proceso en marcha
strace -c comando                         # resumen estadístico
strace -f comando                         # sigue procesos hijos
strace -e network comando                 # solo syscalls de red
```

Ejemplo: descubrir qué archivos abre un programa:

```bash
strace -e trace=openat python3 -c "import json" 2>&1 | head
```

### lsof

`lsof` (*list open files*) lista qué proceso tiene abierto qué archivo/socket:

```bash
lsof /var/log/syslog                     # quién tiene abierto este archivo
lsof -i :80                              # qué escucha en el puerto 80
lsof -i tcp                              # conexiones TCP
lsof -u ana                              # archivos abiertos por un usuario
lsof -p 1234                             # archivos abiertos por un proceso
lsof +D /tmp                             # archivos abiertos en un directorio
lsof -i                                  # todos los sockets de red
```

> ¿"No se puede desmontar, dispositivo ocupado"? `lsof +D /mnt` te dice quién lo bloquea.

### inotify

`inotify` vigila cambios en el sistema de archivos en tiempo real (paquete `inotify-tools`):

```bash
inotifywait -m /var/log                    # vigila cambios en un dir
inotifywait -m -e create,modify /tmp       # solo esos eventos
while inotifywait -qq -e modify config.yml; do
  systemctl reload miapp
done
```

Eventos: `create`, `modify`, `delete`, `move`, `access`, `close_write`.

### Paralelismo con xargs y GNU parallel

**xargs -P** ejecuta comandos en paralelo:

```bash
echo {1..100} | xargs -n1 -P4 ./procesar.sh    # 4 en paralelo
find . -name "*.png" | xargs -n1 -P4 -I{} convert {} {}.thumb.png
ls *.log | xargs -P4 -n1 gzip                   # comprimir 4 a la vez
```

- `-P N` lanza hasta N procesos simultáneos.
- `-n K` cuántos argumentos por comando.
- `-I{}` define un marcador de posición.

**GNU parallel** es más potente (barra de progreso, control de salida, SSH remoto):

```bash
parallel -j4 ./procesar.sh ::: a b c d e f
parallel -j4 gzip ::: *.log
parallel --bar convert {} {.}.png ::: *.jpg
parallel -S servidor@example.com uptime ::: host1 host2 host3
```

### Niveles de ejecución (runlevels / targets)

En el sistema clásico *SysV init*, los **runlevels** definían el modo de arranque:

| Runlevel | Significado |
|---|---|
| 0 | apagado |
| 1 | monousuario (mantenimiento, *single user*) |
| 2 | multiusuario sin red (Debian) |
| 3 | multiusuario con red, sin GUI |
| 5 | multiusuario con GUI (escritorio) |
| 6 | reinicio |

En **systemd** se usan **targets**, que son equivalentes:

| Target | Equivalencia |
|---|---|
| `poweroff.target` | runlevel 0 |
| `rescue.target` | runlevel 1 |
| `multi-user.target` | runlevel 3 |
| `graphical.target` | runlevel 5 |
| `reboot.target` | runlevel 6 |

```bash
systemctl get-default                  # ver el target por defecto
sudo systemctl set-default multi-user.target   # arrancar sin GUI
sudo systemctl isolate multi-user.target       # cambiar en caliente
runlevel                               # runlevel actual (compat)
```

### Comandos de referencia rápida

| Comando | Qué hace |
|---|---|
| `crontab -e` / `at` | programar tareas |
| `systemctl list-timers` | timers systemd |
| `journalctl -u svc` | logs de un servicio |
| `logrotate -f` | rotar logs |
| `free -h` / `df -h` / `iostat` | monitoreo |
| `quotaon` / `edquota` | cuotas |
| `lvcreate` / `lvextend` | LVM |
| `strace -p PID` | trazas de syscalls |
| `lsof -i :80` | quién abre un puerto |
| `xargs -P4` / `parallel -j4` | paralelismo |
| `systemctl get-default` | runlevel/target por defecto |

## Conceptos clave

- **`cron` vs *systemd timers***: cron es más simple y universal; los timers se integran con `journald`, dependencias y son más precisos.
- **`logrotate` evita llenar el disco**: rota, comprime y borra logs antiguos según política.
- **LVM separa disco físico del lógico**: puedes ampliar/encoger volúmenes sin reorganizar particiones.
- **Hardening es por capas**: actualizaciones + firewall + SSH seguro + mínimos privilegios + auditoría.
- **`strace` muestra syscalls**, `lsof` muestra archivos/sockets abiertos, `inotify` vigila cambios: herramientas de diagnóstico avanzadas.
- **`xargs -P` y `parallel`**: paralelizan trabajos CPU o I/O, reduciendo tiempos de N a N/cores.

## Errores comunes

- **`%` sin escapar en crontab**: cron lo interpreta como salto de línea y corta el comando. Usa `\%`.
- **Rutas relativas en cron/timers**: el entorno es mínimo y el `PATH` corto. Usa **rutas absolutas**.
- **No redirigir salida de cron**: si falla, no te enteras. Añade `>> /var/log/mi.log 2>&1`.
- **Olvidar `daemon-reload`** tras editar un `.service`/`.timer`: systemd no coge los cambios.
- **`logrotate` sin `compress`**: los logs viejos ocupan igual. Configura `compress` o `delaycompress`.
- **Redimensionar LV pero no el filesystem**: tras `lvextend` hay que `resize2fs` (ext4) o `xfs_growfs` (xfs).
- **`strace` sin `-f`**: no sigue los procesos hijos, perdés la mitad de la actividad.
- **`xargs -P4` con scripts que escriben al mismo archivo**: se pisan. Usa archivos de salida distintos por argumento.
- **Deshabilitar SSH con contraseña** sin haber probado la autenticación por clave: te quedas fuera del servidor.
