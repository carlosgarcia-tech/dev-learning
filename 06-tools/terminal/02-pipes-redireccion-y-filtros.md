# Pipes, redirección y filtros

> stdin/stdout/stderr, pipes, redirección y herramientas de filtrado: grep, sed, awk, head, tail, sort, uniq, cut, tr, xargs.

## Flujos estándar

Todo proceso en Unix tiene tres flujos de E/S:

| Flujo | Descriptor | Por defecto |
|-------|------------|-------------|
| **stdin** (entrada estándar) | 0 | El teclado |
| **stdout** (salida estándar) | 1 | La pantalla |
| **stderr** (error estándar) | 2 | La pantalla |

```
            +-----------+
   stdin -->|           |--> stdout  (1)
   (0)      |  proceso  |
            |           |--> stderr  (2)
            +-----------+
```

## Redirección

La redirección envía los flujos a archivos en lugar de a la pantalla.

### stdout a archivo

```bash
comando > archivo          # sobrescribe
comando >> archivo         # añade al final
```

```bash
echo "hola" > saludo.txt      # saludo.txt contiene "hola"
echo "mundo" >> saludo.txt    # añade "mundo"
```

### stderr a archivo

```bash
comando 2> errores.txt     # solo stderr
comando 2>> errores.txt    # añadir
```

### stdout y stderr juntos

```bash
comando > todo.txt 2>&1    # ambos al mismo archivo
comando &> todo.txt        # abreviatura (bash)
comando >> todo.txt 2>&1   # añadir ambos
```

### Descartar salida

```bash
comando > /dev/null 2>&1   # descarta todo
comando 2>/dev/null        # descarta solo errores
```

### stdin desde archivo

```bash
comando < archivo          # el comando lee del archivo
```

```bash
sort < nombres.txt         # ordena el contenido del archivo
wc -l < archivo.txt        # cuenta líneas del archivo
```

### Here document (heredoc)

Pasa múltiples líneas a un comando:

```bash
cat << 'EOF' > config.txt
server=localhost
port=5432
user=admin
EOF
```

Sin comillas en `EOF`, se expanden variables; con `'EOF'`, no.

### Here string

Pasa una cadena como stdin:

```bash
grep "error" <<< "este es un error grave"
```

## Pipe (|)

El **pipe** conecta la salida (stdout) de un comando con la entrada (stdin) del siguiente.

```bash
comando1 | comando2 | comando3
```

```
[comando1] --stdout--> [comando2] --stdout--> [comando3]
```

### Ejemplos

```bash
ls -l | grep ".md"                # listar y filtrar
cat log.txt | grep "ERROR" | wc -l   # contar errores
ps aux | grep node                # procesos node
history | grep git                # comandos git del historial
```

### El pipe solo pasa stdout

El **stderr** no pasa por el pipe por defecto. Para incluirlo:

```bash
comando 2>&1 | grep "error"
```

## Filtros comunes

### grep

Busca líneas que coincidan con un patrón.

```bash
grep "patron" archivo
grep -i "patron" archivo          # case insensitive
grep -v "patron" archivo          # líneas que NO coinciden
grep -n "patron" archivo          # con número de línea
grep -c "patron" archivo           # contar
grep -r "patron" .                 # recursivo
grep -E "a|b" archivo              # regex extendido (EGREP)
grep -o "patron" archivo           # solo la parte que coincide
grep --color=auto "patron" file   # resaltar
```

### sed (stream editor)

Edita texto de forma no interactiva, línea a línea.

#### Sustitución

```bash
sed 's/viejo/nuevo/' archivo          # primera ocurrencia por línea
sed 's/viejo/nuevo/g' archivo         # todas las ocurrencias
sed 's/viejo/nuevo/gi' archivo        # case insensitive
sed -i 's/viejo/nuevo/g' archivo      # editar in-place (modifica el archivo)
sed -i.bak 's/viejo/nuevo/g' archivo  # in-place con backup
```

#### Otras operaciones

```bash
sed '5d' archivo               # borrar línea 5
sed '/patron/d' archivo        # borrar líneas que contienen patrón
sed -n '10,20p' archivo        # imprimir líneas 10 a 20
sed '5a\ntexto nuevo' archivo  # añadir texto después de línea 5
```

### awk

Procesa texto por campos y columnas.

```bash
awk '{print $1}' archivo          # primera columna
awk '{print $1, $3}' archivo      # columnas 1 y 3
awk -F: '{print $1}' /etc/passwd  # separador :
awk '{print NR, $0}' archivo      # número de línea + línea
awk '$3 > 100' archivo            # líneas donde columna 3 > 100
awk '{sum += $1} END {print sum}' archivo  # sumar columna 1
awk 'NR==5' archivo               # solo línea 5
awk 'NR>=10 && NR<=20' archivo    # líneas 10 a 20
```

