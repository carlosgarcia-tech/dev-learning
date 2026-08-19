# 01 — Fundamentos de Redis

## Objetivos

- [ ] Comprender qué es Redis y en qué se diferencia de una base de datos relacional
- [ ] Conocer los casos de uso típicos: caché, colas, sesiones, rankings y rate limiting
- [ ] Instalar y arrancar un servidor Redis localmente y con Podman
- [ ] Conectar al servidor con `redis-cli` y verificar el estado con `PING`
- [ ] Entender el modelo de datos clave-valor y las claves binarias
- [ ] Aplicar convenciones de nombres con el separador `:` (por ejemplo, `usuario:1:nombre`)
- [ ] Usar los comandos básicos de Strings: `SET`, `GET`, `MSET`, `MGET`, `APPEND`, `STRLEN`
- [ ] Usar variantes de escritura: `SETNX`, `SETEX`, `GETSET`, `GETDEL`
- [ ] Manejar contadores atómicos con `INCR`, `DECR`, `INCRBY`, `DECRBY`, `INCRBYFLOAT`
- [ ] Comprobar existencia y borrar datos con `EXISTS`, `DEL`, `TYPE`, `KEYS`, `DBSIZE`
- [ ] Limpiar la base con `FLUSHDB` y `FLUSHALL` con criterio
- [ ] Controlar el ciclo de vida de una clave con `EXPIRE`, `TTL`, `PERSIST`, `PEXPIRE`, `PTTL`
- [ ] Distinguir los seis tipos de datos principales: `STRING`, `LIST`, `SET`, `HASH`, `ZSET`, `STREAM`
- [ ] Utilizar opciones avanzadas de `redis-cli`: `--raw`, `--pipe`, `-n`, y ejecución de archivos
- [ ] Conocer el sistema de bases lógicas con `SELECT` y la base por defecto 0
- [ ] Interpretar las respuestas de `redis-cli`: `OK`, enteros y valores `nil`

## Apuntes

### ¿Qué es Redis?

Redis (acrónimo de **REmote DIctionary Server**) es un almacén de datos **in-memory**, **open source** y basado en el modelo **clave-valor**. Todos los datos viven en la memoria RAM del servidor, lo que le permite responder en microsegundos y sostener cientos de miles de operaciones por segundo.

**Diferencias clave frente a una base de datos relacional (RDBMS):**

| Característica | RDBMS (MySQL, PostgreSQL) | Redis |
|---|---|---|
| Almacenamiento | Disco (persistente) | Memoria RAM (con persistencia opcional) |
| Modelo | Tablas, filas, columnas, SQL | Clave-valor, estructuras de datos |
| Latencia | Milisegundos | Microsegundos |
| Consultas | SQL declarativo | Comandos específicos por tipo |
| Escalado | Vertical/Replicación | Replicación, clúster, particionado |
| Persistencia | Garantizada | Opcional (RDB, AOF) |

**Casos de uso más comunes:**

1. **Caché**: guardar respuestas costosas o consultas frecuentes para evitar golpear la base principal (patrón *cache-aside*).
2. **Colas de mensajes**: las Listas o Streams permiten construir colas FIFO de trabajos.
3. **Sesiones de usuario**: almacenar la sesión con `SETEX` y un TTL acorde a la duración de la sesión.
4. **Rankings y tablas de líderes**: los *sorted sets* (conjuntos ordenados) dan `ZRANK` y `ZREVRANK`.
5. **Rate limiting**: contadores atómicos con `INCR` + `EXPIRE` o *sorted sets* por ventana de tiempo.
6. **Publicación/suscripción**: `PUBLISH`/`SUBSCRIBE` para mensajería en tiempo real.
7. **Analítica**: bitmaps para medir presencia de usuarios por día.

> **Regla práctica**: si el dato debe sobrevivir a un reinicio y ser consultado con SQL complejo, no es Redis. Redis complementa, no sustituye, a la base de datos principal.

### ¿Dónde encaja Redis en la arquitectura?

Redis normalmente se coloca **entre la aplicación y la base de datos persistente**:

