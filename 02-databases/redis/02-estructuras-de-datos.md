# 02 — Estructuras de datos

## Objetivos

- [ ] Entender que cada tipo de dato Redis resuelve un problema distinto
- [ ] Usar Listas como colas FIFO y pilas LIFO con `LPUSH`, `RPUSH`, `LPOP`, `RPOP`
- [ ] Inspeccionar y modificar Listas con `LRANGE`, `LLEN`, `LINDEX`, `LSET`, `LINSERT`, `LREM`, `LTRIM`
- [ ] Transferir elementos entre Listas con `RPOPLPUSH` y su sucesor `LMOVE`
- [ ] Representar objetos con Hashes y operar campos con `HSET`, `HGET`, `HMGET`, `HGETALL`
- [ ] Modificar Hashes con `HDEL`, `HEXISTS`, `HKEYS`, `HVALS`, `HLEN`, `HINCRBY`, `HSTRLEN`
- [ ] Comparar cuándo usar un Hash frente a claves String sueltas
- [ ] Manejar Sets con `SADD`, `SREM`, `SISMEMBER`, `SCARD`, `SPOP`, `SMEMBERS`
- [ ] Combinar Sets con `SINTER`, `SUNION`, `SDIFF` y sus variantes `*STORE`
- [ ] Usar Sorted Sets con `ZADD`, `ZRANGE`, `ZREVRANGE`, `ZRANGEBYSCORE` y `WITHSCORES`
- [ ] Consultar posición y puntaje con `ZSCORE`, `ZRANK`, `ZREVRANK`, `ZCARD` y actualizar con `ZINCRBY`
- [ ] Aplicar Bitmaps con `SETBIT`, `GETBIT`, `BITCOUNT` y `BITOP`
- [ ] Almacenar coordenadas con `GEOADD`, `GEOPOS`, `GEODIST` y `GEOSEARCH`
- [ ] Introducir Streams con `XADD`, `XLEN`, `XRANGE` e IDs `<ms>-<seq>`
- [ ] Crear y consumir *consumer groups* con `XGROUP`, `XREADGROUP` y `XACK`
- [ ] Elegir la estructura adecuada para cada caso usando la tabla comparativa

## Apuntes

### El valor real de Redis: estructuras de datos

En la guía 01 vimos los `STRING`. Pero Redis no es un simple diccionario: cada clave puede contener una **estructura de datos** con operaciones propias ejecutadas en el servidor, con garantías de atomicidad y complejidad documentada.

| Tipo | Representación | Orden | Duplicados | Uso típico |
|---|---|---|---|---|
| `STRING` | valor único | n/a | n/a | caché, contadores, tokens |
| `LIST` | secuencia de elementos | sí (inserción) | sí | colas FIFO, pilas, timelines |
| `SET` | colección de miembros | no | no | pertenencia, tags, deduplicación |
| `HASH` | mapa campo→valor | n/a | campos únicos | objetos, sesiones |
| `ZSET` | miembros ordenados por score | sí (por score) | no (score sí puede repetirse) | rankings, colas con prioridad |
| `STREAM` | log append-only de eventos | sí (por ID) | sí | mensajería, event sourcing |

Todas las operaciones clave (acceso, inserción, borrado por clave) son **O(1)** salvo que se indique lo contrario.

### Listas

Una **Lista** es una secuencia ordenada de cadenas. En la implementación de Redis 7 es un *listpack* para listas pequeñas o una lista doblemente enlazada para las grandes.

**Puntos clave:**

- Los elementos se insertan por la **cabeza** (izquierda, prefijos `L`) o por la **cola** (derecha, prefijos `R`).
- Es natural para **colas FIFO** (`LPUSH` + `RPOP`), **pilas LIFO** (`LPUSH` + `LPOP`) y **timelines**.
- Acceso por índice con `LINDEX`, rangos con `LRANGE`.
- Admite hasta **4 294 967 295 elementos** por lista (2³² − 1).

| Comando | Descripción | Complejidad |
|---|---|---|
| `LPUSH clave v [v...]` | Inserta al inicio; devuelve longitud | O(1) por elemento |
| `RPUSH clave v [v...]` | Inserta al final; devuelve longitud | O(1) por elemento |
| `LRANGE clave inicio fin` | Elementos entre índices (negativos permitidos) | O(S+N) |
| `LPOP clave [n]` | Extrae del inicio; opcional n elementos | O(N) |
| `RPOP clave [n]` | Extrae del final; opcional n elementos | O(N) |
| `LLEN clave` | Longitud de la lista | O(1) |
| `LINDEX clave índice` | Elemento en un índice | O(N) |
| `LSET clave índice valor` | Sustituye un elemento | O(N) |
| `LINSERT clave ANTES|DESPUÉS pivote v` | Inserta relativo a un pivote | O(N) |
| `LREM clave conteo v` | Elimina coincidencias | O(N) |
| `LTRIM clave inicio fin` | Recorta la lista al rango | O(N) |
| `RPOPLPUSH origen destino` | Mueve el último elemento entre listas | O(1) |
| `LMOVE origen destino IZQUIERDA|DERECHA IZQUIERDA|DERECHA` | Mueve elementos entre listas | O(1) |

