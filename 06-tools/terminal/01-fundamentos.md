# Fundamentos de la terminal

> Qué es la shell, el prompt, comandos básicos, navegación y manipulación de archivos.

## ¿Qué es la terminal?

Cuando abres "la terminal", en realidad estás usando varios conceptos distintos:

| Concepto | Qué es |
|----------|--------|
| **Terminal** | El programa que muestra texto (la ventana) |
| **Shell** | El intérprete que procesa tus comandos (bash, zsh) |
| **Prompt** | El texto que te indica que puedes escribir |
| **Comando** | El programa que ejecutas |

La shell más común en Linux es **bash**; en macOS es **zsh** desde Catalina.

## El prompt

El prompt es el texto que aparece al inicio de una línea esperando un comando.

```
usuario@maquina:~/proyecto$
```

- `usuario`: tu nombre de usuario.
- `maquina`: el nombre del host.
- `~/proyecto`: el directorio actual (`~` es tu home).
- `$`: indica una shell de usuario normal (`#` sería root).

### Personalización

El prompt se define en la variable `PS1`. En bash:

```bash
export PS1="\u@\h:\w\$ "
# \u = usuario, \h = host, \w = directorio actual
```

Para personalización permanente, se pone en `~/.bashrc` (bash) o `~/.zshrc` (zsh).

## Comandos básicos de navegación

### pwd (print working directory)

Muestra el directorio actual.

```bash
pwd
# /home/usuario/proyecto
```

### cd (change directory)

Cambia de directorio.

```bash
cd /home/usuario           # ruta absoluta
cd proyecto                 # ruta relativa
cd ..                       # subir un nivel
cd ../..                    # subir dos niveles
cd ~                        # ir al home
cd                          # igual que cd ~
cd -                        # volver al directorio anterior
```

### Rutas absolutas y relativas

| Tipo | Característica | Ejemplo |
|------|----------------|---------|
| Absoluta | Empieza por `/` | `/home/usuario/docs` |
| Relativa | Relativa al directorio actual | `docs/notas.txt` |
| Home | Empieza por `~` | `~/descargas` |

- `.` es el directorio actual.
- `..` es el directorio padre.

### ls (list)

Lista el contenido de un directorio.

```bash
ls                  # lista básica
ls -l               # formato largo (permisos, tamaño, fecha)
ls -a               # incluye archivos ocultos (empiezan por .)
ls -la              # largo + ocultos
ls -lh              # tamaños legibles (KB, MB)
ls -lt              # ordenado por fecha (más reciente primero)
ls -ltr             # por fecha, más antiguo primero
ls -R               # recursivo (subdirectorios)
ls *.md             # solo archivos .md
```

### Salida de ls -l

```
-rw-r--r--  1 usuario grupo  4096 ene 12 10:30 archivo.txt
drwxr-xr-x  2 usuario grupo  4096 ene 12 10:31 carpeta
```

| Campo | Significado |
|-------|-------------|
| `-rw-r--r--` | Tipo y permisos |
| `1` | Número de enlaces |
| `usuario` | Propietario |
| `grupo` | Grupo |
| `4096` | Tamaño en bytes |
| `ene 12 10:30` | Fecha de modificación |
| `archivo.txt` | Nombre |

El primer carácter es el tipo: `-` archivo, `d` directorio, `l` symlink.

## Manipulación de archivos

### mkdir (make directory)

```bash
mkdir nueva-carpeta
mkdir -p a/b/c             # crea padres si no existen
mkdir dir1 dir2 dir3       # varios a la vez
```

### touch

Crea un archivo vacío o actualiza su timestamp.

```bash
touch archivo.txt          # crea si no existe
touch a.txt b.txt c.txt    # varios
```

### cp (copy)

```bash
cp origen.txt destino.txt
cp archivo.txt copia.txt
cp -r carpeta/ copia-carpeta/   # recursivo (para directorios)
cp -i archivo.txt destino.txt    # pregunta antes de sobrescribir
cp -v *.txt /backup/             # verbose (muestra qué copia)
```

### mv (move)

Mueve o renombra.

```bash
mv viejo.txt nuevo.txt      # renombrar
mv archivo.txt /otra/ruta/  # mover
mv -i a.txt b.txt           # pregunta antes de sobrescribir
mv *.jpg imagenes/          # mover todos los jpg
```

### rm (remove)

Borra archivos o directorios.

```bash
rm archivo.txt
rm -i archivo.txt           # pide confirmación
rm -r carpeta/              # recursivo (borra directorio y contenido)
rm -f archivo.txt           # force (no falla si no existe)
rm -rf carpeta/             # recursivo + force (¡cuidado!)
```

> ⚠️ `rm -rf` no pide confirmación y borra todo. Úsalo con cuidado, especialmente con rutas como `/`.

### rmdir

Borra un directorio **vacío**.

```bash
rmdir carpeta-vacia
```

## Ver contenido de archivos

### cat

Muestra todo el contenido de un archivo.

```bash
cat archivo.txt
cat a.txt b.txt             # concatena varios
cat -n archivo.txt          # con números de línea
```

### less

Paginador: muestra el contenido de forma interactiva.

```bash
less archivo.txt
```

Dentro de less:

| Tecla | Acción |
|-------|--------|
| `Espacio` / `f` | Avanzar página |
| `b` | Retroceder página |
| `↑` / `↓` | Scroll línea |
| `/texto` | Buscar |
| `n` / `N` | Siguiente/anterior búsqueda |
| `g` / `G` | Inicio / fin |
| `q` | Salir |