```
Cliente / Aplicación
        │
        ▼
   ┌─────────┐   datos calientes / caché   ┌───────────┐
   │  Redis  │◄────────────────────────────►│  RDBMS    │
   │ (RAM)   │  fallback (cache miss)       │  (disco)  │
   └─────────┘                              └───────────┘
```

- **Cache hit**: Redis responde en microsegundos sin tocar la base.
- **Cache miss**: se lee de la base, se escribe en Redis con un TTL y se responde al cliente.

### Instalación y arranque

#### Instalación nativa

En distribuciones basadas en Debian/Ubuntu:

```bash
sudo apt update
sudo apt install redis-server
```

En Fedora/RHEL:

```bash
sudo dnf install redis
```

En macOS con Homebrew:

```bash
brew install redis
```

#### Arranque del servidor

| Método | Comando |
|---|---|
| Servidor en primer plano | `redis-server` |
| Servidor en segundo plano (init) | `sudo systemctl start redis-server` |
| Habilitar al arrancar el sistema | `sudo systemctl enable redis-server` |
| Verificar estado | `redis-cli ping` |
| Comprobar versión | `redis-server --version` |

El servidor escucha por defecto en `127.0.0.1:6379`. Para detenerlo: `redis-cli shutdown`.

#### Arranque con Podman (contenedor)

```bash
podman run -d -p 6379:6379 redis:7-alpine
```

Explicación de la opciones:

| Opción | Significado |
|---|---|
| `run` | Crea y ejecuta un contenedor |
| `-d` | Detached: corre en segundo plano |
| `-p 6379:6379` | Publica el puerto 6379 del contenedor en el host |
| `redis:7-alpine` | Imagen oficial de Redis 7 sobre Alpine (ligera) |

Para entrar a una shell dentro del contenedor:

```bash
podman exec -it <id-contenedor> sh
```

#### Comprobación con redis-cli

```bash
$ redis-cli ping
PONG
```

El comando `PING` no recibe argumentos y responde `PONG`. Es la forma canónica de saber que el servidor está vivo. También responde a `redis-cli ping "hola"` con `"hola"`.

### La herramienta redis-cli

`redis-cli` es el cliente de línea de comandos oficial. Su forma básica es:

```bash
redis-cli [OPCIONES] [COMANDO [ARGUMENTOS...]]
```

| Opción | Descripción |
|---|---|
| `-h <host>` | Host del servidor (por defecto `127.0.0.1`) |
| `-p <puerto>` | Puerto (por defecto `6379`) |
| `-a <contraseña>` | Autenticación (⚠️ visible en el historial) |
| `-n <db>` | Número de base lógica (0-15) |
| `--raw` | Salida sin comillas ni escape (ideal para scripts) |
| `--pipe` | Envía comandos en bloque (pipelining) |
| `-r <n>` | Repite un comando N veces |

Ejemplos:

```bash
redis-cli ping
redis-cli -n 3 SET app:modo "pruebas"
redis-cli --raw GET usuario:1:nombre
redis-cli -r 10 -i 1 INCR contador:latido   # cada 1 s, 10 veces
```

Sin argumentos, `redis-cli` abre un **modo interactivo** donde no se repite el prefijo `redis-cli`:

```
$ redis-cli
127.0.0.1:6379> SET saludo hola
OK
127.0.0.1:6379> GET saludo
"hola"
127.0.0.1:6379> quit
```

### Modelo de datos

Redis es un **diccionario de pares clave-valor**. Todo dato se identifica por una clave y cada clave apunta a **un valor cuyo tipo es uno de los tipos soportados**.

#### Claves binarias seguras

Una clave es una secuencia de bytes arbitrarios (hasta **512 MB**). Puede contener espacios, saltos de línea e incluso bytes binarios, pero en la práctica se usan cadenas legibles. Algunas reglas:

- Las claves distinguen mayúsculas y minúsculas: `usuario:1` y `Usuario:1` son distintas.
- No existe jerarquía real de árbol: el separador `:` es solo una **convención**.
- Las claves vacías (`""`) son válidas pero casi nunca deseables.
- Claves demasiado largas desperdician memoria; demasiado cortas pueden colisionar en significado.

#### Convenciones de nombres

La convención más extendida es usar **dos puntos** para agrupar conceptos. Es como un "namespaces" visual:

