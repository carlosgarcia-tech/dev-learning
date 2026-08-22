# Shell scripting

> Variables, control de flujo (if, for, while), funciones, arrays y exit codes en bash.

## El shebang

La primera línea de un script indica qué intérprete lo ejecuta:

```bash
#!/bin/bash
```

```bash
#!/usr/bin/env bash       # más portable
#!/usr/bin/env python3
#!/usr/bin/env node
```

## Crear y ejecutar un script

```bash
# 1. Crear el archivo
cat > hola.sh << 'EOF'
#!/bin/bash
echo "Hola, $USER"
EOF

# 2. Dar permiso de ejecución
chmod +x hola.sh

# 3. Ejecutar
./hola.sh
# o
bash hola.sh              # sin necesidad de chmod
```

## Variables

### Asignación

```bash
NOMBRE="Ada"
EDAD=36
ACTIVO=true
```

> ⚠️ **Sin espacios** alrededor del `=`. `NOMBRE = "Ada"` da error.

### Uso

```bash
echo $NOMBRE
echo "Hola, $NOMBRE"
echo "Hola, ${NOMBRE}"
echo 'Hola, $NOMBRE'      # comillas simples: sin expansión
```

| Comillas | Comportamiento |
|----------|----------------|
| `"..."` | Expande variables y `$()` |
| `'...'` | Literal, sin expansión |
| `` ` ` `` | Sustitución de comando (obsoleto) |

### Sustitución de comandos

```bash
FECHA=$(date +%Y-%m-%d)
ARCHIVOS=$(ls | wc -l)
echo "Hoy es $FECHA y hay $ARCHIVOS archivos"
```

### Variables de entorno

Las variables de entorno se heredan a los procesos hijos con `export`:

```bash
export API_KEY="sk-xxx"
node app.js               # la app puede leer process.env.API_KEY
```

Sin `export`, la variable es solo de la shell y no pasa a los hijos.

### Variables especiales

| Variable | Significado |
|----------|-------------|
| `$0` | Nombre del script |
| `$1`...`$9` | Argumentos posicionales |
| `$#` | Número de argumentos |
| `$@` | Todos los argumentos (como lista) |
| `$*` | Todos los argumentos (como una cadena) |
| `$?` | Exit code del último comando |
| `$$` | PID del script actual |
| `$!` | PID del último proceso en background |

### Leer entrada del usuario

```bash
read -p "¿Cómo te llamas? " nombre
echo "Hola, $nombre"

read -s -p "Contraseña: " pass     # oculta la entrada
read -a nums                        # leer a un array
```

## Exit codes

Cada comando devuelve un **código de salida** (exit code):

- `0` = éxito.
- Distinto de `0` = error (el valor indica el tipo).

```bash
ls /no-existe
echo $?                    # 2 (error)
ls /tmp
echo $?                    # 0 (éxito)
```

### exit

Termina el script con un exit code:

```bash
exit 0          # éxito
exit 1          # error genérico
exit 2          # error de uso
```

## if

### Sintaxis básica

```bash
if [ "$EDAD" -ge 18 ]; then
  echo "Mayor de edad"
elif [ "$EDAD" -eq 17 ]; then
  echo "Casi mayor"
else
  echo "Menor"
fi
```

### test: corchetes

`[ ]` es un comando `test`. Sus operadores:

#### Enteros

| Operador | Significado |
|----------|-------------|
| `-eq` | Igual |
| `-ne` | Distinto |
| `-lt` | Menor |
| `-le` | Menor o igual |
| `-gt` | Mayor |
| `-ge` | Mayor o igual |

#### Strings

| Operador | Significado |
|----------|-------------|
| `=` o `==` | Igual |
| `!=` | Distinto |
| `-z` | Vacío |
| `-n` | No vacío |
| `<` | Menor (lex) |
| `>` | Mayor (lex) |

#### Archivos

| Operador | Significado |
|----------|-------------|
| `-f` | Es archivo regular |
| `-d` | Es directorio |
| `-e` | Existe |
| `-r` | Legible |
| `-w` | Escribible |
| `-x` | Ejecutable |
| `-s` | No vacío (tamaño > 0) |

#### Lógicos

```bash
if [ -f archivo ] && [ -r archivo ]; then
  echo "Existe y es legible"
fi

if [ "$A" = "1" ] || [ "$A" = "2" ]; then
  echo "A es 1 o 2"
fi
```

### [[ ]]: bash extendido

`[[ ]]` es más potente (solo bash), permite regex y operadores lógicos sin escapar:

```bash
if [[ "$email" =~ ^[a-z]+@[a-z]+\.[a-z]+$ ]]; then
  echo "Email válido"
fi
```

### Operadores lógicos cortocircuitados

```bash
[ -f archivo ] && echo "existe"   # si existe, imprimir
[ -f archivo ] || echo "no existe"  # si no existe, imprimir
```

## for

### Iterar una lista

```bash
for fruta in manzana pera plátano; do
  echo "Me gusta la $fruta"
done
```

### Iterar archivos

```bash
for archivo in *.md; do
  echo "Procesando $archivo"
  wc -l "$archivo"
done
```

### Rango numérico

```bash
for i in {1..5}; do
  echo "Iteración $i"
done

for i in {1..10..2}; do      # de 2 en 2
  echo $i
done
```

### Estilo C

```bash
for ((i=0; i<5; i++)); do
  echo $i
done
```

## while

### Básico

```bash
CONTADOR=0
while [ $CONTADOR -lt 5 ]; do
  echo "Contador: $CONTADOR"
  ((CONTADOR++))
done
```

### Leer líneas de un archivo

```bash
while IFS= read -r linea; do
  echo "Línea: $linea"
done < archivo.txt
```

