# 01 — Fundamentos de Linux

## Objetivos

- [ ] Entender qué es Linux (el *kernel*), qué es una distribución y en qué se diferencian.
- [ ] Distinguir entre terminal, *shell* y *prompt* y usarlos con soltura.
- [ ] Navegar el sistema de archivos con `pwd`, `cd` y `ls`.
- [ ] Crear, copiar, mover y borrar archivos y directorios (`mkdir`, `rmdir`, `cp`, `mv`, `rm`, `touch`).
- [ ] Diferenciar rutas absolutas y relativas y usar `.` y `..`.
- [ ] Consultar ayuda con `man` y la opción `--help`.
- [ ] Acelerar el trabajo con *tab completion* e histórico de comandos.
- [ ] Usar comodines de *globbing* (`*`, `?`, `[...]`).
- [ ] Comprender las expansiones de Bash (`~`, `$(...)`, llaves, variables).
- [ ] Crear y gestionar *alias*.

## Apuntes

### ¿Qué es Linux?

**Linux** es, en sentido estricto, un **núcleo** (*kernel*): el programa que gestiona el hardware (CPU, memoria, discos, red) y deja que las aplicaciones se ejecuten sobre él. Lo creó **Linus Torvalds** en 1991. En el día a día, cuando decimos "Linux" nos referimos a un **sistema operativo completo** formado por el *kernel* + herramientas GNU + un gestor de paquetes + aplicaciones, lo que técnicamente se llama **distribución** (GNU/Linux).

| Concepto | Qué es | Ejemplo |
|---|---|---|
| *Kernel* | Núcleo que habla con el hardware | `uname -r` muestra `6.5.0-...` |
| *Shell* | Intérprete de comandos (la "línea de comandos") | `bash`, `zsh`, `fish` |
| Terminal | El programa que muestra la *shell* en pantalla | GNOME Terminal, `tmux`, `xterm` |
| Distribución | *Kernel* + herramientas + paquetes empaquetados | Ubuntu, Debian, Fedora, Arch |

#### Distribuciones más usadas

| Familia | Distros | Gestor de paquetes | Uso típico |
|---|---|---|---|
| Debian | Ubuntu, Linux Mint, Pop!_OS | `apt` / `dpkg` | Escritorio, servidores, principiantes |
| Red Hat | Fedora, RHEL, Rocky, AlmaLinux | `dnf` / `rpm` | Servidores empresariales |
| Arch | Arch, Manjaro, EndeavourOS | `pacman` | Usuarios avanzados, *rolling release* |
| SUSE | openSUSE, SLES | `zypper` | Europa, empresa |

> En esta guía los comandos son universales; los de paquetes (`apt`/`dnf`/`pacman`) se ven en la guía 03.

### Terminal, shell y prompt

La **terminal** es la ventana negra. Dentro de ella se ejecuta una **shell**, normalmente **Bash** (Bourne Again Shell). La shell muestra el **prompt** (el texto que te invita a escribir):

```bash
usuario@maquina:~/proyectos$       # prompt típico de Ubuntu/Debian
[usuario@maquina ~]$               # prompt típico de Fedora/RHEL
```

Partes del prompt `usuario@maquina:~/proyectos$`:

- `usuario` — quién eres.
- `maquina` — nombre del equipo.
- `~/proyectos` — directorio actual (`~` = tu *home*).
- `$` — usuario normal (`#` sería *root*).

Para saber qué *shell* usas:

```bash
echo $SHELL        # /bin/bash
ps -p $$           # muestra el proceso de tu shell actual
```

### Comandos básicos de navegación

```bash
pwd                 # Print Working Directory: dónde estás
cd /etc             # cambia al directorio /etc (absoluta)
cd Documentos       # entra en Documentos (relativa)
cd ..               # sube un nivel
cd .                # se queda en el mismo sitio (directorio actual)
cd ~                # va a tu home
cd                  # sin argumentos: también va a tu home
cd -                # vuelve al directorio anterior
```

`ls` lista el contenido. Opciones más útiles:

```bash
ls                  # lista archivos y carpetas
ls -l               # formato largo (permisos, tamaño, fecha...)
ls -a               # incluye ocultos (empiezan por .)
ls -la              # largo + ocultos
ls -lh              # tamaños legibles (K, M, G)
ls -lt              # ordenados por modificación (más nuevos primero)
ls -ltr             # por modificación, inverso (más viejos primero)
ls -R               # recursivo (subdirectorios)
ls -1               # un elemento por línea
ls /etc /home       # lista varios directorios a la vez
```

