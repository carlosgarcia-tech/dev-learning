# Procesos y background

> Gestión de procesos, trabajos en background, fg, bg, nohup, kill, top, ps y señales.

## ¿Qué es un proceso?

Un **proceso** es un programa en ejecución. Cada proceso tiene:

- **PID** (Process ID): identificador único.
- **PPID** (Parent PID): el proceso que lo creó.
- Estado (running, sleeping, stopped, zombie).
- Usuario propietario.

## ps: listar procesos

```bash
ps                          # procesos de la sesión actual
ps aux                      # todos los procesos (formato BSD)
ps -ef                      # todos los procesos (formato System V)
ps aux | grep node          # filtrar
ps -u usuario               # procesos de un usuario
ps -p 1234                  # un proceso concreto
```

### Salida de ps aux

```
USER  PID  %CPU %MEM    VSZ   RSS  TTY  STAT  START  TIME  COMMAND
root    1   0.0  0.1  169848  6700  ?   Ss   ene12   0:10  /sbin/init
user 1234   2.5  1.2  555672 25080  ?   Sl   10:00   0:05  node app.js
```

| Campo | Significado |
|-------|-------------|
| USER | Usuario propietario |
| PID | ID del proceso |
| %CPU | Uso de CPU |
| %MEM | Uso de memoria |
| RSS | Memoria física usada |
| STAT | Estado (R=running, S=sleeping, Z=zombie) |
| COMMAND | Comando ejecutado |

## top y htop

### top

Monitor de procesos en tiempo real.

```bash
top
```

Dentro de top:

| Tecla | Acción |
|-------|--------|
| `P` | Ordenar por CPU |
| `M` | Ordenar por memoria |
| `N` | Ordenar por PID |
| `k` | Matar un proceso (pid) |
| `r` | Cambiar prioridad (renice) |
| `q` | Salir |
| `1` | Ver CPUs individuales |

### htop

Versión mejorada y más visual de top.

```bash
htop                    # si está instalado
```

Permite scroll horizontal, matar con F9, ordenar con F6, etc.

### Alternativas modernas

- **btop**: muy visual y configurable.
- **glances**: monitor completo del sistema.
- **procs**: moderna y colorida.

## Estados de un proceso

| Estado | Letra | Significado |
|--------|-------|-------------|
| Running | R | En ejecución o esperando CPU |
| Sleeping | S | Esperando un evento (E/S) |
| Stopped | T | Detenido (señal o debug) |
| Zombie | Z | Terminó pero el padre no lo recogió |

## Ejecución en background

### El operador &

Lanza un comando en segundo plano y devuelve el control inmediatamente.

```bash
sleep 100 &
# [1] 12345   <- job 1, PID 12345
```

- `[1]` es el **job ID** (número de trabajo en la shell).
- `12345` es el **PID** (identificador del proceso).

### jobs

Lista los trabajos de la sesión actual.

```bash
jobs
# [1]-  Running                 sleep 100 &
# [2]+  Running                 node server.js &
```

### fg (foreground)

Trae un trabajo a primer plano.

```bash
fg                 # el último (el con +)
fg %1              # job 1
fg %2              # job 2
```

### bg (background)

Reanuda un trabajo detenido, en segundo plano.

```bash
bg                 # el trabajo actual
bg %1              # job 1
```

### Suspender un proceso

`Ctrl+Z` detiene (suspende) el proceso en foreground y lo pasa a background detenido:

```bash
node server.js
# Ctrl+Z
# [1]+  Stopped                 node server.js
bg %1              # reanudar en background
# o
fg %1              # traerlo de nuevo al frente
```

## nohup

`nohup` (no hangup) hace que un proceso **sobreviva al cierre de la terminal**. Normalmente, al cerrar la terminal, se envía SIGHUP a los procesos hijos y terminan.

```bash
nohup node server.js &
# nohup: ignoring input and appending output to 'nohup.out'
```

- La salida va a `nohup.out` (o redirígela).
- El proceso sigue corriendo aunque cierres la terminal.

```bash
nohup node server.js > app.log 2>&1 &
```

### disown

Alternativa a `nohup`: separa un job ya en marcha de la shell.

```bash
node server.js &
# Ctrl+Z, bg
disown %1
```

Ahora puedes cerrar la terminal sin que muera.

## kill y señales

### kill

Envía señales a procesos.

```bash
kill 1234                  # SIGTERM por defecto (cierre elegante)
kill -15 1234              # SIGTERM explícito
kill -9 1234               # SIGKILL (forzado, no capturable)
kill -l                    # listar señales disponibles
kill -HUP 1234             # SIGHUP (recargar config)
kill -USR1 1234            # SIGUSR1 (definida por la app)
```