| Patrón | Ejemplo |
|---|---|
| Objeto por id | `usuario:1:nombre` |
| Objeto con atributo | `pedido:100:estado` |
| Colección con sufijo | `usuarios:online` |
| Fecha o período | `metricas:2026-08-19` |
| Prefijo de dominio | `app:cache:home:1` |

Ejemplo completo de una entidad:

```
usuario:1:nombre   → "Ana"
usuario:1:email    → "ana@correo.com"
usuario:1:edad     → 30
```

**Claves que admiten búsqueda por patrón** con `KEYS`:

| Patrón | Significado |
|---|---|
| `usuario:*` | Todas las claves que empiezan por `usuario:` |
| `usuario:1:*` | Todos los atributos del usuario 1 |
| `pedido:*:total` | Claves que terminan en `:total` |
| `usuario:?:nombre` | Un solo carácter comodín (`?`) |
| `*` | Todas las claves |
| `[aeiou]*` | Claves que empiezan por vocal |

> ⚠️ `KEYS` recorre **todas** las claves en producción y bloquea el servidor con muchos datos. Para escanear sin bloquear existe `SCAN`. Úsalo solo en entornos de desarrollo.

### El tipo de dato String

El tipo `STRING` es el más básico: un valor binario de hasta **512 MB**. Se usa para configuraciones, fragmentos HTML, tokens, contadores, etc.

| Comando | Descripción | Complejidad |
|---|---|---|
| `SET clave valor` | Crea o sobrescribe una clave | O(1) |
| `GET clave` | Devuelve el valor o `nil` | O(1) |
| `MSET k1 v1 [k2 v2 ...]` | Establece varias claves en una sola operación | O(N) |
| `MGET k1 [k2 ...]` | Lee varias claves en una sola operación | O(N) |
| `APPEND clave valor` | Añade texto al final del valor | O(1) amortizado |
| `STRLEN clave` | Longitud en bytes del valor | O(1) |
| `GETSET clave valor` | Devuelve el valor viejo y escribe el nuevo | O(1) |
| `SETNX clave valor` | Escribe solo si no existe (Set if Not eXists) | O(1) |
| `SETEX clave seg valor` | SET + EXPIRE en un solo comando | O(1) |
| `GETDEL clave` | Devuelve el valor y borra la clave | O(1) |

#### SET y GET

```bash
redis-cli SET saludo hola
redis-cli GET saludo
redis-cli GET inexistente    # (nil)
```

**Opciones de `SET` en Redis 7** (la versión extendida del comando):

| Opción | Significado |
|---|---|
| `EX <segundos>` | Expiración en segundos |
| `PX <milisegundos>` | Expiración en milisegundos |
| `NX` | Solo si la clave no existe |
| `XX` | Solo si la clave ya existe |
| `GET` | Devuelve el valor anterior (o `nil`) |
| `KEEPTTL` | Conserva el TTL actual de la clave |

```bash
redis-cli SET cache:inicio EX 60 NX
redis-cli SET token:7 GET XX
```

#### MSET y MGET

Agrupan escrituras y lecturas para ahorrar idas y vueltas a la red:

```bash
redis-cli MSET usuario:1:nombre "Ana" usuario:1:email "ana@correo.com"
redis-cli MGET usuario:1:nombre usuario:1:email
```

> 💡 En Redis **no existe** `MGET con nil`: las claves ausentes devuelven `(nil)` dentro de la lista de resultados, sin error.

#### APPEND y STRLEN

```bash
redis-cli SET log:app "error:"
redis-cli APPEND log:app " tiempo_agotado"
redis-cli GET log:app          # "error: tiempo_agotado"
redis-cli STRLEN log:app       # (integer) 21
```

> 💡 `STRLEN` mide **bytes**, no caracteres. Con texto en UTF-8, una `ñ` ocupa 2 bytes.

#### GETSET

Devuelve el valor **anterior** y escribe el nuevo en una sola operación atómica:

```bash
redis-cli SET contador:lecturas 10
redis-cli GETSET contador:lecturas 11   # (integer) 10
redis-cli GET contador:lecturas          # "11"
```

#### SETNX

Escribe **solo si la clave no existe**:

```bash
redis-cli SETNX descuento:aplicado "si"   # (integer) 1 → sí se escribió
redis-cli SETNX descuento:aplicado "no"   # (integer) 0 → ya existía
```

#### SETEX

`SET` + expiración en una sola instrucción. Ideal para cachés y sesiones:

```bash
redis-cli SETEX sesion:123 3600 "datos"
redis-cli TTL sesion:123     # (integer) 3600
```

#### GETDEL

Devuelve el valor y elimina la clave:

```bash
redis-cli SET tarea:1 "pendiente"
redis-cli GETDEL tarea:1    # "pendiente"
redis-cli EXISTS tarea:1    # (integer) 0
```

### Números y contadores atómicos

Redis guarda los números como cadenas, pero dispone de comandos para operar con ellos **de forma atómica** en el servidor. Esto evita condiciones de carrera típicas de *leer → sumar → escribir* en el cliente.

| Comando | Descripción | Complejidad |
|---|---|---|
| `INCR clave` | Incrementa en 1 | O(1) |
| `DECR clave` | Decrementa en 1 | O(1) |
| `INCRBY clave n` | Incrementa en n | O(1) |
| `DECRBY clave n` | Decrementa en n | O(1) |
| `INCRBYFLOAT clave n` | Incrementa en un decimal | O(1) |

```bash
redis-cli INCR contador:visitas          # (integer) 1
redis-cli INCR contador:visitas          # (integer) 2
redis-cli INCRBY contador:visitas 100    # (integer) 102
redis-cli DECR contador:visitas          # (integer) 101
redis-cli DECRBY contador:visitas 50     # (integer) 51
redis-cli INCRBYFLOAT precio:impuesto 0.5
```

**¿Por qué son atómicos?** Aunque dos clientes ejecuten `INCR` a la vez, Redis serializa la ejecución (es de un solo hilo). Cada `INCR` lee el valor, lo suma y lo escribe **sin interrupciones**, de modo que no se pierden incrementos.

**Errores posibles:**

- Si el valor no es un entero: `ERR value is not an integer or out of range`.
- `INCRBY` sobre una clave inexistente la crea con valor 0 antes de incrementar.

**Casos de uso de contadores:**

- Número de visitas a una página.
- Likes / votos en un artículo.
- Stock disponible (combinado con `DECR`).
- *Rate limiting* simple: `INCR` + `EXPIRE` por ventana.

### Existencia y borrado

| Comando | Descripción | Complejidad |
|---|---|---|
| `EXISTS clave [clave...]` | Devuelve cuántas claves existen | O(N) |
| `DEL clave [clave...]` | Borra claves y devuelve cuántas borró | O(N) |
| `TYPE clave` | Devuelve el tipo de dato | O(1) |
| `KEYS patrón` | Lista las claves que coinciden | O(N) ⚠️ |
| `DBSIZE` | Número de claves en la base actual | O(1) |
| `FLUSHDB` | Borra todas las claves de la base actual | O(N) |
| `FLUSHALL` | Borra todas las claves de todas las bases | O(N) |

```bash
redis-cli EXISTS usuario:1:nombre            # (integer) 1
redis-cli EXISTS clave:que:no:existe         # (integer) 0
redis-cli TYPE usuario:1:nombre              # string
redis-cli DEL usuario:1:nombre               # (integer) 1
redis-cli DBSIZE                             # (integer) 5
redis-cli KEYS "usuario:*"                   # lista de claves
```

**Comportamientos que conviene recordar:**

- `DEL` devuelve el **número de claves realmente borradas**, no un `OK`.
- `TYPE` devuelve: `string`, `list`, `set`, `zset`, `hash`, `stream` o `none` si no existe.
- `KEYS` acepta globs: `usuario:*`, `*:nombre`, `u?ario:*`.
- `FLUSHDB` y `FLUSHALL` aceptan el argumento opcional `ASYNC` para no bloquear:

```bash
redis-cli FLUSHALL ASYNC
```

> ⚠️ `FLUSHALL` es irreversible y afecta a **todas** las bases. Verifica antes con `DBSIZE` y usa `SELECT` para confirmar en qué base estás.

### Expiración (TTL)

