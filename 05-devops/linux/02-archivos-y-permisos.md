# 02 — Archivos y permisos

## Objetivos

- [ ] Entender la jerarquía del sistema de archivos (FHS) y los directorios clave.
- [ ] Leer archivos con `cat`, `less`, `head` y `tail`.
- [ ] Buscar archivos con `find` y `locate`, y buscar contenido con `grep`.
- [ ] Interpretar y modificar permisos `rwx` con `chmod` (simbólico y octal).
- [ ] Cambiar propietario y grupo con `chown` y `chgrp`.
- [ ] Entender `umask` y cómo se aplican los permisos por defecto.
- [ ] Crear enlaces simbólicos y duros con `ln`.
- [ ] Conocer los permisos especiales *sticky bit*, SUID y SGID.
- [ ] Manejar atributos extendidos con `chattr`/`lsattr`.

## Apuntes

### El sistema de archivos jerárquico (FHS)

Linux sigue el **Filesystem Hierarchy Standard (FHS)**: un único árbol que empieza en la raíz `/`. No hay "unidades" C: o D: como en Windows; todo cuelga de `/`.

| Directorio | Contenido | Ejemplo |
|---|---|---|
| `/` | raíz del árbol | — |
| `/bin` | binarios esenciales de usuario | `ls`, `cat`, `cp` |
| `/sbin` | binarios de administración | `fdisk`, `reboot` |
| `/boot` | kernel y gestor de arranque | `vmlinuz`, `grub` |
| `/etc` | archivos de configuración | `passwd`, `hosts` |
| `/home` | directorios personales de usuarios | `/home/ana` |
| `/root` | home del superusuario | — |
| `/var` | datos variables (logs, caches, colas) | `/var/log`, `/var/lib` |
| `/tmp` | temporales (se borran al reiniciar) | — |
| `/usr` | programas y librerías de usuario | `/usr/bin`, `/usr/lib` |
| `/opt` | software opcional de terceros | `/opt/google` |
| `/dev` | dispositivos como archivos | `/dev/sda`, `/dev/null` |
| `/proc` | info del kernel y procesos (virtual) | `/proc/cpuinfo` |
| `/sys` | info de hardware (virtual) | `/sys/class` |

> En distribuciones modernas `/bin`, `/sbin`, `/lib` suelen ser enlaces a `/usr/bin`, `/usr/sbin`, `/usr/lib` (*merged /usr*).

### Leer archivos

```bash
cat archivo.txt                 # imprime todo de golpe
cat -n archivo.txt              # con números de línea
cat a.txt b.txt > unido.txt     # concatena y redirige

less archivo.log                # visor paginado (q salir, / buscar, n siguiente)
head archivo.txt                # primeras 10 líneas
head -n 20 archivo.txt          # primeras 20 líneas
tail archivo.log                # últimas 10 líneas
tail -n 50 archivo.log          # últimas 50
tail -f /var/log/syslog         # sigue el archivo en vivo (logs)
tail -f archivo.log | grep ERROR # filtra en tiempo real
```

`less` es el visor interactivo ideal para archivos largos. Atajos: `Espacio` (página abajo), `b` (atrás), `g` (inicio), `G` (final), `/patrón` (buscar), `n`/`N` (siguiente/anterior coincidencia), `q` (salir).

### Buscar archivos: find y locate

`find` busca **recorriendo** el sistema en el momento, con muchos criterios:

```bash
find . -name "*.log"                  # por nombre (en directorio actual)
find /var/log -name "*.log"           # por nombre, ruta concreta
find . -iname "README*"               # insensible a mayúsculas
find . -type f -name "*.sh"          # solo archivos regulares
find . -type d -name "src"           # solo directorios
find . -type l                       # solo enlaces simbólicos
find . -mtime -1                     # modificados en menos de 24h
find . -mtime +7                     # modificados hace más de 7 días
find . -size +10M                    # mayores de 10 MB
find . -size -1k                     # menores de 1 KB
find . -empty                        # vacíos (archivos o directorios)
find . -name "*.tmp" -delete         # ¡borra lo encontrado!
find . -name "*.sh" -exec chmod +x {} \;   # ejecuta comando sobre cada resultado
find . -name "*.log" -exec grep ERROR {} +      # más eficiente (agrupa)
find . -name "*.txt" | wc -l         # contar resultados
```

Tipos con `-type`: `f` archivo, `d` directorio, `l` enlace, `b` bloque, `c` carácter.

`locate` busca en una **base de datos preindexada** (mucho más rápido, pero puede estar desactualizado):

```bash
locate passwd                # instantáneo
sudo updatedb                # actualiza la base de datos
```

### Buscar contenido: grep