#### Colas FIFO y pilas LIFO

**Cola FIFO** (primero en entrar, primero en salir) — `RPUSH` por un lado, `LPOP` por el otro:

```bash
RPUSH cola:pedidos "pedido-1" "pedido-2" "pedido-3"
LPOP cola:pedidos     # "pedido-1"
LPOP cola:pedidos     # "pedido-2"
```

**Pila LIFO** (último en entrar, primero en salir) — ambos lados por la cabeza:

```bash
LPUSH pila:acciones "deshacer-a" "deshacer-b"
LPOP pila:acciones    # "deshacer-b"
LPOP pila:acciones    # "deshacer-a"
```

#### Rangos e índices

`LRANGE` acepta índices desde `0` y negativos desde el final (`-1` es el último):

```bash
RPUSH notas "n1" "n2" "n3" "n4"
LRANGE notas 0 -1      # n1 n2 n3 n4
LRANGE notas 1 2       # n2 n3
LRANGE notas -2 -1     # n3 n4
LRANGE notas 0 0       # solo el primero
LINDEX notas 2         # n3
LLEN notas             # (integer) 4
```

#### Modificación de la lista

```bash
RPUSH lista "a" "b" "c" "d" "b"
LSET lista 1 "B"            # a B c d b
LINSERT lista ANTES "c" "x" # a B x c d b
LREM lista 1 "b"            # elimina 1 b  → a B x c d
LREM lista 0 "z"            # count 0 = elimina todas las coincidencias
LTRIM lista 1 -2            # B x c d
```

#### Operaciones bloqueantes

Las Listas tienen versiones **bloqueantes** que esperan a que haya datos: `BLPOP`, `BRPOP` y `BLMOVE`. Son ideales para colas de trabajos donde el consumidor no debe *pollar* en bucle.

```bash
BRPOP cola:pedidos 0        # espera indefinidamente (timeout 0)
BRPOP cola:pedidos 30       # espera hasta 30 s, luego devuelve nil
BLMOVE cola pendientes IZQUIERDA DERECHA 5
```

Con estas, la cola de trabajos se convierte en un patrón productor-consumidor eficiente sin gasto de CPU en esperas activas.

#### RPOPLPUSH y LMOVE

`RPOPLPUSH` extrae el **último** elemento de una lista y lo inserta al **inicio** de otra, en una sola operación atómica. Es la base del patrón *cola de trabajos segura* (cola + cola de "procesando" para reintentos).

```bash
RPUSH pendientes "job-1" "job-2"
RPOPLPUSH pendientes en_proceso    # "job-2"
```

`LMOVE` es la versión genérica (Redis 6.2+): permite elegir los lados en cada lista.

```bash
RPUSH origen "a" "b"
LMOVE origen destino DERECHA IZQUIERDA   # mueve "b"
```

**Aplicaciones:**

- Colas de trabajos con reintento: procesar desde la cola "activa" y mover el fallido a una cola de reintentos.
- Rotación de listas: `RPOPLPUSH cola cola` mueve el último al inicio (cola circular).
- Balanceo de carga entre dos colas.

### Hashes

Un **Hash** es un mapa de **campo → valor**, ambos cadenas. Es la estructura más parecida a un objeto o registro, y el punto dulce para modelar entidades sin multiplicar claves.

| Comando | Descripción | Complejidad |
|---|---|---|
| `HSET clave campo valor [campo valor...]` | Crea o actualiza campos | O(1) por campo |
| `HGET clave campo` | Valor de un campo | O(1) |
| `HMGET clave campo [campo...]` | Varios campos a la vez | O(N) |
| `HGETALL clave` | Todos los campos y valores | O(N) |
| `HDEL clave campo [campo...]` | Elimina campos | O(1) por campo |
| `HEXISTS clave campo` | 1 si el campo existe | O(1) |
| `HKEYS clave` | Todos los nombres de campo | O(N) |
| `HVALS clave` | Todos los valores | O(N) |
| `HLEN clave` | Número de campos | O(1) |
| `HINCRBY clave campo n` | Incrementa un campo numérico | O(1) |
| `HSTRLEN clave campo` | Longitud en bytes del valor | O(1) |

#### Modelar un objeto con HASH

```bash
HSET usuario:1 nombre "Ana" email "ana@correo.com" edad 30
HGET usuario:1 nombre            # "Ana"
HMGET usuario:1 nombre email     # "Ana" "ana@correo.com"
HGETALL usuario:1                # todos los pares
HLEN usuario:1                   # (integer) 3
HKEYS usuario:1                  # nombre email edad
HVALS usuario:1                  # Ana ana@correo.com 30
```

#### Borrado, existencia y longitudes

```bash
HEXISTS usuario:1 email          # (integer) 1
HDEL usuario:1 edad              # (integer) 1
HSTRLEN usuario:1 nombre         # (integer) 3
HEXISTS usuario:1 edad           # (integer) 0
```

#### Contadores dentro de hashes

```bash
HSET carrito:9 total 0
HINCRBY carrito:9 total 25        # (integer) 25
HINCRBY carrito:9 total 30        # (integer) 55
HINCRBY carrito:9 total -5        # (integer) 50
```

#### Hash vs. Strings sueltos