Redis permite asignar un **tiempo de vida** (TTL, *Time To Live*) a cada clave. Cuando se agota, la clave se elimina de forma perezosa y activa.

| Comando | Descripción | Complejidad |
|---|---|---|
| `EXPIRE clave segundos` | Fija expiración en segundos | O(1) |
| `TTL clave` | Segundos restantes; `-1` sin expiración, `-2` inexistente | O(1) |
| `PERSIST clave` | Elimina la expiración (la hace permanente) | O(1) |
| `PEXPIRE clave ms` | Expiración en milisegundos | O(1) |
| `PTTL clave` | Milisegundos restantes | O(1) |

```bash
redis-cli SET cache:precio 99
redis-cli EXPIRE cache:precio 60
redis-cli TTL cache:precio            # (integer) 60
redis-cli PERSIST cache:precio        # la clave ya no expira
redis-cli TTL cache:precio            # (integer) -1
redis-cli PEXPIRE cache:precio 5000
redis-cli PTTL cache:precio           # (integer) 5000 (aprox.)
```

#### Interpretación de TTL

| Valor de `TTL` | Significado |
|---|---|
| `-1` | La clave existe y **no expira** |
| `-2` | La clave **no existe** (ya expiró o nunca existió) |
| `>= 0` | Segundos restantes de vida |

**Formas de fijar expiración al crear:**

```bash
redis-cli SETEX token:1 300 "abc"        # SET + EXPIRE
redis-cli SET token:2 "def" EX 300       # variante con opción EX
redis-cli SET token:3 "ghi" PX 300000    # en milisegundos
```

**Notas importantes:**

- `EXPIRE` con 0 o negativo borra la clave inmediatamente.
- Actualizar una clave con `SET` (sin `KEEPTTL`) **elimina la expiración**.
- `GETDEL`, `DEL` o `FLUSH*` eliminan la clave y su TTL.
- Los *sorted sets* no se ven afectados por `EXPIRE` de miembros: la expiración se aplica a la clave completa, no a elementos.

**Aplicación práctica**: cachés, sesiones, tokens temporales, códigos OTP, ofertas con fecha de caducidad, candados con TTL (distributed locks).

### Tipos de datos de Redis

Redis no es solo clave-valor simple: cada clave almacena **una estructura** con operaciones propias.

| Tipo | Nombre en `TYPE` | Ejemplo de valor | Operaciones típicas |
|---|---|---|---|
| `STRING` | `string` | `"hola"` | `GET`, `SET`, `INCR` |
| `LIST` | `list` | `[a, b, c]` | `LPUSH`, `RPOP`, `LRANGE` |
| `SET` | `set` | `{a, b, c}` | `SADD`, `SISMEMBER`, `SINTER` |
| `HASH` | `hash` | `{campo: valor}` | `HSET`, `HGET`, `HGETALL` |
| `ZSET` | `zset` | `{miembro → score}` | `ZADD`, `ZRANGE`, `ZINCRBY` |
| `STREAM` | `stream` | registro de eventos | `XADD`, `XREAD`, `XACK` |

#### Resumen con ejemplos mínimos

**STRING** — valor binario único (ya cubierto arriba):

```bash
SET saludo "hola"
GET saludo
```

**LIST** — lista ordenada de elementos, ideal para colas y pilas:

```bash
RPUSH cola:tareas "tarea1" "tarea2"
LPOP cola:tareas
```

**SET** — colección sin duplicados ni orden, ideal para pertenencia:

```bash
SADD tags:articulo:1 "redis" "db"
SISMEMBER tags:articulo:1 "redis"
```

**HASH** — mapa campo→valor, ideal para representar objetos:

```bash
HSET usuario:1 nombre "Ana" email "ana@correo.com"
HGET usuario:1 nombre
```

**ZSET** — conjunto ordenado por un puntaje (*score*), ideal para rankings:

```bash
ZADD ranking:puntos 100 "jugador1" 80 "jugador2"
ZREVRANGE ranking:puntos 0 0
```

**STREAM** — log de eventos append-only con IDs `<ms>-<seq>`:

```bash
XADD eventos "*" tipo "login" usuario "ana"
XLEN eventos
```