### killall y pkill

Matan procesos por nombre.

```bash
killall node              # todos los procesos "node"
pkill -f "node server"    # por patrón completo
pkill -u usuario          # todos los procesos del usuario
```

### Señales importantes

| Señal | Nº | Acción por defecto | Se puede capturar |
|-------|----|--------------------|-------------------|
| SIGHUP | 1 | Terminar (o recargar) | Sí |
| SIGINT | 2 | Interrumpir (Ctrl+C) | Sí |
| SIGQUIT | 3 | Terminar + core dump | Sí |
| SIGKILL | 9 | Matar inmediatamente | **No** |
| SIGSEGV | 11 | Violación de segmento | Sí |
| SIGTERM | 15 | Terminar elegante | Sí |
| SIGSTOP | 19 | Detener | **No** |
| SIGCONT | 18 | Continuar | Sí |
| SIGCHLD | 17 | Hijo terminó | Sí |

### Orden de cierre

1. `SIGTERM` (kill o kill -15): pedirle que cierre ordenadamente.
2. Esperar unos segundos.
3. Si no cierra, `SIGKILL` (kill -9): forzar (el proceso no puede evitarlo).

> `kill -9` es el último recurso: el proceso no puede limpiar recursos ni guardar estado.

## Prioridades: nice y renice

Cada proceso tiene una prioridad (nice value) de -20 (más prioritario) a 19 (menos prioritario).

```bash
nice -n 10 comando          # lanzar con prioridad baja
nice -n -5 comando          # más prioritario (requiere root)
renice -n 5 -p 1234         # cambiar la prioridad de un proceso
renice -n -10 -p 1234       # subir prioridad (requiere root)
```

```bash
top                          # dentro de top, pulsa 'r' para renice
```

## monitorización continua

### watch

Ejecuta un comando cada N segundos y muestra el resultado.

```bash
watch -n 1 date             # cada 1 segundo
watch -n 2 ls -l             # cada 2 segundos
watch -n 5 'ls -l | wc -l'  # contar archivos cada 5s
watch -d free -h            # resaltar cambios
```

### tail -f para logs

```bash
tail -f /var/log/syslog
tail -f app.log | grep ERROR
```

## Comandos de sistema útiles

```bash
uptime                      # tiempo encendida y carga
free -h                     # memoria
df -h                       # disco
du -sh *                    # tamaño de cada carpeta
lsof -i :8080               # quién usa el puerto 8080
ss -tlnp                    # puertos a la escucha
netstat -tulpn              # alternativa (obsoleta)
```

### Load average

`uptime` y `top` muestran el **load average**: tres números que representan la carga media en los últimos 1, 5 y 15 minutos.

```
load average: 0.50, 0.45, 0.30
```

- Si es menor que el número de CPUs, el sistema está holgado.
- Si es mayor, hay procesos esperando.

## systemctl (servicios)

En sistemas con systemd, los servicios se gestionan con `systemctl`:

```bash
systemctl status nginx         # estado
systemctl start nginx          # arrancar
systemctl stop nginx           # parar
systemctl restart nginx        # reiniciar
systemctl reload nginx         # recargar config
systemctl enable nginx         # arranque automático
systemctl disable nginx        # desactivar arranque
systemctl list-units --type=service   # listar servicios
journalctl -u nginx -f         # ver logs del servicio en vivo
```

## Ejemplos prácticos

### Lanzar un servidor y dejarlo corriendo

```bash
# Método 1: nohup
nohup node server.js > server.log 2>&1 &

# Método 2: tmux (ver guía 05)
tmux new -s server
node server.js
# Ctrl+B D para detach

# Método 3: systemd service (más robusto)
```

### Matar todos los procesos node

```bash
pkill -f node
killall node
```

### Encontrar y matar el proceso de un puerto

```bash
kill $(lsof -t -i:8080)
# o
fuser -k 8080/tcp
```

### Ver los 5 procesos que más CPU usan

```bash
ps aux --sort=-%cpu | head -6
```

## Buenas prácticas

1. **Usa `SIGTERM` primero**, `SIGKILL` solo si no responde.
2. **`nohup` o `tmux`** para procesos que deben sobrevivir al cierre de terminal.
3. **`htop` o `btop`** para monitorizar cómodamente.
4. **No mates procesos del sistema** sin saber qué hacen.
5. **`systemctl`** para servicios, no `kill` directo.

---

> Anterior: [Pipes, redirección y filtros](02-pipes-redireccion-y-filtros.md) · Siguiente: [Shell scripting](04-shell-scripting.md)
