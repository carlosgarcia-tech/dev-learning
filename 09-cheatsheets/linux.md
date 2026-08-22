# Chuleta de Linux

Referencia rápida de la línea de comandos de Linux. Cubre desde navegación básica hasta herramientas avanzadas como `sed`, `awk`, `tar` y `ssh`.

## Índice

- [Navegación y directorios](#navegación-y-directorios)
- [Archivos](#archivos)
- [Permisos](#permisos)
- [Procesos](#procesos)
- [Red](#red)
- [Paquetes](#paquetes)
- [systemd](#systemd)
- [journal (logs)](#journal-logs)
- [Usuarios y grupos](#usuarios-y-grupos)
- [Discos](#discos)
- [Redirecciones y pipes](#redirecciones-y-pipes)
- [find](#find)
- [grep](#grep)
- [sed](#sed)
- [awk](#awk)
- [tar](#tar)
- [ssh y scp](#ssh-y-scp)
- [cron](#cron)
- [Variables de entorno](#variables-de-entorno)
- [Shortcuts de bash](#shortcuts-de-bash)

---

## Navegación y directorios

| Comando | Descripción |
|---|---|
| `pwd` | Imprime el directorio actual |
| `cd` | Va al home |
| `cd ~` | Va al home |
| `cd -` | Directorio anterior |
| `cd ..` | Sube un nivel |
| `ls` | Lista archivos |
| `ls -l` | Formato largo (permisos, tamaño, fecha) |
| `ls -a` | Incluye ocultos |
| `ls -lh` | Tamaños legibles |
| `ls -lt` | Ordenado por fecha (más reciente) |
| `ls -ltr` | Ordenado por fecha (más antiguo) |
| `ls -R` | Recursivo |
| `tree` | Árbol de directorios (requiere instalar) |
| `mkdir <dir>` | Crea un directorio |
| `mkdir -p a/b/c` | Crea padres si no existen |
| `rmdir <dir>` | Borra directorio vacío |
| `rm -r <dir>` | Borra recursivo |
| `cp -r <origen> <destino>` | Copia recursivo |
| `mv <a> <b>` | Mueve/renombra |

---

## Archivos

| Comando | Descripción |
|---|---|
| `touch <archivo>` | Crea vacío o actualiza timestamp |
| `cat <archivo>` | Muestra contenido |
| `cat -n <archivo>` | Con números de línea |
| `less <archivo>` | Paginador (q salir, / buscar) |
| `head -n 20 <archivo>` | Primeras 20 líneas |
| `tail -n 20 <archivo>` | Últimas 20 líneas |
| `tail -f <archivo>` | Sigue el archivo en vivo |
| `wc -l <archivo>` | Cuenta líneas |
| `wc -w <archivo>` | Cuenta palabras |
| `file <archivo>` | Tipo de archivo |
| `stat <archivo>` | Metadatos completos |
| `ln -s <destino> <enlace>` | Enlace simbólico |
| `ln <destino> <enlace>` | Enlace duro |
| `du -sh <dir>` | Tamaño de un directorio |
| `df -h` | Espacio en discos |

```bash
# Ver un log en vivo
tail -f /var/log/syslog
```

---

## Permisos

Formato: `rwx` para usuario, grupo y otros. Numérico: `r=4 w=2 x=1`.

| Notación | Significado |
|---|---|
| `755` | `rwxr-xr-x` (dirs ejecutables para todos) |
| `644` | `rw-r--r--` (archivos legibles) |
| `600` | `rw-------` (privado, ej. claves SSH) |
| `700` | `rwx------` (dirs privados) |

| Comando | Descripción |
|---|---|
| `chmod 755 <archivo>` | Permisos numéricos |
| `chmod u+x <archivo>` | Añade ejecutable al usuario |
| `chmod g-w <archivo>` | Quita escritura al grupo |
| `chmod -R 755 <dir>` | Recursivo |
| `chmod +x script.sh` | Ejecutable para todos |
| `chown usuario:grupo <archivo>` | Cambia dueño y grupo |
| `chown usuario <archivo>` | Solo dueño |
| `chgrp grupo <archivo>` | Solo grupo |
| `chown -R usuario:grupo <dir>` | Recursivo |
| `umask 022` | Permisos por defecto al crear |
| `umask 077` | Privado por defecto |

```bash
# Permisos seguros para clave SSH
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

---

## Procesos

| Comando | Descripción |
|---|---|
| `ps aux` | Todos los procesos |
| `ps -ef` | Árbol con PPID |
| `ps aux \| grep nginx` | Filtra procesos |
| `top` | Monitor interactivo |
| `htop` | Monitor mejorado (instalar) |
| `kill <pid>` | Envía SIGTERM |
| `kill -9 <pid>` | Fuerza kill (SIGKILL) |
| `killall <nombre>` | Mata por nombre |
| `pkill -f "patron"` | Mata por patrón de comando |
| `pgrep -fl nginx` | Busca PIDs por nombre |
| `jobs` | Trabajos en background del shell |
| `fg %1` | Trae al frente el job 1 |
| `bg %1` | Reanuda en background |
| `nohup comando &` | Sigue tras cerrar sesión |
| `comando &` | Lanza en background |
| `disown -h %1` | Desconecta del shell |
| `nice -n 10 comando` | Baja prioridad |
| `renice -n 5 -p <pid>` | Cambia prioridad en marcha |

Señales comunes:

| Señal | Nº | Efecto |
|---|---|---|
| `SIGHUP` | 1 | Recarga configuración |
| `SIGINT` | 2 | Ctrl+C (interrumpir) |
| `SIGTERM` | 15 | Terminar limpiamente (por defecto) |
| `SIGKILL` | 9 | Matar a la fuerza (no se puede capturar) |
| `SIGSTOP` | 19 | Pausar |
| `SIGCONT` | 18 | Continuar |

```bash
# Lanzar servidor que sobrevive al logout
nohup python3 app.py > app.log 2>&1 &
```

---

## Red

| Comando | Descripción |
|---|---|
| `ip addr` | Interfaces y IPs |
| `ip a` | Abreviado |
| `ip route` | Tabla de rutas |
| `ip link set eth0 up` | Levantar interfaz |
| `ping -c 4 host` | 4 paquetes |
| `curl ifconfig.me` | Tu IP pública |
| `curl -I https://example.com` | Solo cabeceras |
| `wget <url>` | Descargar |
| `wget -c <url>` | Continuar descarga |
| `ss -tlnp` | Puertos TCP en escucha |
| `ss -ulnp` | Puertos UDP en escucha |
| `netstat -tulpn` | Alternativa a ss |
| `lsof -i :8080` | Quién usa el puerto 8080 |
| `dig dominio.com` | Consulta DNS |
| `dig +short dominio.com` | Solo la IP |
| `nslookup dominio.com` | DNS básico |
| `traceroute host` | Ruta de saltos |
| `mtr host` | traceroute interactivo |
| `hostname -I` | IP local |
| `ip neigh` | Tabla ARP |

```bash
# Ver qué proceso escucha en un puerto
sudo ss -tlnp | grep :80
sudo lsof -i :80
```

---

## Paquetes

### Debian/Ubuntu (apt)

| Comando | Descripción |
|---|---|
| `sudo apt update` | Actualiza índice |
| `sudo apt upgrade` | Actualiza paquetes |
| `sudo apt install <pkg>` | Instala |
| `sudo apt remove <pkg>` | Desinstala (mantiene config) |
| `sudo apt purge <pkg>` | Desinstala y borra config |
| `apt search <texto>` | Busca |
| `apt show <pkg>` | Información |
| `apt list --installed` | Instalados |
| `sudo apt autoremove` | Limpia dependencias huérfanas |

### Fedora/RHEL (dnf/yum)

| Comando | Descripción |
|---|---|
| `sudo dnf install <pkg>` | Instala |
| `sudo dnf remove <pkg>` | Desinstala |
| `dnf search <texto>` | Busca |
| `dnf list installed` | Instalados |
| `sudo dnf upgrade` | Actualiza todo |

### Arch (pacman)

| Comando | Descripción |
|---|---|
| `sudo pacman -Syu` | Sincroniza y actualiza |
| `sudo pacman -S <pkg>` | Instala |
| `sudo pacman -R <pkg>` | Desinstala |
| `pacman -Ss <texto>` | Busca |

### Snap / Flatpak

```bash
sudo snap install <pkg>
flatpak install flathub <pkg>
```

---

## systemd

| Comando | Descripción |
|---|---|
| `systemctl status <svc>` | Estado de un servicio |
| `systemctl start <svc>` | Inicia |
| `systemctl stop <svc>` | Detiene |
| `systemctl restart <svc>` | Reinicia |
| `systemctl reload <svc>` | Recarga config sin parar |
| `systemctl enable <svc>` | Arranca en boot |
| `systemctl disable <svc>` | No arranca en boot |
| `systemctl is-enabled <svc>` | ¿Está habilitado? |
| `systemctl is-active <svc>` | ¿Está corriendo? |
| `systemctl list-units --type=service` | Todos los servicios |
| `systemctl list-unit-files --type=service` | Servicios instalados |
| `systemctl daemon-reload` | Recargar tras editar units |
| `systemctl reboot` | Reiniciar |
| `systemctl poweroff` | Apagar |

```bash
# Servicio típico: ver estado y logs
sudo systemctl status nginx
sudo journalctl -u nginx -f
```

---

## journal (logs)

| Comando | Descripción |
|---|---|
| `journalctl` | Todos los logs |
| `journalctl -u <svc>` | De un servicio |
| `journalctl -u <svc> -f` | En vivo |
| `journalctl --since today` | Desde hoy |
| `journalctl --since "1h ago"` | Última hora |
| `journalctl -p err` | Solo errores |
| `journalctl -p err -u nginx` | Errores de nginx |
| `journalctl -b` | Desde el último boot |
| `journalctl -b -1` | Boot anterior |
| `journalctl --disk-usage` | Espacio ocupado |
| `sudo journalctl --vacuum-time=7d` | Borra logs > 7 días |
| `sudo journalctl --vacuum-size=100M` | Limita a 100 MB |

```bash
# ¿Por qué no arranca mi servicio?
sudo journalctl -u mi-servicio -n 50 --no-pager
```

---

## Usuarios y grupos

| Comando | Descripción |
|---|---|
| `whoami` | Usuario actual |
| `id` | UID, GID y grupos |
| `who` | Usuarios conectados |
| `w` | Quién está y qué hace |
| `sudo adduser <nombre>` | Crea usuario (interactivo, Debian) |
| `sudo useradd -m <nombre>` | Crea usuario (no interactivo) |
| `sudo passwd <nombre>` | Cambia contraseña |
| `sudo usermod -aG docker <usuario>` | Añade a un grupo |
| `sudo deluser <nombre>` | Borra usuario |
| `groupadd <grupo>` | Crea grupo |
| `gpasswd -d <user> <grupo>` | Quita de un grupo |
| `su - <usuario>` | Cambiar de usuario |
| `sudo -i` | Shell de root |
| `sudo -u <usuario> comando` | Ejecuta como otro |

```bash
# Dar permisos de docker a tu usuario
sudo usermod -aG docker $USER
newgrp docker   # aplica sin cerrar sesión
```

---

## Discos

| Comando | Descripción |
|---|---|
| `df -h` | Espacio en montajes |
| `du -sh *` | Tamaño de cada elemento |
| `du -h --max-depth=1` | Un nivel |
| `lsblk` | Bloques (discos y particiones) |
| `blkid` | UUIDs de particiones |
| `sudo fdisk -l` | Tabla de particiones |
| `mount` | Montajes actuales |
| `sudo mount /dev/sdb1 /mnt` | Montar |
| `sudo umount /mnt` | Desmontar |
| `findmnt` | Árbol de montajes |
| `free -h` | Memoria RAM |
| `lsusb` | Dispositivos USB |
| `lspci` | Dispositivos PCI |
| `lscpu` | Info de CPU |

### /etc/fstab (montaje persistente)

```
UUID=xxxx-xxxx  /mnt/data  ext4  defaults  0  2
```

```bash
# Verificar fstab sin reiniciar
sudo findmnt --verify
```

---

## Redirecciones y pipes

| Operador | Descripción |
|---|---|
| `>` | Sobrescribe archivo |
| `>>` | Añade al final |
| `2>` | Redirige stderr |
| `2>&1` | stderr al mismo sitio que stdout |
| `&>` | stdout + stderr a un archivo |
| `<` | Lee de archivo como stdin |
| `<<EOF ... EOF` | Here-doc |
| `<<<"texto"` | Here-string |
| `\|` | Pipe (stdout de uno → stdin de otro) |
| `tee archivo` | Escribe en archivo y stdout |
| `tee -a archivo` | Añade en archivo y stdout |
| `xargs` | Pasa stdin como argumentos |
| `\|&` | stdout + stderr por pipe |

```bash
# Guardar salida y errores a la vez
comando &> salida.log
comando > salida.log 2>&1   # equivalente clásico

# Here-doc para crear archivos
cat > script.sh <<'EOF'
#!/bin/bash
echo "Hola"
EOF

# tee: ver y guardar
npm test 2>&1 | tee test.log
```

---

## find

| Comando | Descripción |
|---|---|
| `find . -name "*.py"` | Por nombre |
| `find . -iname "*.py"` | Sin distinguir mayúsculas |
| `find . -type f` | Solo archivos |
| `find . -type d` | Solo directorios |
| `find . -type l` | Solo enlaces |
| `find . -mtime -7` | Modificados en 7 días |
| `find . -mmin -60` | Modificados en 60 min |
| `find . -size +100M` | Más grandes de 100 MB |
| `find . -size -1k` | Más pequeños de 1 KB |
| `find . -user root` | Por dueño |
| `find . -perm 644` | Permisos exactos |
| `find . -empty` | Vacíos |
| `find . -maxdepth 2` | Profundidad limitada |
| `find . -name "*.log" -delete` | Borrar resultados |
| `find . -name "*.js" -exec wc -l {} +` | Ejecutar comando |
| `find . -name "*.tmp" -exec rm {} \;` | Uno a uno |

```bash
# Buscar y ejecutar
find . -name "*.test.js" -exec eslint {} +

# Archivos grandes que ocupan espacio
find / -type f -size +500M 2>/dev/null | head
```

---

## grep

| Opción | Descripción |
|---|---|
| `grep "patron" archivo` | Busca en archivo |
| `grep -i` | No distingue mayúsculas |
| `grep -v` | Invierte (líneas que NO coinciden) |
| `grep -n` | Número de línea |
| `grep -r` | Recursivo |
| `grep -l` | Solo nombres de archivos |
| `grep -c` | Contar coincidencias |
| `grep -E` | Regex extendida (como egrep) |
| `grep -w` | Palabra completa |
| `grep -o` | Solo la parte que coincide |
| `grep -A 2` | 2 líneas después |
| `grep -B 2` | 2 líneas antes |
| `grep -C 2` | 2 antes y 2 después |
| `grep --color` | Resalta |

```bash
# Casos típicos
grep -rn "TODO" src/
ps aux | grep nginx
grep -E "^import" app.py
grep -v "^#" /etc/hosts    # quitar comentarios
```

---

## sed

Editor de flujo. Trabaja línea a línea.

| Comando | Descripción |
|---|---|
| `sed 's/viejo/nuevo/' archivo` | Reemplaza 1ª ocurrencia |
| `sed 's/viejo/nuevo/g' archivo` | Reemplaza todas |
| `sed 's/viejo/nuevo/gi' archivo` | Ignora mayúsculas |
| `sed -i 's/viejo/nuevo/g' archivo` | Edita in-place |
| `sed -i.bak 's/a/b/g' archivo` | In-place + backup |
| `sed '3d' archivo` | Borra línea 3 |
| `sed '2,5d' archivo` | Borra líneas 2-5 |
| `sed -n '10,20p' archivo` | Imprime líneas 10-20 |
| `sed '/patron/d' archivo` | Borra líneas que coinciden |
| `sed '/^$/d' archivo` | Borra líneas vacías |
| `sed 's/\t/  /g' archivo` | Tabs a espacios |
| `sed -e 's/a/b/' -e 's/c/d/' archivo` | Varios comandos |

```bash
# Cambiar puerto en un archivo de config
sudo sed -i 's/listen 80;/listen 8080;/' /etc/nginx/nginx.conf

# Quitar comentarios y vacíos de un config
sed -e 's/#.*//' -e '/^$/d' archivo.conf
```

---

## awk

Lenguaje de procesamiento de texto por campos.

| Comando | Descripción |
|---|---|
| `awk '{print $1}'` | Imprime 1ª columna |
| `awk '{print $1, $3}'` | Columnas 1 y 3 |
| `awk '{print $NF}'` | Última columna |
| `awk -F: '{print $1}'` | Separador `:` |
| `awk -F, '{print $2}'` | CSV, columna 2 |
| `awk 'NR==3'` | Solo línea 3 |
| `awk 'NR>=2 && NR<=5'` | Líneas 2-5 |
| `awk 'length > 80'` | Líneas largas |
| `awk '{sum+=$1} END {print sum}'` | Suma columna 1 |
| `awk '$3 > 100'` | Filtra por condición |
| `awk '/error/ {print}'` | Líneas con "error" |
| `awk '{print NR, $0}'` | Numerar líneas |

```bash
# Top 5 procesos por memoria (2ª columna en ps con RSS)
ps aux | sort -k6 -rn | head -5

# Sumar tamaño de archivos listados
ls -l | awk '{sum+=$5} END {print sum/1024 " KB"}'
```

---

## tar

| Comando | Descripción |
|---|---|
| `tar -cvf archivo.tar dir/` | Crear .tar |
| `tar -xvf archivo.tar` | Extraer |
| `tar -xvf archivo.tar -C /tmp` | Extraer en /tmp |
| `tar -czvf archivo.tar.gz dir/` | Crear gzip |
| `tar -xzvf archivo.tar.gz` | Extraer gzip |
| `tar -cjvf archivo.tar.bz2 dir/` | Crear bzip2 |
| `tar -xjvf archivo.tar.bz2` | Extraer bzip2 |
| `tar -tf archivo.tar.gz` | Listar contenido |
| `tar -xzvf archivo.tar.gz ruta/dentro` | Extraer un archivo |
| `tar -czvf - dir/ \| ssh host 'cat > copia.tar.gz'` | Sobre SSH |

Banderas: `c` crear, `x` extraer, `t` listar, `v` verbose, `f` archivo, `z` gzip, `j` bzip2, `C` directorio destino.

```bash
# Backup con timestamp
tar -czvf backup_$(date +%Y%m%d).tar.gz /home/usuario/datos
```

---

## ssh y scp

| Comando | Descripción |
|---|---|
| `ssh usuario@host` | Conectar |
| `ssh -p 2222 usuario@host` | Puerto custom |
| `ssh -i ~/.ssh/clave usuario@host` | Con clave concreta |
| `ssh usuario@host 'comando'` | Ejecutar remoto |
| `ssh-copy-id usuario@host` | Copiar clave pública |
| `ssh -L 8080:localhost:80 usuario@host` | Túnel local |
| `ssh -R 9090:localhost:80 usuario@host` | Túnel remoto |
| `ssh -D 1080 usuario@host` | SOCKS proxy |
| `scp archivo user@host:/ruta/` | Subir |
| `scp user@host:/ruta/archivo .` | Bajar |
| `scp -r dir/ user@host:/ruta/` | Recursivo |
| `scp -P 2222 archivo user@host:/ruta/` | Puerto custom |
| `rsync -avz dir/ user@host:/ruta/` | Sincronizar |
| `rsync -avz --delete src/ dest/` | Borra en dest lo que no existe en src |

### ~/.ssh/config

```
Host mi-server
  HostName 192.168.1.10
  User admin
  Port 2222
  IdentityFile ~/.ssh/id_ed25519
  ForwardAgent yes
```

```bash
ssh mi-server   # usa la config de arriba
```

---

## cron

Programar tareas repetitivas.

```bash
crontab -e       # editar tareas del usuario
crontab -l       # listar
crontab -r       # borrar todas
sudo crontab -e  # tareas de root
```

Formato: `minuto hora día-mes mes día-semana comando`

| Expresión | Significado |
|---|---|
| `0 3 * * * comando` | Diario a las 03:00 |
| `*/5 * * * * comando` | Cada 5 minutos |
| `0 0 * * 0 comando` | Domingo a medianoche |
| `0 0 1 * * comando` | Día 1 de cada mes |
| `0 9 * * 1-5 comando` | Lunes a viernes a las 9 |
| `@reboot comando` | Al iniciar el sistema |
| `@daily comando` | Diario (= `0 0 * * *`) |

```cron
# Backup diario + log
0 3 * * * /home/user/scripts/backup.sh >> /home/user/backup.log 2>&1
```

### systemd timer (alternativa moderna)

```bash
systemctl list-timers
```

---

## Variables de entorno

| Comando | Descripción |
|---|---|
| `env` | Lista variables |
| `printenv PATH` | Valor de una variable |
| `echo $HOME` | Mostrar una |
| `VAR="valor"` | Variable de shell |
| `export VAR="valor"` | Variable de entorno |
| `unset VAR` | Borrar variable |
| `export PATH=$PATH:/opt/bin` | Añadir al PATH |
| `source archivo` | Cargar variables de un archivo |
| `. archivo` | Igual que source |
| `set` | Variables de shell y funciones |
| `alias ll='ls -lah'` | Crear alias |

### .bashrc / .bash_profile / .profile

| Archivo | Cuándo se carga |
|---|---|
| `/etc/profile` | Login global |
| `~/.bash_profile` | Login de usuario (bash) |
| `~/.bashrc` | Shell interactivo no-login (lo más usado) |
| `~/.profile` | Login (si no hay .bash_profile) |
| `/etc/bash.bashrc` | No-login global |

```bash
# Añadir al PATH permanentemente
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# .env cargado al ejecutar
set -a; source .env; set +a
```

---

## Shortcuts de bash

### Navegación y edición

| Atajo | Acción |
|---|---|
| `Ctrl + A` | Inicio de línea |
| `Ctrl + E` | Final de línea |
| `Ctrl + W` | Borra palabra hacia atrás |
| `Ctrl + U` | Borra hasta el inicio |
| `Ctrl + K` | Borra hasta el final |
| `Ctrl + Y` | Pega lo borrado con W/U/K |
| `Ctrl + L` | Limpiar pantalla (= `clear`) |
| `Ctrl + R` | Buscar en historial (escribir para filtrar) |
| `Ctrl + C` | Cancelar comando |
| `Ctrl + D` | EOF / cerrar shell |
| `Ctrl + Z` | Suspende proceso (luego `bg`/`fg`) |
| `Alt + .` | Último argumento del comando anterior |
| `Esc + B` | Palabra atrás |
| `Esc + F` | Palabra adelante |
| `Tab` | Autocompletar |
| `Tab Tab` | Mostrar opciones |

### Historial

| Atajo | Acción |
|---|---|
| `↑` / `↓` | Comando anterior/siguiente |
| `!!` | Repite el último comando |
| `sudo !!` | Repite como root |
| `!$` | Último argumento del anterior |
| `!comando` | Último comando que empieza por "comando" |
| `!?cadena?` | Último comando que contiene la cadena |
| `history` | Lista el historial |
| `history \| tail` | Últimos comandos |
| `Ctrl+R cadena` | Buscar atrás en el historial |

```bash
# Trucos con el historial
sudo !!          # repite el último como root
cd !$            # al último argumento del comando anterior
```

### Globbing

| Patrón | Significado |
|---|---|
| `*` | Cualquier cadena |
| `?` | Un carácter |
| `[abc]` | Uno de a, b, c |
| `[0-9]` | Rango |
| `{a,b,c}` | Expansión: genera a, b, c |
| `**/` | Recursivo (con `shopt -s globstar`) |

```bash
mkdir -p proyecto/{src,tests,docs}
cp file.{bak,old}    # copia file.bak a file.old
```