`NR` = número de línea, `NF` = número de campos, `$0` = línea completa.

### head y tail

```bash
head -n 20 archivo           # primeras 20 líneas
tail -n 30 archivo           # últimas 30 líneas
tail -f log.txt              # seguir en vivo
tail -f log.txt | grep ERROR # filtrar en vivo
```

### sort

Ordena líneas.

```bash
sort archivo                 # alfabético
sort -r archivo              # inverso
sort -n archivo              # numérico
sort -rn archivo             # numérico inverso
sort -u archivo              # único (sin duplicados)
sort -k 2 archivo            # por columna 2
sort -t, -k 3 archivo        # separador , columna 3
```

### uniq

Elimina líneas duplicadas **consecutivas**. Suele combinarse con `sort`.

```bash
sort archivo | uniq              # líneas únicas
sort archivo | uniq -c           # contar ocurrencias
sort archivo | uniq -d           # solo duplicados
sort archivo | uniq -u           # solo únicos
sort archivo | uniq -c | sort -rn   # ordenar por frecuencia
```

### cut

Extrae campos o caracteres.

```bash
cut -d, -f1 archivo.csv       # primera columna (separador ,)
cut -d, -f1,3 archivo.csv     # columnas 1 y 3
cut -c1-10 archivo            # caracteres 1 a 10
cut -d: -f1 /etc/passwd       # usuarios del sistema
```

### tr (translate)

Traduce o elimina caracteres.

```bash
echo "Hola" | tr 'a-z' 'A-Z'       # a mayúsculas
echo "h o l a" | tr -d ' '         # eliminar espacios
echo "hola" | tr -d '\n'            # eliminar saltos de línea
echo "aaa" | tr -s 'a'             # comprimir repetidos
cat file | tr '\t' ','             # tabs a comas
```

### wc (word count)

Cuenta líneas, palabras, caracteres.

```bash
wc -l archivo       # líneas
wc -w archivo       # palabras
wc -c archivo       # caracteres (bytes)
wc -m archivo       # caracteres (unicode)
wc -L archivo       # línea más larga
```

### xargs

Toma la entrada de stdin y la pasa como argumentos a otro comando.

```bash
echo "a.txt b.txt" | xargs cat           # cat a.txt b.txt
find . -name "*.tmp" | xargs rm          # borrar todos los .tmp
find . -name "*.log" | xargs grep ERROR  # buscar en cada archivo
ls *.md | xargs -I{} wc -l {}            # contar líneas de cada .md
find . -name "*.bak" -print0 | xargs -0 rm   # nombres con espacios
```

`-0` (o `-print0`) maneja nombres con espacios o caracteres especiales.

## Combinaciones clásicas

### Top 10 IPs más frecuentes en un log

```bash
cat access.log | awk '{print $1}' | sort | uniq -c | sort -rn | head -10
```

### Buscar y reemplazar en muchos archivos

```bash
find . -name "*.js" -exec sed -i 's/foo/bar/g' {} +
```

### Contar líneas de código

```bash
find . -name "*.js" -not -path "*/node_modules/*" | xargs wc -l | tail -1
```

### Archivos modificados hoy

```bash
find . -type f -mtime -1 | sort
```

### Extraer una columna de un CSV y sumar

```bash
awk -F, '{sum += $3} END {print sum}' ventas.csv
```

### Encontrar el proceso que escucha en un puerto

```bash
lsof -i :8080 | awk 'NR==2 {print $2}'
# o
ss -tlnp | grep :8080
```

### Filtrar un log por rango de tiempo

```bash
sed -n '/10:00:00/,/11:00:00/p' server.log
```

## tee

`tee` guarda la salida en un archivo **y** la muestra en pantalla a la vez.

```bash
comando | tee archivo.txt          # guarda y muestra
comando | tee -a archivo.txt       # añade y muestra
ls -l | tee listado.txt | grep ".md"   # guarda todo y filtra
```

Útil cuando quieres ver la salida pero también guardarla, por ejemplo en CI:

```bash
npm test 2>&1 | tee test-output.log
```

## process substitution

Comparar la salida de dos comandos sin crear archivos temporales:

```bash
diff <(ls dir1) <(ls dir2)
```

`<(comando)` crea un archivo temporal virtual con la salida del comando.

## Buenas prácticas

1. **Usa `set -o pipefail`** en scripts para que un pipe falle si cualquier comando falla (no solo el último).
2. **Filtra pronto**: pon `grep` al principio del pipe para procesar menos datos.
3. **`-print0` y `-0`** para archivos con espacios.
4. **Verifica antes de `-i`**: ejecuta `sed` sin `-i` primero para ver el resultado.
5. **Combina herramientas**: cada una hace una cosa bien; el pipe las encadena.

---

> Anterior: [Fundamentos](01-fundamentos.md) · Siguiente: [Procesos y background](03-procesos-y-background.md)
