# Sistemas Operativos

> Conceptos fundamentales de sistemas operativos que todo programador debería conocer para entender cómo se ejecuta realmente su código.

## Índice

1. [Procesos](#procesos)
2. [Hilos (threads)](#hilos-threads)
3. [Planificación (scheduling)](#planificación-scheduling)
4. [Memoria virtual](#memoria-virtual)
5. [Paginación y TLB](#paginación-y-tlb)
6. [Filesystems](#filesystems)
7. [IPC (Comunicación entre procesos)](#ipc-comunicación-entre-procesos)
8. [System calls](#system-calls)
9. [Modos de ejecución](#modos-de-ejecución)
10. [Gestión de energía y recursos](#gestión-de-energía-y-recursos)

---

## Procesos

Un **proceso** es una instancia de un programa en ejecución. Incluye el código, los datos, el heap, el stack y el estado de los registros de la CPU.

### Componentes de un proceso

| Componente | Descripción |
|------------|-------------|
| Texto (código) | Instrucciones ejecutables |
| Datos | Variables globales y estáticas |
| Heap | Memoria dinámica (`malloc`, `new`) |
| Stack | Llamadas a funciones, variables locales |
| PCB (Process Control Block) | Estado, PID, contadores, punteros |

### Process Control Block (PCB)

El SO guarda por cada proceso:

- **PID** (identificador de proceso).
- Estado del proceso.
- Contador de programa (PC).
- Registros de CPU.
- Información de planificación (prioridad, colas).
- Información de memoria (tablas de páginas).
- Lista de archivos abiertos.

### Estados de un proceso

```
        [Nuevo]
           |
           v
   +--> Listo (Ready) <-----+
   |        |               |
   |        v (sched)       |
   |     Ejecución ----+    |
   |   (Running)        |   |
   |        |           |   |
   |   espera E/S       |   |
   |        v           |   |
   |    Bloqueado ------+   |
   |   (Waiting)  (E/S)      |
   |                        |
   +--- interrupción/time ---+
                 |
                 v
            [Terminado]
```

| Estado | Significado |
|--------|-------------|
| Nuevo | Creándose |
| Listo | Esperando CPU |
| Ejecución | Usando la CPU |
| Bloqueado | Esperando E/S o un evento |
| Terminado | Finalizó |

### Llamadas clave

```bash
fork()     # crea una copia del proceso actual (hijo idéntico)
exec()     # reemplaza la imagen del proceso por otro programa
wait()     # el padre espera a que un hijo termine
exit()     # termina el proceso y devuelve un código de salida
getpid()   # obtiene el PID del proceso actual
```

### Jerarquía

En Linux, todos los procesos descienden de `init` (PID 1), hoy usualmente `systemd`.

```bash
ps -ef --forest   # muestra el árbol de procesos
pstree -p         # alternativa visual
```

### Zombis y huérfanos

- **Zombi:** el hijo terminó pero el padre aún no llamó a `wait()`. El PCB queda ocupando recursos.
- **Huérfano:** el padre murió; el proceso hijo es adoptado por `init`/`systemd`.

---

## Hilos (threads)

Un **hilo** es la unidad mínima de ejecución dentro de un proceso. Los hilos de un mismo proceso comparten código, datos y heap, pero tienen su propio stack y contador de programa.

### Proceso vs Hilo

| Aspecto | Proceso | Hilo |
|---------|---------|------|
| Memoria | Independiente | Compartida |
| Creación | Costosa | Barata |
| Cambio de contexto | Lento | Rápido |
| Comunicación | IPC (pipes, sockets) | Memoria compartida |
| Aislamiento | Alto | Bajo |
| Fallos | No afectan a otros | Un hilo puede tirar todo el proceso |

### Tipos de hilos

- **Hilos a nivel de usuario:** gestionados por una biblioteca, el SO no los ve (no aprovechan multicore).
- **Hilos a nivel de kernel:** gestionados por el SO (pueden correr en varias CPUs).

### Concurrencia vs Paralelismo

- **Concurrencia:** múltiples tareas progresando (pueden alternarse en 1 CPU).
- **Paralelismo:** múltiples tareas ejecutándose al mismo tiempo en varias CPUs.

### Problemas de concurrencia

- **Condición de carrera (race condition):** el resultado depende del orden de ejecución.
- **Deadlock:** dos o más hilos se esperan mutuamente.
- **Livelock:** los hilos cambian de estado pero no progresan.

### Soluciones

- **Mutex** (exclusión mutua): solo un hilo entra a la sección crítica.
- **Semáforo:** contador con `wait`/`signal`, permite N accesos.
- **Monitor:** mutex + variables de condición (alto nivel).
- **Locks de lectura/escritura:** varios lectores o un escritor.

```
Hilo A                 Hilo B
  | -- lock(m) --        |
  |   sección crítica    |
  | -- unlock(m) --      |
  |                 -- lock(m) -- (espera si A lo tiene)
  |                 sección crítica
  |                 -- unlock(m) --
```

---

## Planificación (scheduling)

El **scheduler** decide qué proceso corre en la CPU y cuánto tiempo.

### Conceptos

- **CPU burst:** ráfaga de uso de CPU antes de una E/S.
- **Quantum:** tiempo asignado a un proceso en round-robin.
- **Preemptivo:** el SO puede quitarle la CPU al proceso.
- **No preemptivo:** el proceso corre hasta que cede la CPU.

### Métricas

| Métrica | Definición |
|---------|------------|
| Throughput | Procesos completados por unidad de tiempo |
| Tiempo de respuesta | Desde que llega hasta su primera ejecución |
| Tiempo de espera | Tiempo en cola listo |
| Tiempo de retorno (turnaround) | Desde que llega hasta que termina |

### Algoritmos clásicos

| Algoritmo | Descripción | Pros / Contras |
|-----------|-------------|----------------|
| FCFS (First Come First Served) | Por orden de llegada | Simple; el convoy effect penaliza a los cortos |
| SJF (Shortest Job First) | El más corto primero | Óptimo en espera; pero necesita conocer la duración |
| SRTF | SJF preemptivo | Mejor respuesta; mucha sobrecarga |
| Round Robin | Quantum rotativo | Justo; el quantum define latencia vs overhead |
| Prioridades | El de mayor prioridad | Riesgo de inanición (solución: aging) |
| Multilevel Feedback Queue | Múltiples colas con prioridades dinámicas | Adaptable, usado en sistemas reales |

### Round Robin (ejemplo)

Quantum = 4 ms. Llegan P1, P2, P3 con ráfagas de 10, 5, 3:

```
P1(4) P2(4) P3(3) P1(4) P2(1) P1(2)
```

### Linux: CFS (Completely Fair Scheduler)

CFS (Completely Fair Scheduler) asigna un tiempo proporcional a la prioridad (nice de -20 a +19). Mantiene un árbol rojo-negro de procesos ordenados por tiempo virtual de ejecución y elige el que menos ha corrido.

```bash
nice -n 10 ./comando      # menor prioridad
renice -n -5 -p 1234      # subir prioridad (requiere root)
```

---

## Memoria virtual

La **memoria virtual** da a cada proceso la ilusión de tener toda la memoria para sí, aislado de otros procesos, y permite usar más memoria de la físicamente disponible mediante intercambio con disco (swap).

### Espacio de direcciones de un proceso

```
Alta                                Baja
[ Stack ]   ↓ crece hacia abajo
   ...
[ Heap ]    ↑ crece hacia arriba
[ BSS ]     (globales sin inicializar)
[ Data ]    (globales inicializadas)
[ Texto ]   (código, solo lectura)
```

### Ventajas

- Aislamiento entre procesos.
- Más memoria disponible que la física.
- Carga parcial (solo se traen a RAM las páginas usadas).
- Protección: un proceso no puede acceder a la memoria de otro.

### Paginación bajo demanda

Solo se cargan las páginas en RAM cuando se acceden. Un acceso a una página no presente genera un **page fault**, el SO la trae desde disco y reanuda el proceso.

### Thrashing

Si no hay suficientes marcos físicos, el sistema pasa el tiempo intercambiando páginas entre RAM y disco (swap) y apenas hace trabajo útil. Se llama **thrashing**.

```bash
free -h          # ver uso de memoria y swap
vmstat 1         # actividad de swap y CPU
swapon --show    # dispositivos de swap activos
```

---

## Paginación y TLB

La memoria se divide en **páginas** (unidad lógica) y los marcos físicos en **frames** (unidad física) del mismo tamaño. La tabla de páginas mapea cada página virtual a un frame físico.

### Traducción de direcciones

Dirección virtual = **número de página** + **desplazamiento**.

```
Página virtual: 5      Desplazamiento: 0x1A
            |
     [Tabla de páginas]
            |
Frame físico: 12       Desplazamiento: 0x1A
-> Dirección física = 12 * tamaño_página + 0x1A
```

### TLB (Translation Lookaside Buffer)

Cada traducción requeriría acceder a la tabla en memoria. El **TLB** es una caché hardware que guarda las traducciones recientes. Un acierto en el TLB evita el acceso extra a memoria.

```
Direccion virtual
     |
   TLB ---hit---> frame físico (rapido)
     |
   miss
     |
Tabla de páginas (en RAM)
     |
frame físico
```

### Tipos de page fault

| Tipo | Causa |
|------|-------|
| Menor (minor) | Página en memoria pero no mapeada, se crea al instante |
| Mayor (major) | Hay que traerla desde disco (swap o archivo) |
| Inválido | Acceso fuera del espacio del proceso -> SIGSEGV |

### Tablas multinivel

Para no tener una tabla gigante por proceso, se usan tablas multinivel (x86-64 usa 4-5 niveles). Solo se materializan en memoria las tablas de los rangos usados.

### Multi-programación con grados de multiprogramación

A más procesos en memoria, mejor uso de CPU, pero si hay pocos frames por proceso, aumenta el page fault. Hay un punto óptimo.

---

## Filesystems

Un **filesystem** organiza cómo se almacenan y recuperan los archivos en disco.

### Estructura general

```
Superbloque        -> estado global del FS
Inodos             -> metadata de archivos (permisos, tamaño, bloques)
Bloques de datos   -> contenido real
Directorios        -> listas de nombres -> inodos
```

### Inodos

Cada archivo tiene un **inodo** con:

- Tipo y permisos.
- UID/GID propietarios.
- Tamaño y timestamps (mtime, atime, ctime).
- Contadores de enlaces.
- Punteros a bloques de datos (directos, indirectos, doble, triple).

```bash
stat archivo.txt        # muestra los datos del inodo
ls -i archivo.txt      # número de inodo
df -i                   # uso de inodos por filesystem
```

### Filesystems comunes

| FS | SO | Características |
|----|----|------------------|
| ext4 | Linux | Estable, journaling, muy usado |
| XFS | Linux | Alto rendimiento en ficheros grandes |
| Btrfs | Linux | Copy-on-write, snapshots, subvolúmenes |
| ZFS | Linux/BSD | Integridad, snapshots, pools |
| NTFS | Windows | Journaling, ACLs |
| APFS | macOS | Copy-on-write, snapshots, optimizado para SSD |
| FAT32 | Multi | Simple, límite 4 GB por archivo |
| exFAT | Multi | Para USBs, sin límite de 4 GB |

### Journaling

Antes de modificar datos, el FS escribe la operación en un **journal** (registro). Si hay un corte de energía, al arrancar se reproduce el journal en lugar de revisar todo el disco. Es mucho más rápido y seguro.

### Tipos de journaling

| Modo | Qué registra | Velocidad / Seguridad |
|------|--------------|-----------------------|
| Ordered (por defecto en ext4) | Solo metadata, datos antes | Equilibrado |
| Journal | Metadata + datos | Más seguro, más lento |
| Writeback | Solo metadata sin orden | Más rápido, menos seguro |

### Montaje y desmontaje

```bash
mount /dev/sdb1 /mnt/usb     # montar
umount /mnt/usb              # desmontar
findmnt                      # ver montajes actuales
```

---

## IPC (Comunicación entre procesos)

Los procesos están aislados en su memoria. Para comunicarse usan mecanismos de **IPC**.

| Mecanismo | Descripción | Cuándo usar |
|-----------|-------------|-------------|
| Pipes | Canal unidireccional entre procesos emparentados | `cmd | cmd` |
| Named pipes (FIFO) | Como pipe pero con nombre en el FS | Comunicación entre procesos no emparentados |
| Message queues | Cola de mensajes en kernel | Asincronía entre procesos |
| Shared memory | Región de memoria compartida | Máxima velocidad, gran volumen |
| Semaphores | Sincronización | Controlar acceso a recursos |
| Sockets | Comunicación por red o local | Entre máquinas o local |
| Signals | Notificaciones asíncronas | Eventos simples (SIGINT, SIGTERM) |

### Pipes

```bash
ls -l | grep ".md" | wc -l
```

El shell crea un pipe y conecta la stdout de `ls` con la stdin de `grep`.

### Named pipe (mkfifo)

```bash
mkfifo /tmp/micanal
echo "hola" > /tmp/micanal   # bloquea hasta que alguien lee
cat /tmp/micanal             # en otra terminal: "hola"
```

### Shared memory

Compartir memoria es lo más rápido para IPC porque no hay copia de datos, pero requiere sincronización explícita con semáforos o mutex.

### Signals

```bash
kill -SIGTERM 1234    # enviar SIGTERM
kill -9 1234          # SIGKILL (no se puede ignorar)
kill -SIGUSR1 1234    # señal de usuario
```

| Señal | Nº | Acción por defecto |
|-------|----|--------------------|
| SIGHUP | 1 | Terminar (o recargar config) |
| SIGINT | 2 | Interrumpir (Ctrl+C) |
| SIGKILL | 9 | Matar (no capturable) |
| SIGSEGV | 11 | Violación de segmento |
| SIGTERM | 15 | Terminar elegante |
| SIGSTOP | 19 | Detener (no capturable) |
| SIGCONT | 18 | Continuar |
| SIGCHLD | 17 | Hijo terminó |

### Sockets

Permiten IPC entre procesos en la misma máquina o en máquinas distintas vía red.

```bash
nc -l 8080        # escuchar en un puerto
nc 127.0.0.1 8080 # conectarse
```

---

## System calls

Las **system calls** son la interfaz entre los programas de usuario y el kernel. Un programa pide al SO que haga algo privilegiado (leer un archivo, crear un proceso, enviar por red).

### Flujo de una syscall

1. El programa llama a una función de la biblioteca C (ej: `open()`).
2. La libc pone el número de syscall en un registro y ejecuta `syscall` (instrucción que cambia a modo kernel).
3. El kernel valida argumentos y ejecuta la operación.
4. El kernel devuelve el control a modo usuario con el resultado.

```
[Modo usuario]  --syscall--> [Modo kernel] --retorno--> [Modo usuario]
```

### Syscalls comunes (Linux)

| Syscall | Función |
|---------|---------|
| `read` / `write` | Leer/escribir un descriptor de archivo |
| `open` / `close` | Abrir/cerrar archivos |
| `stat` | Obtener metadatos |
| `fork` / `exec` / `wait` | Crear y gestionar procesos |
| `pipe` / `dup2` | Pipes y redirección |
| `socket` / `bind` / `listen` / `accept` | Red |
| `mmap` / `brk` | Gestionar memoria |
| `exit` | Terminar el proceso |

### Ver syscalls en acción

```bash
strace -e trace=open,read,write ls   # qué syscalls hace `ls`
strace -c ls                         # resumen con conteo y tiempo
ltrace ./programa                    # llamadas a bibliotecas
```

### errno

Las syscalls devuelven -1 en error y ponen un código en `errno`. La tabla de errores define causas comunes: `EACCES` (permiso denegado), `ENOENT` (no existe), `EAGAIN` (intenta de nuevo), `EINTR` (interrumpido por señal).

---

## Modos de ejecución

| Modo | También llamado | Privilegios |
|------|------------------|-------------|
| Modo kernel | Supervisor, ring 0 | Acceso total al hardware |
| Modo usuario | Ring 3 | Acceso restringido, aislado |

El hardware (x86) tiene varios anillos (rings 0-3), pero la mayoría de SOs usan solo dos: kernel y usuario. Esto protege al sistema de programas con errores o maliciosos.

### Por qué importan

- Un `segfault` ocurre porque el programa intentó acceder a memoria que el kernel no le asignó, estando en modo usuario.
- Los drivers corren en modo kernel, por eso un driver con errores puede colgar todo el sistema.
- Las **syscalls** son el único puente legal entre ambos modos.

---

## Gestión de energía y recursos

- **C-states / P-states:** el SO ajusta la frecuencia y duerme cores inactivos para ahorrar energía.
- **Cgroups:** limitan y aislan recursos (CPU, memoria, E/S) por grupos de procesos. Base de los contenedores.
- **Namespaces:** aíslan la vista que un proceso tiene del sistema (montajes, red, PID, usuario). Junto a cgroups permiten los contenedores.

```bash
cat /proc/cpuinfo | grep "model name"
cat /proc/meminfo
systemd-cgtop     # uso de recursos por cgroup
```

### /proc y /sys

- `/proc` expone información de procesos y del kernel como archivos virtuales.
- `/sys` expone dispositivos y drivers del hardware.

```bash
cat /proc/1234/status    # estado del proceso 1234
cat /proc/loadavg        # carga del sistema
cat /sys/class/...       # atributos de dispositivos
```

---

## Resumen

- Un **proceso** es un programa en ejecución con su propio espacio de memoria; un **hilo** comparte memoria dentro de un proceso.
- El **scheduler** decide quién corre; Linux usa **CFS**.
- La **memoria virtual** aísla procesos y permite usar más RAM de la que hay con paginación y swap.
- El **TLB** acelera la traducción virtual→física.
- Los **filesystems** con journaling protegen los datos ante cortes.
- El **IPC** permite que procesos separados se comuniquen de muchas formas.
- Las **syscalls** son el puente controlado entre modo usuario y modo kernel.

> Siguiente: [data-structures.md](data-structures.md)