| Aspecto | Hash (`usuario:1`) | Strings (`usuario:1:nombre`, ...) |
|---|---|---|
| Modelo | un objeto por clave | un atributo por clave |
| Lectura total | `HGETALL` en 1 round-trip | `MGET` con N claves |
| Añadir campo | `HSET usuario:1 telefono ...` | nueva clave |
| Contador | `HINCRBY` | `INCR` |
| Caducidad | TTL sobre **todo** el objeto | TTL por atributo |
| Visibilidad en `KEYS` | 1 clave | N claves |

**Regla práctica:** si el dato es una entidad con atributos fijos, usa `HASH`. Solo usa Strings separados cuando cada atributo tenga un TTL distinto o deba indexarse de forma independiente.

#### Uso en sesiones

Un Hash es el contenedor natural de una sesión de usuario: varios atributos, actualización de campos sueltos (como `ultima_actividad`) y lectura completa con un solo `HGETALL`.

```bash
HSET sesion:42 usuario "ana" rol "admin" ultima_actividad "08:30"
HINCRBY sesion:42 peticiones 1
HGET sesion:42 rol
```

Si además se quiere caducar la sesión entera, se combina con `EXPIRE` sobre la clave del Hash: toda la sesión desaparece cuando expira.

```bash
EXPIRE sesion:42 1800
TTL sesion:42
```

#### Hashes con nombres de campo dinámicos

`HSET` acepta varios pares y también se puede usar para construir estructuras tipo mapa dentro de una sola clave, por ejemplo contadores por hora:

```bash
HSET metricas:ventas "hora-09" 12 "hora-10" 18
HINCRBY metricas:ventas "hora-11" 5
HGETALL metricas:ventas
```

Esta técnica convierte a los Hashes en pequeños mapas anidados útiles para agregados por categoría.

### Sets

Un **Set** es una colección de cadenas **sin duplicados y sin orden garantizado**. Su fortaleza está en la pertenencia (O(1)) y en la **deduplicación** automática.

| Comando | Descripción | Complejidad |
|---|---|---|
| `SADD clave miembro [miembro...]` | Añade miembros | O(1) por miembro |
| `SREM clave miembro [miembro...]` | Elimina miembros | O(1) por miembro |
| `SISMEMBER clave miembro` | 1 si pertenece | O(1) |
| `SCARD clave` | Cardinalidad (tamaño) | O(1) |
| `SMEMBERS clave` | Todos los miembros | O(N) |
| `SPOP clave [n]` | Extrae aleatoriamente | O(1)/O(N) |
| `SRANDMEMBER clave [n]` | Muestra sin extraer | O(1)/O(N) |
| `SINTER clave [clave...]` | Intersección | O(N×M) |
| `SUNION clave [clave...]` | Unión | O(N) |
| `SDIFF clave [clave...]` | Diferencia | O(N) |
| `SINTERSTORE dest k...` | Intersección guardada | O(N×M) |
| `SUNIONSTORE dest k...` | Unión guardada | O(N) |
| `SDIFFSTORE dest k...` | Diferencia guardada | O(N) |

```bash
SADD tags:1 "redis" "db" "cache"
SADD tags:1 "redis"          # (integer) 0 → ya existía (sin duplicado)
SADD tags:2 "db" "java"
SCARD tags:1                 # (integer) 3
SISMEMBER tags:1 "db"        # (integer) 1
SMEMBERS tags:1              # orden no garantizado
```

#### SPOP: extracción aleatoria

Útil para sorteos o selección aleatoria:

```bash
SADD sorteo "ana" "luis" "maria" "pedro"
SPOP sorteo          # devuelve y quita un ganador
SRANDMEMBER sorteo 2 # muestra sin quitar
```

#### Operaciones de conjuntos

```bash
SINTER tags:1 tags:2          # intersección → "db"
SUNION tags:1 tags:2          # unión → redis db cache java
SDIFF tags:1 tags:2           # en 1 y no en 2 → redis cache
SINTERSTORE comunes tags:1 tags:2
SUNIONSTORE todo tags:1 tags:2
```

**Aplicaciones:**

- **Pertenencia**: `SISMEMBER` para roles, permisos, votos (deduplicación de votantes).
- **Tags**: etiquetas de artículos y cruce con `SINTER`.
- **Deduplicación**: colección de IDs de visitantes únicos de hoy.
- **Recomendaciones**: usuarios que comparten intereses con `SINTER`.

> ⚠️ `SMEMBERS` **no garantiza orden**. Si necesitas orden, usa `SORT` (con coste) o un Sorted Set.

#### Sets con expiración por miembro

Los Sets no permiten TTL por miembro: `EXPIRE` afecta a la clave entera. Para "expirar" un miembro concreto hay que combinarlo con timestamps, o usar un `ZSET` con el tiempo como score y limpiar con `ZREMRANGEBYSCORE`.

```bash
SADD eventos:set "e1" "e2"
EXPIRE eventos:set 60     # caduca TODO el conjunto, no solo e1
```

**Alternativa con ZSET** (score = timestamp de caducidad):

```bash
ZADD eventos:z 1753000000 "e1"
ZREMRANGEBYSCORE eventos:z -inf 1752999999   # borra lo caducado
```