> 📌 Guía 02 — «Estructuras de datos» profundiza en LIST, HASH, SET, ZSET, bitmap, geoespacial y streams.

### Bases lógicas (SELECT)

Redis ofrece **16 bases lógicas** numeradas de `0` a `15`, separadas por completo entre sí (las claves no se mezclan). La base por defecto es la **0**.

```bash
redis-cli -n 0 SET app:entorno "dev"
redis-cli -n 1 SET app:entorno "test"
redis-cli -n 2 GET app:entorno   # (nil)
redis-cli -n 1 GET app:entorno   # "test"
```

En modo interactivo, el prompt muestra la base activa:

```
127.0.0.1:6379> SELECT 3
OK
127.0.0.1:6379[3]> SET clave:prueba 1
OK
```

**Reglas y advertencias:**

- Las bases **no son seguras**: cualquiera con acceso puede `SELECT` y leer lo que quiera.
- `FLUSHDB` solo afecta a la base actual; `FLUSHALL` a todas.
- `DBSIZE`, `KEYS` y `SCAN` actúan solo sobre la base seleccionada.
- Redis no permite nombres de base; solo el índice numérico.
- En producción es preferible una sola base con buenas convenciones de prefijos, y separar entornos en instancias distintas.

### Respuestas de redis-cli

Es fundamental interpretar las respuestas para no malinterpretar los resultados.

| Respuesta | Significado | Ejemplo |
|---|---|---|
| `OK` | Comando sin valor de retorno que terminó bien | `SET`, `EXPIRE`, `SELECT` |
| `(integer) N` | Resultado numérico | `INCR`, `DEL`, `EXISTS`, `DBSIZE` |
| `(nil)` | Resultado vacío / clave inexistente | `GET` de clave ausente |
| `"valor"` | Cadena con comillas de presentación | `GET` normal |
| `value` | Cadena sin comillas (con `--raw`) | `redis-cli --raw GET x` |
| `1) ...` | Lista / array de resultados | `MGET`, `KEYS`, `LRANGE` |
| `error` | `ERR ...` o `WRONGTYPE ...` | operación con tipo incorrecto |

**Con `--raw`** las cadenas se imprimen sin comillas, lo que facilita su uso en scripts:

```bash
$ redis-cli SET nombre "Ana" >/dev/null
$ redis-cli GET nombre
"Ana"
$ redis-cli --raw GET nombre
Ana
```

**Errores típicos de respuesta:**

```bash
redis-cli LPUSH nombre "x"
(error) WRONGTYPE Operation against a key holding the wrong kind of value
```

Este error aparece cuando se usa un comando de un tipo sobre una clave de otro tipo. La clave `nombre` es un `string`, no una `list`.

### redis-cli avanzado

#### `--raw` (salida sin formato)

Útil para consumir valores desde bash u otros lenguajes:

```bash
contador=$(redis-cli --raw INCR contador:script)
echo "El contador vale $contador"
```

#### Pipelining con `--pipe`

Envía **muchos comandos en un solo viaje de red** para reducir latencia. Se construye un archivo con los comandos en texto plano y se redirige:

```bash
printf 'SET clave1 1\nSET clave2 2\nINCR clave1\n' > comandos.redis
redis-cli --pipe < comandos.redis
```

Redis responde un resumen: errores, réplicas, segundos y bytes enviados. Si hay un error de sintaxis en una línea, lo reporta como `error` en el resumen.

#### Ejecución de archivos con `<`

Se puede pasar un archivo de comandos directamente:

```bash
redis-cli < script.redis
```

Cada línea debe ser un comando válido. Es una forma de *seed* de datos o de automatizar configuración.

#### `-n <db>` para elegir base

```bash
redis-cli -n 5 SET entorno "pre-produccion"
redis-cli -n 5 GET entorno
```

#### Repetición con `-r` y pausa con `-i`

```bash
redis-cli -r 5 -i 1 --raw INCR contador:latido
```

Ejecuta `INCR` 5 veces con 1 segundo de espera entre llamadas. Muy útil para vigilar un contador en vivo.

### Consejos de buenas prácticas

