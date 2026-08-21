# 04 — Red y shell scripting

## Objetivos

- [ ] Consultar y configurar la red con `ip`, `ping`, `curl` y `wget`.
- [ ] Inspeccionar puertos y conexiones con `ss` y `netstat`.
- [ ] Resolver nombres con `dig` y `nslookup`.
- [ ] Usar SSH con claves (`ssh-keygen`, `ssh-copy-id`, `scp`, `rsync`).
- [ ] Configurar un firewall básico con `ufw` y conocer `iptables`.
- [ ] Escribir scripts en Bash: variables, argumentos, sustitución de comandos.
- [ ] Usar control de flujo: `if`, `for`, `while`, `case`.
- [ ] Definir funciones y arrays en Bash.
- [ ] Gestionar exit codes y tests con `test` / `[ ]` / `[[ ]]`.
- [ ] Combinar comandos con *pipes*, redirección de stdin/stdout/stderr, `tee` y `xargs`.
- [ ] Manejar `awk` y `sed` a nivel básico para procesar texto.

## Apuntes

### Red: ip, ping, curl, wget

`ip` (de `iproute2`) sustituye al viejo `ifconfig`:

```bash
ip addr                 # IPs de todas las interfaces (abreviado ip a)
ip a show eth0          # de una interfaz
ip link                 # interfaces y su estado (up/down)
ip route                # tabla de rutas (puerta de enlace)
ip route get 8.8.8.8     # qué ruta se usa para llegar a 8.8.8.8
ip -s link               # estadísticas de tráfico
```

`ping` comprueba conectividad ICMP:

```bash
ping 8.8.8.8             # ping infinito (Ctrl+C para parar)
ping -c 4 8.8.8.8        # 4 paquetes y para
ping -i 0.5 host         # cada 0.5 s (requiere root para <1 s)
```

`curl` transfiere datos por HTTP/HTTPS y muchos más protocolos:

```bash
curl https://ejemplo.com                       # imprime el HTML
curl -o archivo.html https://ejemplo.com        # guarda a archivo
curl -O https://ejemplo.com/foto.jpg            # guarda con su nombre remoto
curl -I https://ejemplo.com                     # solo cabeceras
curl -s https://api.com/users                   # silencioso (sin progreso)
curl -X POST -d '{"a":1}' -H "Content-Type: application/json" https://api.com
curl -w "%{http_code}\n" -o /dev/null -s https://ejemplo.com   # solo código HTTP
```

`wget` descarga archivos de forma robusta (reanuda, recursivo):

```bash
wget https://ejemplo.com/archivo.tar.gz
wget -c https://ejemplo.com/archivo.iso          # continuar descarga interrumpida
wget -q https://ejemplo.com/script.sh -O - | bash  # descargar y ejecutar
wget -r -l 2 https://ejemplo.com                 # descarga recursiva (2 niveles)
```

### Puertos y conexiones: ss y netstat

`ss` (*socket statistics*) sustituye a `netstat`:

```bash
ss                      # todas las conexiones
ss -t                   # TCP
ss -u                   # UDP
ss -l                   # sockets a la escucha (listening)
ss -tlnp                # TCP a la escucha, numérico, con PID/programa
ss -tlnp | grep :80     # ¿quién ocupa el puerto 80?
ss -t state established  # conexiones establecidas
ss -s                   # resumen estadístico
```

| Flag | Significado |
|---|---|
| `-t` | TCP |
| `-u` | UDP |
| `-l` | escucha (listening) |
| `-n` | numérico (sin resolver DNS) |
| `-p` | proceso (requiere root) |
| `-a` | todos |

`netstat` aún aparece en sistemas antiguos: `netstat -tlnp` equivale a `ss -tlnp`.

### DNS: dig y nslookup

```bash
dig ejemplo.com                        # registro A (IPv4)
dig @8.8.8.8 ejemplo.com               # usa ese servidor DNS
dig ejemplo.com MX                     # registros de correo
dig ejemplo.com TXT                    # registros TXT
dig +short ejemplo.com                 # solo la IP
dig -x 8.8.8.8                         # resolución inversa (IP → nombre)
dig ejemplo.com ANY                    # todos los registros

nslookup ejemplo.com                  # consulta básica
nslookup ejemplo.com 8.8.8.8           # usando un DNS concreto
```

`/etc/resolv.conf` indica los servidores DNS del sistema, y `/etc/hosts` permite sobreescribir nombres localmente:

```bash
cat /etc/resolv.conf
# nameserver 192.168.1.1
# nameserver 8.8.8.8

cat /etc/hosts
# 127.0.0.1 localhost
# 127.0.1.1 miportatil
# 192.168.1.10 midns.local midns
```

### SSH: claves, scp, rsync