#### SRANDMEMBER vs SPOP

| Comando | ¿Elimina? | Uso |
|---|---|---|
| `SRANDMEMBER clave [n]` | No | muestreo aleatorio, "quiz", sugerencias |
| `SPOP clave [n]` | Sí | sorteos, reparto de cupones |

Con `count` negativo, `SRANDMEMBER` permite repeticiones en la muestra:

```bash
SRANDMEMBER sorteo 3        # 3 distintos
SRANDMEMBER sorteo -3       # 3 con posible repetición
```

### Sorted Sets (ZSET)

Un **Sorted Set** es como un Set, pero cada miembro lleva un **score** (número de coma flotante) que lo ordena. Es la estructura más potente para rankings, colas con prioridad y ventanas de tiempo.

**Reglas de orden:**

- Los miembros se ordenan **ascendente por score**.
- A igual score, se ordenan **lexicográficamente** por miembro (orden de bytes).
- Los scores pueden repetirse; los **miembros no**.

| Comando | Descripción | Complejidad |
|---|---|---|
| `ZADD clave score miembro [score miembro...]` | Añade o actualiza | O(log N) por elemento |
| `ZRANGE clave inicio fin [WITHSCORES]` | Rango por posición (asc) | O(log N + M) |
| `ZREVRANGE clave inicio fin [WITHSCORES]` | Rango por posición (desc) | O(log N + M) |
| `ZRANGEBYSCORE clave min max [WITHSCORES]` | Rango por score (asc) | O(log N + M) |
| `ZREVRANGEBYSCORE clave max min` | Rango por score (desc) | O(log N + M) |
| `ZSCORE clave miembro` | Score de un miembro | O(1) |
| `ZCARD clave` | Número de miembros | O(1) |
| `ZRANK clave miembro` | Posición (asc, 0-based) | O(log N) |
| `ZREVRANK clave miembro` | Posición (desc, 0-based) | O(log N) |
| `ZINCRBY clave incremento miembro` | Incrementa el score | O(log N) |
| `ZREM clave miembro [miembro...]` | Elimina miembros | O(log N) por miembro |
| `ZCOUNT clave min max` | Miembros en un rango de score | O(log N) |

#### Creación y lectura

```bash
ZADD ranking:pts 100 "ana" 80 "luis" 95 "maria"
ZRANGE ranking:pts 0 -1            # luis maria ana (ascendente)
ZRANGE ranking:pts 0 -1 WITHSCORES # luis 80 maria 95 ana 100
ZREVRANGE ranking:pts 0 -1         # ana maria luis (descendente)
ZCARD ranking:pts                  # (integer) 3
ZSCORE ranking:pts "ana"           # "100"
```

#### Rangos por score

Sintaxis de extremos: `(` excluye el límite, `-inf`/`+inf` son infinitos:

```bash
ZADD edades 25 "ana" 34 "luis" 18 "maria" 40 "pedro"
ZRANGEBYSCORE edades 20 35            # ana luis (25 y 34)
ZRANGEBYSCORE edades (25 40           # luis pedro (excluye 25)
ZRANGEBYSCORE edades -inf +inf WITHSCORES
ZCOUNT edades 18 30                   # (integer) 2
```

#### Posición (rank) y actualización

```bash
ZRANK ranking:pts "maria"      # 1 (segunda, ascendente)
ZREVRANK ranking:pts "maria"   # 1 (segunda desde arriba)
ZINCRBY ranking:pts 20 "ana"   # ana pasa a 120 → ahora líder
ZREVRANK ranking:pts "ana"     # 0
ZREM ranking:pts "luis"        # (integer) 1
```

#### Casos de uso

1. **Rankings**: tabla de líderes con `ZINCRBY` por cada acción y lectura con `ZREVRANGE`.
2. **Colas con prioridad**: score = prioridad; los consumidores leen con `ZPOPMIN`/`ZPOPMAX`.
3. **Rate limiting por ventana**: cada petición es un miembro con timestamp como score; `ZREMRANGEBYSCORE` para limpiar la ventana y `ZCARD` para contar.
4. **Timelines ordenadas**: score = timestamp de publicación.

**Empates y lexicografía**: con el mismo score, `ZRANGE` ordena por el valor del miembro. Para ordenar por fecha *y* romper empates, se puede codificar `timestamp:punto` como score con tramos.

#### Rate limiting con ZSET (ventana deslizante)

El patrón clásico de ventana deslizante usa un ZSET donde el **score es el timestamp** de cada petición y el miembro un ID único:

```bash
ZADD rl:usuario:42 1753000001 "req-1"
ZADD rl:usuario:42 1753000002 "req-2"
ZREMRANGEBYSCORE rl:usuario:42 -inf 1752999999   # fuera de la ventana de 60 s
ZCARD rl:usuario:42                                # peticiones en la ventana
EXPIRE rl:usuario:42 60                            # limpieza automática
```

Si `ZCARD` supera el límite, se rechaza la petición. Esta técnica da límites precisos por usuario y ventana, a diferencia del contador simple (`INCR` + `EXPIRE`) que solo mira la ventana fija.

#### Internos: cómo se almacena un ZSET

