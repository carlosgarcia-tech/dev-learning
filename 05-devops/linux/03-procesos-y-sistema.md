# 03 — Procesos y sistema

## Objetivos

- [ ] Entender qué es un proceso y su ciclo de vida en Linux.
- [ ] Listar y monitorizar procesos con `ps`, `top` y `htop`.
- [ ] Enviar señales a procesos con `kill`, `killall` y `pkill`.
- [ ] Gestionar trabajos en primer/segundo plano con `jobs`, `fg`, `bg` y `&`.
- [ ] Ajustar la prioridad de un proceso con `nice` y `renice`.
- [ ] Conocer los demonios y el gestor `systemd`.
- [ ] Usar `systemctl` para arrancar, parar, habilitar y consultar servicios.
- [ ] Consultar logs con `journalctl`.
- [ ] Medir memoria (`free`) y disco (`df`, `du`).
- [ ] Gestionar usuarios y grupos (`whoami`, `id`, `su`, `sudo`, `/etc/passwd`, `/etc/group`).
- [ ] Instalar paquetes con `apt`, `dnf` y `pacman`.

## Apuntes

### Procesos

Un **proceso** es un programa en ejecución. Cada proceso tiene:

- un **PID** (identificador único),
- un **PPID** (PID del proceso padre),
- un usuario propietario,
- un estado (`R` corriendo, `S` durmiendo, `Z` zombi, `D` espera de disco),
- consume CPU y memoria.

Cuando ejecutas un comando en la shell, esta crea un proceso *hijo*. El primer proceso (PID 1) es `init` o, en sistemas modernos, `systemd`.

```bash
echo $$                 # PID de tu shell actual
ps                      # procesos de tu terminal
ps aux                  # todos los procesos del sistema (BSD)
ps -ef                  # todos (estándar System V)
ps -ef | grep nginx     # buscar procesos por nombre
```

Columnas de `ps aux`: `USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND`.

### Monitorización: top y htop

`top` muestra una vista dinámica actualizada cada pocos segundos:

```bash
top                     # vista general
# dentro de top:
#   P  ordenar por CPU
#   M  ordenar por memoria
#   k  matar un proceso (pide PID)
#   1  ver CPUs por núcleo
#   q  salir
```

`htop` es una versión mejorada, en color y con barras (instalar con `apt install htop` o `dnf install htop`):

```bash
htop                    # interfaz amigable
```

Vistas rápidas equivalentes sin instalar nada:

```bash
uptime                  # carga media (1, 5, 15 min)
w                       # quién está conectado y qué hace
```

La **load average** (p. ej. `0.45, 0.30, 0.20`) indica procesos en espera de CPU. Un valor por encima del número de núcleos sugiere saturación.

### Señales: kill, killall, pkill

Las **señales** notifican eventos a un proceso. Las más comunes:

| Señal | Nº | Efecto |
|---|---|---|
| `SIGHUP` | 1 | *hangup*: recargar config |
| `SIGINT` | 2 | interrumpir (lo que hace Ctrl+C) |
| `SIGKILL` | 9 | matar de inmediato (no se puede capturar) |
| `SIGTERM` | 15 | terminar educadamente (por defecto) |
| `SIGSTOP` | 19 | pausar |
| `SIGCONT` | 18 | continuar tras pausa |

```bash
kill 1234               # SIGTERM al PID 1234 (cierre educado)
kill -9 1234            # SIGKILL (fuerza bruta, sin cleanup)
kill -SIGTERM 1234
kill -l                 # lista todas las señales disponibles

killall nginx           # mata por nombre (todos los nginx)
killall -u ana          # mata todos los procesos del usuario ana
pkill -f "python app.py"  # mata por patrón de línea de comandos
pkill -u ana            # por usuario
```

> Prefiere `SIGTERM` (15) antes que `SIGKILL` (9): el 15 deja al proceso guardar datos y cerrar archivos; el 9 lo mata al instante y puede dejar datos corruptos.

### Trabajos: jobs, fg, bg

En la shell, un comando puede correr en **primer plano** (bloquea el terminal) o en **segundo plano**:

```bash
sleep 100 &             # ejecuta en segundo plano, devuelve [1] PID
jobs                    # lista trabajos de esta shell
jobs -l                 # con PIDs
fg %1                   # trae el trabajo 1 a primer plano
Ctrl+Z                  # suspende el proceso en primer plano
bg %1                   # reanuda en segundo plano
disown %1               # desvincula el job (sobrevive al cerrar terminal)
nohup comando &         # ignora SIGHUP, sigue al cerrar sesión
```