```bash
ssh usuario@host                        # conexión interactiva
ssh -p 2222 usuario@host                # puerto distinto
ssh usuario@host "uptime"               # ejecuta comando remoto y sale

ssh-keygen -t ed25519 -C "ana@portatil" # genera par de claves
# clave privada: ~/.ssh/id_ed25519
# clave pública:  ~/.ssh/id_ed25519.pub

ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@host   # copia tu clave pública
```

Tras copiar la clave pública, ya no hace falta contraseña. Permisos críticos: `~/.ssh` → `700`, `~/.ssh/authorized_keys` → `600`.

`scp` copia archivos entre hosts por SSH:

```bash
scp archivo.txt usuario@host:/tmp/                    # local → remoto
scp usuario@host:/var/log/syslog .                    # remoto → local
scp -r carpeta/ usuario@host:/tmp/                    # recursivo
scp -P 2222 archivo.txt usuario@host:                  # puerto distinto
```

`rsync` sincroniza directorios eficientemente (solo transfiere lo cambiado):

```bash
rsync -av carpeta/ usuario@host:/backup/carpeta/      # local → remoto
rsync -av --delete src/ dest/                          # borra en dest lo que no está en src
rsync -avz carpeta/ usuario@host:/backup/              # -z comprime en tránsito
rsync -av --exclude='*.log' src/ usuario@host:/dest/   # excluye patrones
rsync -aP carpeta/ usuario@host:/dest/                 # muestra progreso y reanuda
```

> La barra final importa: `carpeta/` copia *el contenido* de `carpeta`; `carpeta` (sin `/`) copia *el directorio* carpeta dentro del destino.

### Firewall: ufw e iptables

**ufw** (Uncomplicated Firewall) es el front-end amigable en Ubuntu/Debian:

```bash
sudo ufw status                        # estado
sudo ufw enable                         # activar (¡cuidado con bloquearte SSH!)
sudo ufw allow 22/tcp                   # permitir puerto 22
sudo ufw allow 80/tcp                   # HTTP
sudo ufw allow 443/tcp                  # HTTPS
sudo ufw allow from 192.168.1.0/24 to any port 3306   # solo desde una red
sudo ufw deny 3306                      # bloquear
sudo ufw delete allow 80/tcp            # quitar regla
sudo ufw status verbose                 # detalle
```

**iptables** es la herramienta de bajo nivel (disponible en cualquier Linux):

```bash
sudo iptables -L                    # listar reglas
sudo iptables -L -n -v              # numérico y verboso
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT   # permitir SSH
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT   # permitir HTTP
sudo iptables -A INPUT -j DROP      # denegar el resto (política por defecto)
sudo iptables -F                    # flush: borrar todas las reglas
```

> `iptables` no es persistente tras reinicio salvo que lo guardes (`iptables-save` / `iptables-persistent`). `ufw` sí.

### Shell scripting con Bash

Un script Bash empieza con un *shebang* que indica el intérprete:

```bash
#!/usr/bin/env bash
set -euo pipefail      # buenas prácticas: aborta ante errores
echo "Hola"
```

Ejecutar un script:

```bash
chmod +x script.sh      # hacerlo ejecutable
./script.sh             # ejecutar
bash script.sh           # ejecutar sin chmod
```

#### Variables

```bash
nombre="Ana"                       # sin espacios alrededor del =
edad=30                            # sin $ al asignar
echo "Hola $nombre, $edad años"   # con $ al leer
fruta="manzana"
echo "Tengo una ${fruta}s"         # llaves para delimitar el nombre
readonly PI=3.14                   # constante
```

Tipos: en Bash todo son strings, salvo que se evalúe como entero con `(( ))`:

```bash
x=5
(( x++ ))                           # x = 6
(( x = x * 2 ))                     # x = 12
echo $(( 2 + 3 ))                   # 5
```

#### Argumentos y parámetros especiales

```bash
./script.sh a b c
# $0 = ./script.sh   $1 = a   $2 = b   $3 = c
# $# = 3 (nº de args)   $@ = "a" "b" "c"   $* = "a b c"
echo "Script: $0, primer arg: $1, total: $#"
```

#### Sustitución de comandos

```bash
hoy=$(date +%F)                    # captura salida de un comando
fecha=`date +%F`                   # forma vieja (mejor usar $())
files=$(ls *.txt | wc -l)
echo "Hoy es $hoy, hay $files .txt"
```

#### Entrada del usuario

```bash
read -p "Nombre: " nombre          # lee de teclado
read -s -p "Contraseña: " pass    # -s: oculta lo que escribes
echo "Hola $nombre"
```

#### if then else

```bash
if [ "$edad" -ge 18 ]; then
  echo "Mayor de edad"
elif [ "$edad" -eq 17 ]; then
  echo "Casi"
else
  echo "Menor"
fi
```

`test` y `[ ]` — comparaciones:

| Expresión | Cierto si |
|---|---|
| `[ -f archivo ]` | existe y es archivo regular |
| `[ -d dir ]` | existe y es directorio |
| `[ -r archivo ]` / `-w` / `-x` | tiene permiso r/w/x |
| `[ -z "$var" ]` | la variable está vacía |
| `[ -n "$var" ]` | la variable NO está vacía |
| `[ "$a" = "$b" ]` | strings iguales |
| `[ "$a" != "$b" ]` | strings distintos |
| `[ "$a" -eq "$b" ]` | enteros iguales |
| `[ "$a" -lt "$b" ]` / `-le` / `-gt` / `-ge` / `-ne` | enteros |
| `[ ! cond ]` | negación |
| `[ a -a b ]` | AND (no recomendado; usa `&&`) |
| `[[ ... ]]` | versión mejorada: soporta `&&`, `\|\|`, `=~` regex |

```bash
# Forma moderna recomendada
if [[ -f config.yml && $USER == "admin" ]]; then ...
# Regex
if [[ "$email" =~ ^[a-z]+@[a-z]+\.[a-z]+$ ]]; then echo "email válido"; fi
```

#### Bucles for

```bash
for i in 1 2 3; do echo $i; done
for f in *.txt; do echo "Procesando $f"; done
for i in {1..5}; do echo $i; done
for (( i=0; i<5; i++ )); do echo $i; done

# recorrer líneas de un archivo
while IFS= read -r linea; do
  echo "Línea: $linea"
done < archivo.txt
```

#### while

```bash
count=1
while [ $count -le 3 ]; do
  echo "Intento $count"
  (( count++ ))
done

# bucle infinito con break
while true; do
  read -p "¿Salir? (s/n): " r
  [[ "$r" == "s" ]] && break
done
```

#### case

```bash
case "$1" in
  start)   echo "Arrancando";;
  stop)    echo "Parando";;
  restart) echo "Reiniciando";;
  status)  echo "OK";;
  *)       echo "Uso: $0 {start|stop|restart|status}"; exit 1;;
esac
```

#### Funciones

```bash
saludar() {
  local nombre="$1"           # local: no contamina el scope
  echo "Hola $nombre"
}
saludar "Ana"                 # llamada

# con return (exit code 0-255, no string)
es_par() {
  local n="$1"
  [[ $((n % 2)) -eq 0 ]]
}
if es_par 4; then echo "par"; fi
```

#### Arrays

```bash
frutas=("manzana" "pera" "uva")
echo "${frutas[0]}"            # manzana
echo "${frutas[@]}"            # todos
echo "${#frutas[@]}"           # 3 (longitud)
frutas+=("kiwi")              # añadir
for f in "${frutas[@]}"; do echo "$f"; done

# array asociativo (Bash 4+)
declare -A edades
edades[ana]=30
edades[carlos]=25
echo "${edades[ana]}"
for k in "${!edades[@]}"; do echo "$k: ${edades[$k]}"; done
```

#### Exit codes

Cada comando devuelve un **exit code**: `0` = éxito, `1-255` = error.

```bash
ls /noexiste
echo $?                       # 2 (error de ls)
ls /tmp
echo $?                       # 0 (éxito)

# usar en if
if grep -q "error" app.log; then
  echo "había errores"
fi

# encadenar
mkdir dir && cd dir           # el segundo solo si el primero va bien
cd /tmp || exit 1             # salir si falla
```

`set -e` hace que el script aborte al primer comando que falle; `set -u` trata variables sin definir como error; `set -o pipefail` propaga fallos en pipes.

### Pipes y redirección

Cada proceso tiene 3 flujos estándar:

| Flujo | Descriptor | Por defecto |
|---|---|---|
| stdin | 0 | teclado |
| stdout | 1 | pantalla |
| stderr | 2 | pantalla |

```bash
comando > salida.txt            # redirige stdout a archivo (sobrescribe)
comando >> salida.txt           # añade (append)
comando 2> errores.txt          # redirige stderr
comando > out.txt 2> err.txt    # stdout y stderr por separado
comando > todo.txt 2>&1        # stderr al mismo sitio que stdout
comando &> todo.txt            # equivalente (Bash 4+)
comando < entrada.txt          # stdin desde archivo
comando <<< "texto"            # stdin desde string (here-string)
```

**Pipe** `|`: salida de uno → entrada del siguiente:

```bash
cat archivo | grep error | wc -l
ps aux | sort -k3 -rn | head -10    # top 10 por CPU
ls -la | less
```

**tee**: escribe en un archivo **y** también a stdout:

```bash
comando | tee salida.txt        # guarda y muestra
comando | tee -a salida.txt     # añade
comando 2>&1 | tee log.txt      # stdout+stderr guardados y mostrados
```

**xargs**: construye comandos a partir de la entrada estándar:

```bash
echo "a b c" | xargs            # a b c (separado por espacios)
ls *.txt | xargs rm             # borrar todos los .txt (cuidado)
find . -name "*.bak" | xargs rm
find . -name "*.log" | xargs grep "ERROR"
find . -name "*.txt" -print0 | xargs -0 grep "patrón"   # nombres con espacios
echo "1 2 3" | xargs -n1 echo   # uno por línea
```

> `-0` (junto con `find -print0`) es **imprescindible** cuando los nombres pueden tener espacios o saltos de línea.

### awk y sed básicos

**awk** procesa texto por columnas/campos:

```bash
echo "ana 30" | awk '{print $1}'          # ana  (1ª columna)
echo "ana 30" | awk '{print $2}'          # 30
ps aux | awk '{print $1, $3}'            # usuario y %CPU
df -h | awk '{print $1, $5}'             # dispositivo y uso
ls -l | awk '{sum+=$5} END {print sum}'  # suma del tamaño de archivos
awk -F: '{print $1}' /etc/passwd          # usuarios (separador :)
awk -F: '$3 >= 1000 {print $1}' /etc/passwd   # usuarios con UID >= 1000
awk 'NR==3 {print}' archivo.txt           # solo línea 3
awk 'END{print NR}' archivo.txt           # nº de líneas
```

Variables de `awk`: `$0` línea entera, `$1`-`$N` campos, `NF` nº de campos, `NR` nº de línea, `-F` separador.

**sed** (*stream editor*) transforma texto:

```bash
echo "Hola mundo" | sed 's/mundo/Linux/'       # Hola Linux
sed 's/error/ERROR/g' app.log                   # todas las ocurrencias (global)
sed -i 's/antiguo/nuevo/g' config.txt           # edita el archivo in place
sed '5d' archivo.txt                            # borra línea 5
sed -n '5,10p' archivo.txt                      # imprime líneas 5 a 10
sed '/^#/d' config.conf                         # borra líneas que empiezan por #
sed 's/[ \t]*$//' archivo.txt                   # quita espacios al final de línea
```

> `sed -i` modifica el archivo original. Si añades `-i.bak` guardará una copia de respaldo.

### Comandos de referencia rápida

| Comando | Qué hace |
|---|---|
| `ip a` / `ping` / `curl` / `wget` | red básica |
| `ss -tlnp` | puertos a la escucha |
| `dig` / `nslookup` | DNS |
| `ssh` / `scp` / `rsync -av` | acceso remoto y copia |
| `ufw allow 22` | firewall simple |
| `var=valor` / `$var` / `$(cmd)` | variables y sustitución |
| `if` / `for` / `while` / `case` | control de flujo |
| `funcion() { ... }` | función |
| `cmd \| cmd` | pipe |
| `cmd > arch` / `2>&1` / `tee` | redirección |
| `awk` / `sed` | procesar texto |
| `set -euo pipefail` | script robusto |

## Conceptos clave

- **stdin/stdout/stderr**: tres flujos numerados 0/1/2 que se pueden redirigir y entubar.
- **Exit code**: `0` es éxito; cualquier otro es fallo. `set -e` aborta el script al primer error.
- **`$@` vs `$*`**: `$@` preserva argumentos como elementos separados (mejor para iterar).
- **`[[ ]]` > `[ ]`**: más seguro (no rompe con variables vacías) y soporta regex con `=~`.
- **`rsync` es mejor que `scp`** para sincronizar directorios: transfiere solo lo cambiado.
- **`ss` sustituye a `netstat`**: más rápido y siempre presente en sistemas modernos.
- **Permisos SSH críticos**: `~/.ssh` 700 y `authorized_keys` 600; si no, SSH los ignora por seguridad.

## Errores comunes

- **Espacios alrededor de `=`**: `x = 5` no funciona; debe ser `x=5` (sin espacios).
- **Olvidar `"$@"` entre comillas**: si un argumento tiene espacios se parte. Usa `"$@"`, no `$*`.
- **`[ $var = "x" ]` sin citar `$var`**: si `var` está vacía, `[ ] ]` da error de sintaxis. Usa `[ "$var" = "x" ]` o `[[ $var == x ]]`.
- **`rm $(find ...)` con espacios en nombres**: falla. Usa `find ... -delete` o `find -print0 | xargs -0 rm`.
- **Redirigir solo stdout**: `comando > log.txt` deja stderr por pantalla. Usa `2>&1` o `&>`.
- **`scp` con la barra mal**: `scp -r carpeta host:dest/` copia el contenido; `carpeta/` (sin barra) copia el directorio. Revisa siempre.
- **`set -e` con pipes**: un fallo en la parte izquierda del pipe no aborta salvo `set -o pipefail`.
- **Esperar que `ufw` bloquee al instante** sin `ufw enable`: las reglas solo aplican cuando está activo.