- Con pocos elementos (por defecto < 128) y scores pequeños: **listpack**.
- Con más elementos o scores grandes: **skip list + tabla hash**, que da `O(log N)` para insertar, actualizar y consultar rangos.
- Cada miembro tiene un índice directo (`ZSCORE`, `ZRANK` son O(1)/O(log N)) gracias a esa tabla hash.

Este diseño explica por qué un ZSET puede sostener rankings de millones de miembros manteniendo latencias de microsegundos.

### Bitmaps

Un **Bitmap** es un `STRING` tratado como un array de bits. Cada clave String de hasta 512 MB puede almacenar **4 294 967 296 bits** (512 MB × 8). Es la forma más compacta de almacenar presencia booleana por usuario y día.

| Comando | Descripción | Complejidad |
|---|---|---|
| `SETBIT clave offset valor` | Fija el bit en 0 o 1 | O(1) |
| `GETBIT clave offset` | Lee el valor de un bit | O(1) |
| `BITCOUNT clave [inicio fin]` | Cuenta bits a 1 | O(N) |
| `BITOP AND|OR|XOR|NOT dest clave...` | Operación entre bitmaps | O(N) |

```bash
SETBIT presencia:2026-08-19 7 1    # usuario id 7 activo hoy
SETBIT presencia:2026-08-19 42 1   # usuario id 42 activo hoy
GETBIT presencia:2026-08-19 7      # (integer) 1
GETBIT presencia:2026-08-19 8      # (integer) 0
BITCOUNT presencia:2026-08-19      # (integer) 2
```

**Uso típico — presencia diaria:**

| Clave | offset = usuario id |
|---|---|
| `presencia:2026-08-17` | bits con 1 para los activos ese día |
| `presencia:2026-08-18` | idem |
| `presencia:2026-08-19` | idem |

```bash
BITOP AND activos:3dias presencia:2026-08-17 presencia:2026-08-18 presencia:2026-08-19
BITCOUNT activos:3dias      # usuarios activos los 3 días
BITOP OR activos:algun_dia presencia:2026-08-17 presencia:2026-08-18
BITCOUNT activos:algun_dia  # usuarios que se conectaron al menos un día
```

**Otras aplicaciones:**

- Huella de usuarios activos mensual (compactísima: 1 bit por usuario).
- A/B testing: quién recibió cada variante.
- Features flags binarios por usuario.

> 💡 `BITCOUNT` acepta un rango de **bytes** (no bits) para contar solo un segmento del bitmap.

### Geospatial

Redis guarda coordenadas geográficas (longitud, latitud) internamente como **Sorted Sets** codificados con **geohash** de 52 bits como score. Por eso son compatibles con `ZRANGE`, `ZREM`, etc.

| Comando | Descripción | Complejidad |
|---|---|---|
| `GEOADD clave lon lat miembro [lon lat miembro...]` | Añade ubicaciones | O(log N) por elemento |
| `GEOPOS clave miembro [miembro...]` | Coordenadas de miembros | O(log N) |
| `GEODIST clave a b [m\|km\|mi\|ft]` | Distancia entre dos | O(log N) |
| `GEOSEARCH clave FROMMEMBER m \| FROMLONLAT lon lat BYRADIUS r <uni> [ASC\|DESC] [WITHCOORD] [WITHDIST]` | Búsqueda por radio | O(N+log M) |
| `GEOSEARCHSTORE dest ...` | Guarda el resultado | igual a GEOSEARCH |

> ⚠️ Redis 7 renombró `GEORADIUS` por `GEOSEARCH`. En Redis 7.x `GEORADIUS` sigue disponible como compatibilidad, pero `GEOSEARCH` es la forma recomendada.

#### Añadir y leer coordenadas

```bash
GEOADD ciudades -99.13 19.43 "mexico" -58.38 -34.60 "buenos-aires" -70.67 -33.45 "santiago"
GEOPOS ciudades "mexico"          # longitud y latitud
GEODIST ciudades "mexico" "santiago" km
```

#### Búsqueda por radio

```bash
GEOADD estaciones -99.13 19.43 "mexico" -99.14 19.45 "estacion-norte" -99.15 19.41 "estacion-sur"
GEOSEARCH estaciones FROMLONLAT -99.13 19.43 BYRADIUS 5 km ASC
GEOSEARCH estaciones FROMLONLAT -99.13 19.43 BYRADIUS 10 km WITHDIST
GEOSEARCH estaciones FROMMEMBER "mexico" BYBOX 10 10 km ASC
```

**Internamente** la clave `estaciones` es un `ZSET`; por tanto, `TYPE estaciones` devuelve `zset`, y se puede inspeccionar con `ZRANGE estaciones 0 -1 WITHSCORES` para ver los scores geohash.

**Aplicaciones:**

- "Locales cerca de mí" con radio.
- Geocercas de delivery y logística.
- Cálculo de distancias para tarificación.

### Streams (introducción)

Un **Stream** es un log **append-only** de entradas, cada una con un **ID** `<milisegundos>-<secuencia>` y un mapa de pares campo/valor. Es la estructura para mensajería, event sourcing y colas con acuse de recibo.