La primera letra de `ls -l` indica el tipo: `-` archivo, `d` directorio, `l` enlace simbólico.

### Crear, copiar, mover y borrar

```bash
touch archivo.txt            # crea archivo vacío (o actualiza fecha)
mkdir proyecto               # crea un directorio
mkdir -p a/b/c               # crea toda la ruta de directorios padres
cp archivo.txt copia.txt     # copia un archivo
cp -r carpeta copia_carpeta  # copia un directorio (¡necesario -r!)
mv archivo.txt ../otro.txt  # mueve (o renombra si destino igual)
mv viejo.txt nuevo.txt      # renombrar
rm archivo.txt              # borra un archivo (¡sin papelera!)
rm -i archivo.txt           # pide confirmación
rm -r carpeta               # borra un directorio y su contenido
rm -rf carpeta              # forzado, sin preguntar (¡peligroso!)
rmdir carpeta_vacia         # solo borra directorios vacíos
```

> ⚠️ `rm` no manda a la papelera: **borra definitivamente**. Especialmente cuidadoso con `rm -rf /` o rutas con `*`. Siempre `ls` antes de `rm` para confirmar.

### Rutas absolutas y relativas

| Tipo | Empieza por | Ejemplo | Cuándo |
|---|---|---|---|
| Absoluta | `/` | `/home/ana/docs` | Desde la raíz, inequívoca |
| Relativa | sin `/` | `docs` o `../docs` | Desde el directorio actual |

Atajos:

- `.` — directorio actual.
- `..` — directorio padre.
- `~` — tu *home* (`/home/usuario`).
- `-` — directorio anterior.

```bash
cd /var/log                 # absoluta
cd ../log                   # relativa: sube y entra en log
cd ~/Descargas              # usa ~ como atajo al home
```

### Ayuda: man y --help

Casi todos los comandos tienen dos vías de ayuda:

```bash
man ls                      # manual completo (navega con flechas, q para salir)
man man                     # cómo usar el propio man
ls --help                    # resumen rápido en una pantalla
help cd                     # para "builtins" de bash (cd, echo, export...)
man 5 crontab               # man de la sección 5 (formatos de fichero)
```

Secciones de `man` habituales: `1` comandos de usuario, `5` formatos de fichero, `8` administración. Para buscar un *keyword*:

```bash
man -k copiar               # equivalente a apropos copiar
man -f ls                   # equivalente a whatis ls
```

### Tab completion e histórico

El **tabulador** autocompleta comandos y rutas. Una pulsación completa si es único; dos muestran opciones:

```bash
cd Do<TAB>                  # completa "Documentos"
cd /etc/pas<TAB>            # completa "/etc/passwd"
ls *.t<TAB><TAB>            # muestra archivos .txt, .tar...
```

El **histórico** guarda los comandos escritos (en `~/.bash_history`):

```bash
history                     # lista el histórico numerado
!123                        # ejecuta el comando 123 del histórico
!!                          # repite el último comando (¡útil con sudo!)
sudo !!                     # repite el último comando como root
!cd                         # último comando que empieza por cd
Ctrl+R                      # búsqueda inversa interactiva
Ctrl+P / Ctrl+N             # comando anterior / siguiente
```

### Caracteres comodín (globbing)

La *shell* expande los comodines **antes** de ejecutar el comando, generando una lista de nombres:

| Comodín | Significado | Ejemplo | Expande |
|---|---|---|---|
| `*` | cualquier cadena (incluso vacía) | `*.txt` | `a.txt`, `nota.txt` |
| `?` | un único carácter | `foto?.jpg` | `foto1.jpg`, `fotoA.jpg` |
| `[abc]` | uno de los listados | `data[12].csv` | `data1.csv`, `data2.csv` |
| `[a-z]` | rango | `log_[a-c]` | `log_a`, `log_b`, `log_c` |
| `[!abc]` o `[^abc]` | ninguno de los listados | `*[!.]` | sin extensión |

```bash
ls *.log                     # todos los .log
ls 2024-0?-*                 # meses 01..09
ls informe_[123].txt        # informe_1.txt, _2, _3
cp *.jpg /backup/fotos/      # copiar todos los jpg
```