- **Nunca** usar `KEYS` en producción; usar `SCAN` con cursor.
- Separar entornos (dev/test/prod) en **instancias** o contenedores distintos, no solo en bases.
- Poner TTL a toda clave de caché; una caché sin expiración es un *memory leak*.
- Preferir `MSET`/`MGET` y pipelines para reducir round-trips.
- No guardar secretos en Redis sin cifrado de red (TLS) ni contraseña (`requirepass`).
- Nombres de clave cortos pero descriptivos, siempre con el mismo separador `:`.

## Ejemplos de código

### Bloque 1: ciclo básico de Strings

```bash
redis-cli SET bienvenida "Hola mundo"
redis-cli GET bienvenida
redis-cli MSET app:nombre "MiApp" app:version "1.0.0"
redis-cli MGET app:nombre app:version
redis-cli APPEND bienvenida " desde Redis"
redis-cli STRLEN bienvenida
redis-cli GETDEL bienvenida
redis-cli EXISTS bienvenida
```

### Bloque 2: contadores atómicos

```bash
redis-cli INCR visitas:total
redis-cli INCR visitas:total
redis-cli INCRBY visitas:total 48
redis-cli DECRBY visitas:total 8
redis-cli GET visitas:total
redis-cli INCRBYFLOAT carrito:1:total 19.99
redis-cli GET carrito:1:total
```

### Bloque 3: expiración y TTL

```bash
redis-cli SETEX sesion:42 300 "token-secreto"
redis-cli TTL sesion:42
redis-cli SET cache:home "<html>...</html>" EX 600
redis-cli TTL cache:home
redis-cli PERSIST cache:home
redis-cli TTL cache:home
redis-cli PTTL cache:home
```

### Bloque 4: existencia, tipo y limpieza

```bash
redis-cli SET usuario:1:nombre "Ana"
redis-cli EXISTS usuario:1:nombre
redis-cli EXISTS usuario:2:nombre
redis-cli TYPE usuario:1:nombre
redis-cli KEYS "usuario:*"
redis-cli DBSIZE
redis-cli DEL usuario:1:nombre
redis-cli FLUSHDB
redis-cli DBSIZE
```

### Bloque 5: bases lógicas y redis-cli avanzado