| Comando | Descripción |
|---|---|
| `XADD clave ID|* campo valor [campo valor...]` | Añade una entrada |
| `XLEN clave` | Número de entradas |
| `XRANGE clave inicio fin` | Entradas por rango de IDs |
| `XREVRANGE clave fin inicio` | Igual en orden inverso |
| `XDEL clave id [id...]` | Elimina entradas |
| `XTRIM clave MAXLEN n` | Recorta a las n más nuevas |
| `XREAD COUNT n STREAMS clave id` | Lee entradas nuevas |
| `XGROUP CREATE clave grupo id` | Crea un consumer group |
| `XREADGROUP GROUP grupo consumidor COUNT n STREAMS clave >` | Lee como consumidor |
| `XACK clave grupo id [id...]` | Acusa recibo de entradas |

#### IDs `<ms>-<seq>`

- `1650000000000-0` → milisegundos del reloj + secuencia.
- `XADD` con `*` hace que Redis genere el ID automáticamente.
- Los IDs son **monótonos crecientes**: se puede pedir "todo lo que venga después de este ID".

#### Añadir y leer

```bash
XADD eventos "*" tipo "login" usuario "ana"
XADD eventos "*" tipo "compra" usuario "luis" importe 50
XLEN eventos                       # (integer) 2
XRANGE eventos - +                 # todas las entradas
XRANGE eventos - + COUNT 1         # solo la primera
XREVRANGE eventos + - COUNT 1      # la última
```

#### Consumer groups

Los **grupos de consumidores** permiten repartir las entradas entre varios consumidores y **acuse de recibo** (`XACK`): cada consumidor lee entradas "pendientes" (`>`) sin pisar a los demás, y las elimina del historial pendiente al acusarlas.

```bash
XGROUP CREATE eventos grupo_emails 0          # crear grupo desde el inicio
XREADGROUP GROUP grupo_emails worker-1 COUNT 1 STREAMS eventos >
XREADGROUP GROUP grupo_emails worker-2 COUNT 1 STREAMS eventos >
XACK eventos grupo_emails 1650000000000-0     # acusar recibo
```

Flujo típico:

1. Productores: `XADD` entradas al stream.
2. `XGROUP CREATE` define un grupo con un ID de partida (`0` = desde el inicio, `$` = solo nuevas).
3. Consumidores: `XREADGROUP GROUP <grupo> <nombre> COUNT n STREAMS <clave> >`.
4. Tras procesar, `XACK` elimina la entrada de la lista *pending* del grupo.
5. Entradas pendientes sin acuse se recuperan con `XPENDING` y `XAUTOCLAIM`.

**Diferencias con las Listas para colas:**

| Aspecto | Lista (`LPUSH`/`RPOP`) | Stream con grupos |
|---|---|---|
| Reparto entre consumidores | pop (uno consume) | leído por varios, acuse explícito |
| Reintentos | manual (cola de procesando) | pending + `XAUTOCLAIM` |
| Historial | no | sí (`XRANGE`) |
| IDs | no | `<ms>-<seq>` automáticos |

### Tabla comparativa: cuándo usar cada estructura

| Necesidad | Estructura | Comandos clave |
|---|---|---|
| Caché simple, tokens, contadores | `STRING` | `SET`, `GET`, `INCR` |
| Cola FIFO / pila / timeline | `LIST` | `LPUSH`, `RPOP`, `LRANGE` |
| Pertenencia, deduplicación, tags | `SET` | `SADD`, `SISMEMBER`, `SINTER` |
| Objeto con atributos / sesión | `HASH` | `HSET`, `HGETALL`, `HINCRBY` |
| Ranking, prioridad, ventana temporal | `ZSET` | `ZADD`, `ZREVRANGE`, `ZINCRBY` |
| Presencia booleana masiva / analítica | `BITMAP` | `SETBIT`, `BITCOUNT`, `BITOP` |
| Ubicaciones y distancia | `GEO` (ZSET interno) | `GEOADD`, `GEOSEARCH`, `GEODIST` |
| Mensajería, eventos, colas con acuse | `STREAM` | `XADD`, `XREADGROUP`, `XACK` |

**Decisión rápida:**

1. ¿Es un valor único o contador? → `STRING`.
2. ¿Necesito orden de inserción y extraer por los extremos? → `LIST`.
3. ¿Solo pertenece o no pertenece, sin duplicados? → `SET`.
4. ¿Es un objeto con varios atributos? → `HASH`.
5. ¿Necesito ordenar por un número (puntos, tiempo)? → `ZSET`.
6. ¿Es una secuencia de eventos que varios consumidores deben procesar con acuse? → `STREAM`.
7. ¿Son posiciones geográficas? → comando `GEO`.
8. ¿Es solo un bit por usuario/día? → `BITMAP`.

### Buenas prácticas con estructuras

- **Modela primero**: decide el tipo antes de escribir; Redis no permite cambiar de tipo sin borrar.
- Usa `TYPE` para depurar: verás `list`, `set`, `zset`, `hash`, `stream`.
- Las claves de gran tamaño (`HGETALL`, `SMEMBERS`, `LRANGE 0 -1`) sobre listas/sets enormes pueden bloquear: usa `HSCAN`, `SSCAN` o `LRANGE` acotado.
- En colas de trabajo, prefiere `LMOVE`/`RPOPLPUSH` para mover a una cola de reintentos en vez de `RPOP` + `LPUSH` separados.
- Los ZSET se escalan bien, pero recuerda que `ZRANK` es O(log N) con N = millones: es razonable para rankings.
- En Streams, elimina entradas viejas con `XTRIM` para controlar memoria.