`IFS=` evita recortar espacios, `-r` evita interpretar backslashes.

### until

```bash
until [ -f /tmp/listo ]; do
  echo "Esperando..."
  sleep 1
done
echo "¡Listo!"
```

## case

```bash
read -p "Opción (s/n): " respuesta

case "$respuesta" in
  s|S|si|SI)
    echo "Sí"
    ;;
  n|N|no|NO)
    echo "No"
    ;;
  *)
    echo "Opción no válida"
    ;;
esac
```

## Funciones

### Definir y llamar

```bash
saludar() {
  echo "Hola, $1"
}

saludar "Ada"              # Hola, Ada
saludar "Grace"            # Hola, Grace
```

### Con return

`return` devuelve un exit code, no un valor:

```bash
es_par() {
  if [ $(($1 % 2)) -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

if es_par 4; then
  echo "Es par"
fi
```

### Devolver valores

Para devolver un string, se imprime y se captura:

```bash
mayusculas() {
  echo "$1" | tr 'a-z' 'A-Z'
}

RESULTADO=$(mayusculas "hola")
echo $RESULTADO            # HOLA
```

### Variables locales

```bash
mi_funcion() {
  local x=10               # local, no afecta al exterior
  echo $x
}

x=5
mi_funcion                  # 10
echo $x                     # 5 (no cambió)
```

## Arrays

### Crear y acceder

```bash
frutas=("manzana" "pera" "plátano")

echo "${frutas[0]}"          # manzana
echo "${frutas[1]}"          # pera
echo "${frutas[@]}"          # todos
echo "${#frutas[@]}"         # número de elementos: 3
echo "${#frutas[0]}"         # longitud del primer elemento
```

### Modificar

```bash
frutas[0]="uva"              # asignar
frutas+=("naranja")          # añadir
unset frutas[1]              # borrar (deja hueco)
frutas=("${frutas[@]}")      # reindexar tras unset
```

### Iterar

```bash
for f in "${frutas[@]}"; do
  echo "Fruta: $f"
done
```

### Arrays asociativos (bash 4+)

```bash
declare -A edades
edades[Ada]=36
edades[Grace]=85

echo "${edades[Ada]}"        # 36
echo "${!edades[@]}"         # claves: Ada Grace
```

## Argumentos

```bash
#!/bin/bash
# args.sh

echo "Script: $0"
echo "Argumentos: $#"
echo "Todos: $@"
echo "Primero: $1"
echo "Segundo: $2"

shift                        # descarta $1, el resto sube
echo "Tras shift: $1"
```

```bash
./args.sh a b c
# Script: ./args.sh
# Argumentos: 3
# Todos: a b c
# Primero: a
# Segundo: b
# Tras shift: b
```

### Procesar opciones con getopts

```bash
#!/bin/bash
while getopts "u:p:" opt; do
  case $opt in
    u) USER=$OPTARG ;;
    p) PASS=$OPTARG ;;
    \?) echo "Opción inválida" ;;
  esac
done

echo "Usuario: $USER"
```

```bash
./script.sh -u admin -p secreto
```

## Errores y robustez

### set -e

Falla el script si cualquier comando falla:

```bash
set -e
mkdir /no/existe            # falla y el script termina
echo "esto no se ejecuta"
```

### set -u

Falla si se usa una variable no definida:

```bash
set -u
echo "$NO_DEFINIDA"         # error
```

### set -o pipefail

Hace que un pipe devuelva el código del primer comando que falle:

```bash
set -o pipefail
grep patron archivo | sort   # si grep falla, el pipe falla
```

### set -x (debug)

Imprime cada comando antes de ejecutarlo:

```bash
set -x
NOMBRE="Ada"
echo "Hola $NOMBRE"
# + NOMBRE=Ada
# + echo 'Hola Ada'
```

### La combinación recomendada

```bash
#!/bin/bash
set -euo pipefail
```

- `e`: fallar en errores.
- `u`: fallar en variables no definidas.
- `o pipefail`: fallos en pipes.

## Trampas (trap)

Ejecutar código al salir o recibir una señal:

```bash
cleanup() {
  echo "Limpiando..."
  rm -f /tmp/mi-temporal
}

trap cleanup EXIT             # al salir del script
trap cleanup INT              # al recibir Ctrl+C
trap '' INT                   # ignorar Ctrl+C
```

Útil para limpiar archivos temporales o restaurar estado.

## Ejemplo completo

```bash
#!/bin/bash
set -euo pipefail

BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d)

log() {
  echo "[$(date '+%H:%M:%S')] $*"
}

crear_backup() {
  local src=$1
  local dest="$BACKUP_DIR/${src##*/}-$DATE.tar.gz"
  tar -czf "$dest" "$src"
  log "Backup de $src en $dest"
}

if [ $# -eq 0 ]; then
  echo "Uso: $0 <directorio...>"
  exit 1
fi

for dir in "$@"; do
  if [ -d "$dir" ]; then
    crear_backup "$dir"
  else
    log "Aviso: $dir no es un directorio, saltando" >&2
  fi
done

log "Backup completado"
```

## Buenas prácticas

1. **Empieza con `set -euo pipefail`** para scripts robustos.
2. **Usa `local`** en funciones para evitar contaminar el scope.
3. **Quota variables**: `"$VAR"` evita problemas con espacios.
4. **Usa `[[ ]]`** en bash para más features.
5. **Valida argumentos** al inicio y muestra uso si faltan.
6. **Usa funciones** para organizar y reutilizar.
7. **Añade comentarios** explicando la lógica no obvia.

---

> Anterior: [Procesos y background](03-procesos-y-background.md) · Siguiente: [tmux y productividad](05-tmux-y-productividad.md)