### head y tail

Muestran el principio o el final de un archivo.

```bash
head archivo.txt            # primeras 10 líneas
head -n 20 archivo.txt      # primeras 20 líneas
tail archivo.txt            # últimas 10 líneas
tail -n 50 archivo.txt      # últimas 50 líneas
tail -f log.txt             # sigue el archivo (muestra líneas nuevas)
tail -f log.txt | grep ERROR   # filtra en vivo
```

`tail -f` es fundamental para ver logs en tiempo real.

## Búsqueda de archivos

### find

Busca archivos por nombre, tipo, tamaño, fecha, etc.

```bash
find . -name "*.md"                 # por nombre
find /var/log -name "*.log"         # en una ruta concreta
find . -type f -name "*.js"         # solo archivos
find . -type d -name "node_modules" # solo directorios
find . -size +10M                   # más grandes de 10MB
find . -mtime -7                    # modificados en los últimos 7 días
find . -name "*.tmp" -delete        # borrar lo encontrado
find . -name "*.js" -exec wc -l {} \;  # ejecutar comando en cada resultado
```

### locate

Busca en un índice precompilado (más rápido pero no en tiempo real).

```bash
locate archivo.txt
sudo updatedb              # actualizar el índice
```

## Búsqueda dentro de archivos

### grep

Busca texto dentro de archivos.

```bash
grep "error" log.txt               # líneas con "error"
grep -i "error" log.txt            # case insensitive
grep -r "TODO" .                   # recursivo
grep -n "function" src/app.js     # con número de línea
grep -v "debug" log.txt            # líneas que NO contienen
grep -c "error" log.txt           # contar ocurrencias
grep -E "foo|bar" file            # regex extendido
grep --color=auto "patron" file   # resaltar coincidencias
```

## Información del sistema

```bash
whoami                     # tu usuario
hostname                   # nombre de la máquina
date                       # fecha y hora
uptime                     # tiempo encendida
df -h                      # espacio en disco
du -sh carpeta/            # tamaño de una carpeta
free -h                    # memoria RAM
uname -a                   # info del kernel
lscpu                      # info de CPU
```

## Permisos

### chmod

Cambia permisos de archivos.

```bash
chmod +x script.sh         # añadir ejecutable
chmod 755 script.sh        # rwxr-xr-x
chmod 644 archivo.txt      # rw-r--r--
chmod -R 755 carpeta/      # recursivo
```

### Notación numérica

Cada dígito representa usuario, grupo, otros.

| Número | Permisos |
|--------|----------|
| 7 | rwx |
| 6 | rw- |
| 5 | r-x |
| 4 | r-- |
| 0 | --- |

### chown

Cambia el propietario.

```bash
sudo chown usuario archivo.txt
sudo chown usuario:grupo archivo.txt
sudo chown -R usuario carpeta/
```

## Alias

Los alias son atajos para comandos largos.

```bash
alias ll='ls -lah'
alias gs='git status'
alias ..='cd ..'
alias ...='cd ../..'
```

Para que sean permanentes, añádelos a `~/.bashrc` o `~/.zshrc`.

```bash
source ~/.bashrc           # recargar configuración
```

## Historial

```bash
history                    # mostrar historial
!100                       # ejecutar comando 100 del historial
!!                         # ejecutar último comando
sudo !!                    # ejecutar último como root
!git                       # último comando que empieza por git
Ctrl+R                     # búsqueda inversa interactiva
```

### Ctrl+R (búsqueda inversa)

Pulsa `Ctrl+R` y empieza a escribir; busca en el historial hacia atrás. Pulsa `Ctrl+R` repetidamente para más resultados.

## Comodines (globbing)

| Patrón | Significado |
|--------|-------------|
| `*` | Cualquier cadena |
| `?` | Un carácter cualquiera |
| `[abc]` | Uno de esos caracteres |
| `[a-z]` | Rango |
| `{a,b,c}` | Expansión |

```bash
ls *.md                    # todos los .md
ls archivo?.txt            # archivo1.txt, archivo2.txt...
ls [abc]*.txt              # archivos que empiezan por a, b o c
mkdir {src,dist,docs}     # crea las tres carpetas
```

## Atajos de teclado

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` | Inicio de línea |
| `Ctrl+E` | Fin de línea |
| `Ctrl+U` | Borrar hasta el inicio |
| `Ctrl+K` | Borrar hasta el final |
| `Ctrl+W` | Borrar palabra anterior |
| `Ctrl+R` | Búsqueda inversa |
| `Ctrl+L` | Limpiar pantalla |
| `Ctrl+C` | Interrumpir comando |
| `Ctrl+D` | Cerrar sesión / EOF |
| `Tab` | Autocompletar |

## Ayuda integrada

```bash
man ls                     # manual
ls --help                  # ayuda rápida
tldr ls                     # ejemplos (requiere tldr)
info coreutils             # info de GNU
```

## Buenas prácticas

1. **Aprende los atajos**: `Ctrl+R`, `Ctrl+A/E`, `Tab`.
2. **Usa `--help` y `man`** cuando no recuerdes una opción.
3. **Cuidado con `rm -rf`**: revisa la ruta antes de pulsar Enter.
4. **Alias para lo repetitivo**: `ll`, `gs`, `..`.
5. **`tail -f` para logs**: fundamental en desarrollo.
6. **`find` y `grep` son tus amigos**: localizan cualquier cosa.

---

> Siguiente: [Pipes, redirección y filtros](02-pipes-redireccion-y-filtros.md)