## Ejemplos de código

### Bloque 1: Listas como cola de trabajos

```bash
RPUSH jobs:trabajos "job-1" "job-2" "job-3"
LLEN jobs:trabajos
LRANGE jobs:trabajos 0 -1
LPOP jobs:trabajos
LPOP jobs:trabajos
RPOPLPUSH jobs:trabajos jobs:procesando
LRANGE jobs:trabajos 0 -1
LRANGE jobs:procesando 0 -1
```

### Bloque 2: Hashes de sesión y contadores

```bash
HSET sesion:77 usuario "ana" ip "192.168.1.5" intentos 0
HGET sesion:77 usuario
HMGET sesion:77 usuario ip
HINCRBY sesion:77 intentos 1
HINCRBY sesion:77 intentos 1
HGETALL sesion:77
HSTRLEN sesion:77 ip
```

### Bloque 3: Sets — tags y deduplicación

```bash
SADD articulo:1:tags "redis" "db" "cache"
SADD articulo:2:tags "db" "python"
SINTER articulo:1:tags articulo:2:tags
SUNION articulo:1:tags articulo:2:tags
SDIFF articulo:1:tags articulo:2:tags
SISMEMBER articulo:1:tags "redis"
SCARD articulo:1:tags
SINTERSTORE comunes articulo:1:tags articulo:2:tags
```

### Bloque 4: Sorted sets — ranking en vivo

```bash
ZADD ranking:puntos 100 "ana" 80 "luis" 95 "maria"
ZINCRBY ranking:puntos 30 "luis"
ZREVRANGE ranking:puntos 0 -1 WITHSCORES
ZRANK ranking:puntos "luis"
ZREVRANK ranking:puntos "luis"
ZRANGEBYSCORE ranking:puntos 80 95
ZCOUNT ranking:puntos 80 100
ZREM ranking:puntos "maria"
```

### Bloque 5: Bitmaps, geo y streams