`grep` imprime líneas que coinciden con un patrón:

```bash
grep "error" app.log
grep -i "error" app.log              # insensible a mayúsculas
grep -v "DEBUG" app.log              # líneas que NO contienen DEBUG (inverso)
grep -n "error" app.log              # con número de línea
grep -c "error" app.log              # solo cuenta coincidencias
grep -r "TODO" .                     # recursivo por directorios
grep -rn "TODO" --include=*.py .     # recursivo, solo .py, con línea
grep -E "ERROR|WARN" app.log         # regex extendida (OR)
grep -A 2 "error" app.log            # 2 líneas Después (After)
grep -B 2 "error" app.log            # 2 líneas Antes (Before)
grep -C 2 "error" app.log            # 2 líneas de contexto (Before+After)
grep --color=auto "error" app.log     # resalta coincidencias
```

### Permisos rwx

Al hacer `ls -l` cada entrada tiene 10 caracteres:

```
-rwxr-xr--   1  ana  staff   2048  may 20 10:00  script.sh
└┬┘└─┬─┘└─┬─┘
 │   │    └─ otros (others)
 │   └───── grupo (group)
 └───────── propietario (user)
└── tipo (- archivo, d directorio, l enlace)
```

Cada triada `rwx` significa, para archivos:

| Permiso | Archivo | Directorio |
|---|---|---|
| `r` (4) | leer contenido | listar (`ls`) |
| `w` (2) | modificar contenido | crear/borrar archivos dentro |
| `x` (1) | ejecutar | entrar y atravesar (`cd`) |

> En directorios, el bit `x` es imprescindible para poder acceder a su contenido. Un directorio con `r--` deja ver nombres pero no entrar; con `--x` deja entrar si conoces el nombre pero no listar.

### chmod: simbólico y octal

**Modo simbólico** — indica a quién (`u` usuario, `g` grupo, `o` otros, `a` todos) y qué hacer (`+` añadir, `-` quitar, `=` asignar exacto):

```bash
chmod +x script.sh               # ejecutable para todos (a+x)
chmod u+x script.sh              # solo al propietario
chmod g-w archivo                # quita escritura al grupo
chmod u=rwx,g=rx,o=r archivo     # asigna exactamente
chmod a-wx carpeta               # quita escritura y ejecución a todos
chmod -R 755 carpeta/            # recursivo
```

**Modo octal** — tres dígitos (usuario, grupo, otros) en base 4+2+1:

| Octal | rwx | Permiso |
|---|---|---|
| `7` | `rwx` | todo |
| `6` | `rw-` | leer/escribir |
| `5` | `r-x` | leer/ejecutar |
| `4` | `r--` | solo leer |
| `0` | `---` | ninguno |

```bash
chmod 755 script.sh      # rwxr-xr-x (típico de ejecutables y directorios)
chmod 644 archivo.txt    # rw-r--r-- (típico de archivos)
chmod 600 secreto.key    # rw------- (solo propietario)
chmod 700 ~/.ssh         # rwx------ (tu .ssh)
chmod 777 publico/       # rwxrwxrwx (¡evítalo salvo excepciones!)
```

Truco mental: `7=4+2+1=rwx`, `6=4+2=rw-`, `5=4+1=r-x`. Suma siempre el `r` (4), `w` (2) y `x` (1) que quieres.

### chown y chgrp

```bash
sudo chown ana archivo.txt          # cambia el propietario
sudo chown ana:devs archivo.txt     # propietario y grupo a la vez
sudo chgrp devs archivo.txt         # solo el grupo
sudo chown -R ana:devs proyecto/    # recursivo
```

Para cambiar de grupo, el usuario debe pertenecer a ese grupo (o ser *root*).

### umask

`umask` son los permisos que **se quitan** por defecto al crear archivos/carpetas. Los archivos se crean sin `x` (modo `666`), los directorios con `x` (modo `777`):

```bash
umask                  # 0022 típico
# Archivo nuevo:   666 & ~022 = 644  (rw-r--r--)
# Directorio nuevo: 777 & ~022 = 755  (rwxr-xr-x)

umask 077              # más privado: archivos 600, directorios 700
umask 002              # colaborativo: mismo grupo puede escribir
```

Para hacerlo persistente: añade `umask 022` a `~/.bashrc`.

### Enlaces: simbólicos y duros

`ln` crea enlaces entre archivos:

```bash
ln -s original.txt enlace_sim.txt     # simbólico (-s)
ln original.txt enlace_duro.txt      # duro (sin -s)
```