> Si ningún archivo coincide, `*` queda literal y muchos comandos fallan. `shopt -s nullglob` hace que no se expanda (uso avanzado).

### Expansiones de Bash

Bash realiza varias expansiones antes de ejecutar un comando:

```bash
echo ~                       # /home/ana  (tilde = home del usuario)
echo $USER                   # ana  (variable)
echo "Hola $USER"            # Hola ana  (dobles comillas: expande)
echo 'Hola $USER'            # Hola $USER  (comillas simples: literal)
echo $(date +%F)             # 2025-05-20  (sustitución de comando)
echo "Hoy es $(date +%A)"   # Hoy es martes

echo {lun,mar,mie}           # lun mar mie  (expansión de llaves)
echo {1..5}                  # 1 2 3 4 5
echo {a..e}                  # a b c d e
mkdir proyecto/{src,docs,tests}   # crea 3 directorios de golpe
```

Tabla resumen de comillas:

| Comillas | Comportamiento |
|---|---|
| `"dobles"` | Expanden variables y `$(...)` |
| `'simples'` | Literal, no expanden nada |
| `` `comillas invertidas` `` | Sustitución de comando (forma vieja; usa `$(...)`) |

### Alias

Un **alias** es un atajo para un comando o secuencia:

```bash
alias                       # lista todos los alias definidos
alias ll='ls -lah'         # define un alias
ll                          # ejecuta ls -lah
alias grep='grep --color=auto'
```

Los alias definidos en la terminal **se pierden al cerrar la sesión**. Para hacerlos persistentes, añádelos a `~/.bashrc` (o `~/.bash_aliases`):

```bash
echo "alias ll='ls -lah'" >> ~/.bashrc
source ~/.bashrc            # recarga la configuración
```

Quitar un alias:

```bash
unalias ll
```

### Comandos de referencia rápida

| Comando | Qué hace |
|---|---|
| `pwd` | directorio actual |
| `cd DIR` | cambiar de directorio |
| `ls [opciones] [ruta]` | listar contenido |
| `mkdir [-p] DIR` | crear directorio |
| `touch ARCHIVO` | crear archivo vacío |
| `cp [-r] ORIG DEST` | copiar |
| `mv ORIG DEST` | mover/renombrar |
| `rm [-rf] ARCHIVO` | borrar |
| `rmdir DIR` | borrar directorio vacío |
| `man COMANDO` | manual |
| `COMANDO --help` | ayuda rápida |
| `alias` / `unalias` | gestionar alias |
| `history` | histórico de comandos |

## Conceptos clave

- **Kernel vs distribución**: el *kernel* es el motor; la *distro* es el coche entero (motor + chasis + extras).
- **Todo es un archivo**: en Linux, discos, procesos (`/proc`), dispositivos (`/dev`) y red se representan como archivos.
- **Sensibilidad a mayúsculas**: `Archivo.txt` y `archivo.txt` son distintos.
- **La shell expande, el comando recibe**: `*.txt` lo resuelve Bash, no `ls`. Por eso `echo *` funciona igual que `ls *`.
- **Espacios en nombres**: hay que escaparlos o entrecomillar: `cd "Mis Documentos"` o `cd Mis\ Documentos`.
- **Ocultos**: los archivos que empiezan por `.` solo se ven con `ls -a`. Tu `.bashrc` está ahí.

## Errores comunes

- **`rm archivo *`** (espacio antes del `*`): borra `archivo` **y** todo lo del directorio. Cuidado con el espacio.
- **Olvidar `-r` en `cp`/`rm` de directorios**: "omitting directory 'carpeta'".
- **`cd~/Descargas`** sin espacio: la tilde no se expande pegada a otra cosa; usa `cd ~/Descargas`.
- **Confundir `.` y `..`**: `.` es aquí, `..` es el padre.
- **Borrar con `rm` pensando que hay papelera**: no la hay por defecto. Considera `trash-cli` si lo necesitas.
- **`cd` dentro de un script**: cada comando se ejecuta en su propia subshell salvo `source`; los `cd` no afectan al padre.
- **No citar variables con espacios**: `cp $archivo dest/` falla si `archivo="mi archivo.txt"`. Usa `cp "$archivo" dest/`.