```bash
SETBIT presencia:2026-08-19 7 1
SETBIT presencia:2026-08-19 42 1
BITCOUNT presencia:2026-08-19
GETBIT presencia:2026-08-19 7

GEOADD tiendas -99.13 19.43 "tienda-1" -99.10 19.46 "tienda-2"
GEODIST tiendas "tienda-1" "tienda-2" km
GEOSEARCH tiendas FROMLONLAT -99.12 19.44 BYRADIUS 10 km ASC WITHDIST

XADD eventos "*" tipo "login" usuario "ana"
XADD eventos "*" tipo "login" usuario "luis"
XLEN eventos
XRANGE eventos - +
XGROUP CREATE eventos grupo-log 0
XREADGROUP GROUP grupo-log worker-1 COUNT 1 STREAMS eventos >
XACK eventos grupo-log 0-0
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico (Listas y Hashes)](../ejercicios/nivel-02-basico/)
  - [Listas básicas](ejercicios/nivel-02-basico/ejercicio-01-listas-basicas/ejercicio-01-listas-basicas.md)
  - [Listas: pop e indexado](ejercicios/nivel-02-basico/ejercicio-02-listas-pop-y-indexado/ejercicio-02-listas-pop-y-indexado.md)
  - [Listas avanzadas](ejercicios/nivel-02-basico/ejercicio-03-listas-avanzadas/ejercicio-03-listas-avanzadas.md)
  - [Hashes básicos](ejercicios/nivel-02-basico/ejercicio-04-hashes-basicos/ejercicio-04-hashes-basicos.md)
  - [Hashes contadores](ejercicios/nivel-02-basico/ejercicio-05-hashes-contadores/ejercicio-05-hashes-contadores.md)
  - [Hashes búsqueda](ejercicios/nivel-02-basico/ejercicio-06-hashes-busqueda/ejercicio-06-hashes-busqueda.md)
- [Ejercicios nivel 03 — Intermedio (Sets y Sorted sets)](../ejercicios/nivel-03-intermedio/)
  - [Sets básicos](ejercicios/nivel-03-intermedio/ejercicio-01-sets-basicos/ejercicio-01-sets-basicos.md)
  - [Sets operaciones](ejercicios/nivel-03-intermedio/ejercicio-02-sets-operaciones/ejercicio-02-sets-operaciones.md)
  - [Sorted sets básicos](ejercicios/nivel-03-intermedio/ejercicio-03-sorted-sets-basicos/ejercicio-03-sorted-sets-basicos.md)
  - [Sorted sets rangos](ejercicios/nivel-03-intermedio/ejercicio-04-sorted-sets-rangos/ejercicio-04-sorted-sets-rangos.md)

## Errores comunes

1. **`WRONGTYPE Operation against a key holding the wrong kind of value` al usar `HSET`/`LPUSH`**
   - **Causa**: la clave ya existe con otro tipo (p. ej., creaste `usuario:1` con `SET` y luego intentas `HSET`).
   - **Solución**: borra con `DEL` antes de cambiar de tipo, o verifica con `TYPE` cuál es el tipo actual.

2. **Esperar que `SMEMBERS` devuelva siempre el mismo orden**
   - **Causa**: los Sets **no garantizan orden**; el orden depende de la implementación interna y la historia de la clave.
   - **Solución**: ordena en el cliente o usa un `ZSET` si el orden importa.

3. **Creer que `RPUSH`/`LPUSH` con un elemento repetido lo elimina**
   - **Causa**: las Listas **sí permiten duplicados**; la deduplicación es solo de Sets.
   - **Solución**: usa `SADD` si quieres unicidad; usa `LREM` si necesitas limpiar repetidos de una Lista.

4. **`ZRANGE` con `WITHSCORES` que parece no ordenar por score**
   - **Causa**: `ZRANGE` ordena por posición; el orden por score en la salida solo se garantiza cuando los scores difieren (los empates van lexicográficos).
   - **Solución**: para filtrar por rango de score usa `ZRANGEBYSCORE`; para orden descendente usa `ZREVRANGE`/`ZREVRANGEBYSCORE`.

5. **`LREM` con `count 0` no elimina nada**
   - **Causa**: `count 0` significa "eliminar **todas** las coincidencias", no "ninguna".
   - **Solución**: usa `count 1` (desde el inicio), `count -1` (desde el final) o `0` (todas) según lo que necesites.

6. **`LTRIM clave 0 -1` y "no veo cambio"**
   - **Causa**: `0 -1` recorta a la lista **completa**, así que no cambia nada; para vaciar hay que usar un rango inválido como `LTRIM clave 1 0`.
   - **Solución**: usa `DEL` para borrar toda la lista, o `LTRIM clave 0 N-1` para conservar solo los N primeros.

7. **Dos consumidores procesan la misma entrada de un Stream**
   - **Causa**: usaron `XREAD` en vez de `XREADGROUP`; `XREAD` no reparte ni registra acuses.
   - **Solución**: usa `XREADGROUP GROUP <grupo> <consumidor> ... STREAMS clave >` y acusa con `XACK` después de procesar.

8. **`GEORADIUS` no encontrado o comportamiento raro**
   - **Causa**: en Redis 7 la API moderna es `GEOSEARCH`; `GEORADIUS` está obsoleto y sus firmas cambian entre versiones.
   - **Solución**: usa `GEOSEARCH ... BYRADIUS`/`BYBOX` con `FROMMEMBER` o `FROMLONLAT`.

9. **`BITCOUNT` cuenta más bits de los esperados**
   - **Causa**: `BITCOUNT` cuenta **toda** la clave por defecto, y el rango opcional es en **bytes**, no bits.
   - **Solución**: cuenta sobre el rango de bytes correcto con `BITCOUNT clave inicio_byte fin_byte`, o usa `BITPOS` para localizar.

10. **Guardar score como cadena con `ZADD` y que se trunque**
    - **Causa**: los scores son **números de coma flotante**; valores como `"1e10"` o demasiados decimales pueden redondearse.
    - **Solución**: codifica números grandes como múltiplos (p. ej., `ms * 1000 + n`) o usa enteros dentro del rango preciso de `double`.

11. **`HGETALL` devuelve lista plana y cuesta leerla**
    - **Causa**: `HGETALL` devuelve pares `campo, valor` alternados; no es un mapa anidado.
    - **Solución**: usa `--raw` para scripts y en el cliente transforma pares (pares consecutivos).

12. **No distinguir `LPOP` (extrae) de `LINDEX` (lee)**
    - **Causa**: `LPOP` **elimina** el elemento y devuelve `nil` cuando la lista está vacía; `LINDEX` solo lee y falla con índice fuera de rango.
    - **Solución**: decide si el elemento debe salir de la cola (pop) o solo inspeccionarse (index/range).

13. **Score en `ZADD` con `"NaN"` o `"inf"` que produce resultados extraños**
    - **Causa**: `ZADD` acepta `+inf`/`-inf`, y `NaN` es rechazado; sumar infinitos con `ZINCRBY` puede corromper el orden.
    - **Solución**: valida los scores en la aplicación y evita operaciones que generen `NaN`/infinitos.

14. **Un Stream crece sin límite y consume RAM**
    - **Causa**: los Streams guardan **todo** lo añadido; sin `XTRIM`, crecen indefinidamente.
    - **Solución**: usa `XTRIM clave MAXLEN ~ 10000` (límite aproximado, más eficiente) o una estrategia de retención por política.

## Recursos

- Documentación oficial de tipos de datos: https://redis.io/docs/data-types/
- Comando de Listas: https://redis.io/commands/?group=list
- Comando de Hashes: https://redis.io/commands/?group=hash
- Comando de Sets: https://redis.io/commands/?group=set
- Comando de Sorted Sets: https://redis.io/commands/?group=sorted_set
- Bitmaps: https://redis.io/docs/data-types/bitmaps/
- Geospatial: https://redis.io/docs/data-types/geospatial/
- Streams (introducción): https://redis.io/docs/data-types/streams/
- Tutorial de consumer groups: https://redis.io/docs/data-types/streams-tutorial/
- Referencia de complejidades (docs de cada comando): https://redis.io/commands/