| Característica | Enlace simbólico (`-s`) | Enlace duro |
|---|---|---|
| Parecido a | un "acceso directo" | una copia de la entrada del inodo |
| Atraviesa sistemas de archivos | sí | no (mismo sistema de archivos) |
| Si se borra el original | queda roto (dangling) | sigue funcionando |
| Apunta a | ruta (nombre) | inodo (datos reales) |
| `ls -l` muestra | `enlace -> original` | archivo normal |
| Enlaces a directorios | sí | no (normalmente) |

```bash
ln -s /var/log/app.log ~/app.log      # acceso rápido a un log
ls -l ~/app.log                       # lrwxrwxrwx ... app.log -> /var/log/app.log
readlink ~/app.log                    # muestra el destino
```

### Permisisos especiales: sticky bit, SUID, SGID

Hay un cuarto dígito en `chmod` para permisos especiales:

| Permiso | Octal | Símbolo | Dónde aparece | Efecto |
|---|---|---|---|---|
| **SUID** | `4000` | `u+s` | en ejecutables | Se ejecuta con los privilegios del **propietario** del archivo, no del que lo lanza. Ej.: `passwd` |
| **SGID** | `2000` | `g+s` | en ejecutables/dirs | En ejecutables: con privilegios del grupo. En directorios: los archivos nuevos heredan el grupo del directorio |
| **Sticky bit** | `1000` | `+t` | en directorios | Solo el propietario del archivo (o del dir, o root) puede borrarlo, aunque el directorio sea escribible por todos. Ej.: `/tmp` |

```bash
chmod u+s programa              # SUID: -rwsr-xr-x
chmod g+s carpeta_compartida   # SGID: drwxr-sr-x
chmod +t /tmp                  # sticky: drwxrwxrwt

chmod 4755 programa            # SUID + 755
chmod 2775 carpeta            # SGID + 775
chmod 1777 /tmp               # sticky + 777
```

> `/tmp` tiene `drwxrwxrwt` (1777): todos pueden escribir, pero solo el dueño puede borrar sus propios archivos. Por eso es seguro compartirlo.

### Atributos extendidos (chattr / lsattr)

Algunos sistemas de archivos (ext4, xfs) soportan atributos que van más allá de `rwx`:

```bash
sudo chattr +i archivo.txt       # inmutable: ni root puede borrarlo hasta quitar +i
sudo chattr +a log.txt           # append-only: solo se puede añadir al final
lsattr archivo.txt               # ver atributos
sudo chattr -i archivo.txt       # quitar inmutable
```

`+i` es muy útil para proteger configuraciones críticas; `+a` se usa en logs de auditoría.

### Comandos de referencia rápida

| Comando | Qué hace |
|---|---|
| `cat ARCH` | mostrar contenido |
| `less ARCH` | paginar |
| `head -n N ARCH` | primeras N líneas |
| `tail -f ARCH` | últimas líneas en vivo |
| `find RUTA -name "*x"` | buscar por nombre |
| `locate PATRÓN` | buscar en índice |
| `grep "patrón" ARCH` | buscar texto |
| `chmod MODO ARCH` | cambiar permisos |
| `chown user:group ARCH` | cambiar dueño |
| `umask` | máscara por defecto |
| `ln -s ORIG ENLACE` | enlace simbólico |
| `chattr +i ARCH` | inmutable |

## Conceptos clave

- **Todo cuelga de `/`**: una sola raíz, sin letras de unidad.
- **`rwx` significa cosas distintas en archivos y directorios**: el `x` de directorio es "poder entrar".
- **Octal es suma**: `7=4+2+1`, `6=4+2`, `5=4+1`. Practica hasta que salga automático.
- **SUID/SGID/sticky** son el 4º dígito: `chmod 4755` = SUID + `755`.
- **Enlaces duros vs simbólicos**: el duro comparte inodo (sobrevive al borrado del original); el simbólico es solo un puntero a una ruta.
- **`/tmp` es `1777`**: todos escriben, nadie borra lo ajeno.

## Errores comunes

- **`chmod 777` por pereza**: abre el archivo a todo el mundo. Usa el mínimo necesario (`640`, `644`, `755`).
- **Olvidar `-R` en `chmod`/`chown`** cuando querías aplicar a todo un árbol.
- **Quitar `x` a un directorio** y luego no entender por qué no puedes `cd` dentro ni leer archivos.
- **`find` sin `-type` y sin entrecomillar patrón**: sorpresas si hay espacios.
- **`ln` sin `-s`**: crea un enlace duro sin avisar; si esperabas un simbólico, se comporta distinto.
- **`locate` desactualizado**: ejecuta `sudo updatedb`.
- **Borrar el archivo original de un enlace simbólico**: el enlace queda "roto" (`ls` lo marca en rojo).
- **`chattr +i` y no acordarse**: luego no puedes ni borrar el archivo como root hasta `chattr -i`.