```bash
redis-cli SELECT 0
redis-cli -n 0 SET entorno "dev"
redis-cli -n 1 SET entorno "test"
redis-cli -n 1 GET entorno
redis-cli --raw GET entorno
printf 'SET a 1\nSET b 2\nINCR a\n' | redis-cli --pipe
redis-cli -r 3 -i 1 --raw INCR latido
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)
  - [SET y GET](ejercicios/nivel-01-fundamentos/ejercicio-01-set-y-get/ejercicio-01-set-y-get.md)
  - [DEL y APPEND](ejercicios/nivel-01-fundamentos/ejercicio-02-del-y-append/ejercicio-02-del-y-append.md)
  - [INCR y DECR](ejercicios/nivel-01-fundamentos/ejercicio-03-incr-y-decr/ejercicio-03-incr-y-decr.md)
  - [EXPIRE y TTL](ejercicios/nivel-01-fundamentos/ejercicio-04-expire-y-ttl/ejercicio-04-expire-y-ttl.md)
  - [MSET y MGET](ejercicios/nivel-01-fundamentos/ejercicio-05-mset-y-mget/ejercicio-05-mset-y-mget.md)
  - [KEYS y DBSIZE](ejercicios/nivel-01-fundamentos/ejercicio-06-keys-y-dbsize/ejercicio-06-keys-y-dbsize.md)

## Errores comunes

1. **`(error) ERR value is not an integer or out of range`**
   - **Causa**: se ejecuta `INCR`/`DECR` sobre un valor que no es un entero (por ejemplo, `"hola"`).
   - **Solución**: verifica el tipo y contenido con `GET`/`TYPE` antes de operar; usa `INCRBYFLOAT` solo para decimales.

2. **`(error) WRONGTYPE Operation against a key holding the wrong kind of value`**
   - **Causa**: usar un comando de un tipo sobre una clave de otro (p. ej. `LPUSH` sobre un `string`).
   - **Solución**: revisa `TYPE clave` y borra con `DEL` si quieres empezar de cero, o usa el comando correcto.

3. **`KEYS *` devuelve todo y el servidor se bloquea**
   - **Causa**: `KEYS` recorre todas las claves y, con millones de ellas, bloquea el hilo único de Redis.
   - **Solución**: usa `SCAN` con cursor y conteo para iterar sin bloquear; reserva `KEYS` a desarrollo.

4. **`TTL` devuelve `-2` cuando esperaba el tiempo restante**
   - **Causa**: `-2` significa que la clave **no existe**: o nunca existió o ya expiró.
   - **Solución**: confirma con `EXISTS`; si esperabas que viviera más, revisa los segundos pasados a `EXPIRE`.

5. **`TTL` devuelve `-1` después de un `SET`**
   - **Causa**: `SET` sin la opción `KEEPTTL` elimina la expiración existente.
   - **Solución**: usa `SET clave valor KEEPTTL` o `SETEX`/`EXPIRE` para reasignar la expiración.

6. **Creer que `GET` de una clave inexistente devuelve error**
   - **Causa**: en Redis `GET` de una clave ausente devuelve `(nil)`, no un error.
   - **Solución**: trata `nil` como "no existe"; usa `EXISTS` si necesitas distinguir ausencia de valor vacío.

7. **Contador que "pierde" incrementos**
   - **Causa**: la app hace *leer → sumar → escribir* en el cliente, provocando carreras entre procesos.
   - **Solución**: usa `INCR`/`DECR` que son atómicos en el servidor; jamás emules el contador con `GET` + `SET`.

8. **`FLUSHALL` borró datos de otro entorno**
   - **Causa**: `FLUSHALL` afecta a **todas** las bases de la instancia.
   - **Solución**: usa `FLUSHDB` para la base actual y antes confirma `SELECT`/`DBSIZE`; en producción protege con `requirepass` y `rename-command`.

9. **Cambios con `-n` que no se ven desde el cliente**
   - **Causa**: `-n 3 SET ...` escribe en la base 3, pero `redis-cli GET ...` lee la base 0.
   - **Solución**: indica siempre el mismo `-n` en ambos comandos, o haz `SELECT 3` en modo interactivo.

10. **`--pipe` no reporta errores línea a línea**
    - **Causa**: el pipelining agrupa comandos y solo devuelve un resumen agregado.
    - **Solución**: valida primero el archivo en modo interactivo; revisa el conteo de errores del resumen.

11. **`SETEX` con tiempo de expiración en milisegundos que no encaja**
    - **Causa**: `SETEX` solo acepta segundos; si pasas milisegundos, interpreta el número como segundos.
    - **Solución**: usa `SET ... PX <ms>` o `PEXPIRE` para milisegundos.

12. **Esperar orden o unicidad en un `STRING`**
    - **Causa**: los `STRING` no tienen estructura interna: no hay orden ni campos.
    - **Solución**: si necesitas campos, usa `HASH`; si necesitas orden, `LIST` o `ZSET`; si unicidad, `SET`.

13. **Claves con espacios o acentos que rompen scripts**
    - **Causa**: las claves son binarias y pueden contener espacios; al pasarlas sin comillas a la shell se separan.
    - **Solución**: usa `--raw` y comillas simples en la shell, o normaliza los nombres a `minusculas:sin-espacios`.

14. **No distinguir `0` (booleano) de `nil`**
    - **Causa**: `SISMEMBER`, `SETNX`, `EXISTS` devuelven `(integer) 0/1`, mientras `GET` devuelve `(nil)`.
    - **Solución**: `0` significa "falso/existía" pero la clave puede existir; `nil` significa ausencia. Interpreta según el comando.

## Recursos

- Documentación oficial de Redis: https://redis.io/docs/
- Comando `SET` (incluye opciones NX/XX/EX/KEEPTTL): https://redis.io/commands/set/
- Guía de tipos de datos: https://redis.io/docs/data-types/
- Comando `redis-cli` y sus opciones: https://redis.io/docs/manual/cli/
- Guía de expiración: https://redis.io/commands/expire/
- Imagen oficial de Redis en Docker Hub: https://hub.docker.com/_/redis/
- Cheat sheet de comandos Redis: https://redis.io/commands/