> Al cerrar la terminal, se envía `SIGHUP` a los trabajos. `nohup` o `disown` evitan que mueran.

### Prioridad: nice y renice

La **nice value** va de `-20` (máxima prioridad) a `19` (mínima). Por defecto 0. Solo root puede usar valores negativos.

```bash
nice -n 10 comando      # lanza con menor prioridad (cederá CPU)
nice -n -5 comando      # mayor prioridad (solo root)
renice -n 5 -p 1234     # cambia prioridad de un PID en marcha
renice -n -10 -p 1234   # más prioritario (solo root)
renice +5 -u ana        # a todos los procesos de un usuario
```

> Útil para procesos largos (backups, compiles) que no deben estorbar al usuario: `nice -n 19 tar czf ...`.

### Demonios y systemd

Un **demonio** (*daemon*) es un proceso en segundo plano que proporciona un servicio (web, base de datos...). En las distros modernas los gestiona **systemd** (PID 1):

```bash
systemctl list-units --type=service              # servicios activos
systemctl list-unit-files --type=service         # todos (instalados)
systemctl status nginx                           # estado de un servicio
systemctl start nginx                            # arrancar ahora
systemctl stop nginx                             # parar ahora
systemctl restart nginx                          # reiniciar
systemctl reload nginx                           # recargar config sin cortar
systemctl enable nginx                           # arranca al inicio (boot)
systemctl disable nginx                          # no arrancar al inicio
systemctl is-enabled nginx                       # ¿está habilitado?
systemctl is-active nginx                        # ¿está corriendo?
systemctl mask nginx                             # prohibe arrancarlo
systemctl daemon-reload                          # tras editar un .service
```

Los archivos `.service` viven en `/etc/systemd/system/` (admin) o `/lib/systemd/system/` (paquete). Se ven en la guía 05.

### journalctl

`systemd` recoge logs centralizados con `journald`. Se consultan con `journalctl`:

```bash
journalctl                       # todos los logs (paginados)
journalctl -b                    # desde el último arranque (boot)
journalctl -b -1                 # arranque anterior
journalctl -u nginx              # de un servicio concreto
journalctl -u nginx --since today
journalctl -u nginx -f           # seguir en vivo (como tail -f)
journalctl --since "2025-05-20 10:00" --until "2025-05-20 12:00"
journalctl -p err                # solo prioridad error y superior
journalctl -p err -b             # errores desde el arranque
journalctl --no-pager            # sin paginar (para pipes/scripts)
journalctl -k                    # mensajes del kernel
journalctl --disk-usage          # cuánto ocupan los logs
sudo journalctl --vacuum-time=7d   # borrar logs de más de 7 días
```

### Memoria: free

```bash
free                      # en KB
free -h                   # legible (human): MB/GB
free -m                   # en MB
free -s 2                 # actualizar cada 2 s
```

Salida típica:

```
              total        used        free      shared  buff/cache   available
Mem:           7.7Gi       2.1Gi       1.2Gi       234Mi       4.4Gi       5.1Gi
Swap:          2.0Gi          0B       2.0Gi
```

> **`available`** es la métrica clave: indica cuánta memoria hay realmente libre para nuevas aplicaciones (incluye caché reciclable). No mires solo `free`.

### Disco: df y du

```bash
df                    # espacio de cada sistema de archivos montado
df -h                 # legible
df -h /var            # del punto de montaje concreto
df -i                 # inodos (no bytes): útil si "no quedan archivos" pero hay espacio
df -T                 # tipo de filesystem

du                    # tamaño de cada subdirectorio del actual
du -sh /var/log       # tamaño total de una ruta, legible
du -h --max-depth=1   # un nivel, legible
du -sh * | sort -h    # qué ocupa más en el directorio actual
du -sh /home/*        # tamaño de cada home
```

### Usuarios y grupos

```bash
whoami                       # tu usuario actual
id                           # uid, gid y grupos a los que perteneces
id ana                       # de otro usuario
groups                       # tus grupos
su -                         # cambiar a root (pide contraseña root)
su - ana                     # cambiar a usuario ana
sudo comando                 # ejecutar un comando como root (con tu pass)
sudo -i                      # abrir shell de root interactiva
sudo -u ana comando          # ejecutar como otro usuario
```

Archivos clave:

- **`/etc/passwd`**: lista de usuarios. Formato `usuario:x:UID:GID:comentario:home:shell`.
  ```
  ana:x:1000:1000:Ana Garcia:/home/ana:/bin/bash
  nobody:x:65534:65534:nobody:/:/usr/sbin/nologin
  ```
- **`/etc/group`**: grupos. Formato `grupo:x:GID:miembros`.
  ```
  sudo:x:27:ana,carlos
  docker:x:998:ana
  ```
- **`/etc/shadow`**: hashes de contraseñas (solo legible por root).

Crear y gestionar usuarios:

```bash
sudo useradd -m -s /bin/bash luis     # crea usuario con home y shell
sudo passwd luis                      # asignar contraseña
sudo usermod -aG docker luis          # añade al grupo docker (-aG: append group)
sudo userdel -r luis                  # borra usuario y su home
sudo groupadd devs                    # crear grupo
sudo gpasswd -d luis docker           # quitar a luis de docker
```

> Los cambios de grupo con `usermod -aG` **no aplican** hasta que el usuario abre una sesión nueva. Para no tener que reloguear en sesiones aisladas de test se usa `newgrp grupo`.

### Gestión de paquetes

Cada familia de distros tiene su gestor:

| Familia | Instalar | Buscar | Actualizar |
|---|---|---|---|
| Debian/Ubuntu | `sudo apt install nginx` | `apt search nginx` | `sudo apt update && sudo apt upgrade` |
| Red Hat/Fedora | `sudo dnf install nginx` | `dnf search nginx` | `sudo dnf upgrade` |
| Arch | `sudo pacman -S nginx` | `pacman -Ss nginx` | `sudo pacman -Syu` |

Operaciones comunes con `apt`:

```bash
sudo apt update                      # refrescar índices de paquetes
sudo apt install nginx               # instalar
sudo apt remove nginx                # desinstalar (deja config)
sudo apt purge nginx                 # desinstalar y borrar config
sudo apt upgrade                     # actualizar paquetes instalados
apt show nginx                       # info del paquete
apt list --installed                 # paquetes instalados
dpkg -L nginx                        # archivos que instaló un paquete
```

### Comandos de referencia rápida

| Comando | Qué hace |
|---|---|
| `ps aux` | listar procesos |
| `top` / `htop` | monitor dinámico |
| `kill PID` | enviar señal a un proceso |
| `killall NAME` | matar por nombre |
| `jobs` / `fg` / `bg` | gestionar trabajos |
| `nice -n N` / `renice` | prioridad |
| `systemctl status svc` | estado de un servicio |
| `journalctl -u svc` | logs de un servicio |
| `free -h` | memoria |
| `df -h` / `du -sh` | disco |
| `id` / `sudo` / `su -` | identidad y privilegios |
| `apt install` / `dnf install` | paquetes |

## Conceptos clave

- **PID vs PPID**: cada proceso tiene un padre; cuando el padre muere, los hijos quedan huérfanos y los adopta `systemd` (PID 1).
- **`SIGTERM` vs `SIGKILL`**: term es educado (permite limpiar), kill es a la fuerza.
- **`systemd` es PID 1**: gestiona servicios, montajes, red y logs centralizados con `journald`.
- **`available` ≠ `free`**: la caché se puede reclamar; mira `available` para saber memoria útil.
- **`sudo` vs `su`**: `sudo` ejecuta *un* comando como root con tu contraseña; `su -` abre una sesión root con la contraseña de root.
- **`-aG` en `usermod`**: sin `-a` reemplazas todos sus grupos por el nuevo. ¡Cuidado!

## Errores comunes

- **Matar con `kill -9` a la primera**: sin dar opción al proceso de cerrar limpiamente. Probar `kill` (TERM) primero.
- **Olvidar `sudo`** en operaciones de sistema → "Permission denied".
- **`systemctl enable` no arranca el servicio**: solo lo habilita para el boot. Haz `enable --now` para ambas cosas.
- **Mirar `free` y asustarse** al ver poca memoria "libre": Linux usa la memoria libre como caché; mira `available`.
- **Añadir a un grupo sin `-a`** (`usermod -G docker ana`): elimina al usuario de todos los demás grupos. Usa `-aG`.
- **Esperar que `usermod -aG` aplique al instante**: hay que reloguear o `newgrp`.
- **`kill PID` sin señal** y pensar que "no mata": envía `SIGTERM`, que algunos procesos ignoran. Usa `-9` solo como último recurso.
