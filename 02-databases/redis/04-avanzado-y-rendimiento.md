# 04 — Avanzado y rendimiento

## Objetivos

- [ ] Explicar la expiración lazy y activa de claves con TTL
- [ ] Elegir y configurar la política de expulsión con maxmemory-policy
- [ ] Comparar noeviction, allkeys-lru, volatile-lru, allkeys-lfu y volatile-ttl
- [ ] Elegir LRU vs LFU según el caso (caché vs datos persistentes)
- [ ] Explicar por qué KEYS bloquea el servidor y usar SCAN en su lugar
- [ ] Usar SCAN con cursor, MATCH y COUNT, y conocer sus garantías
- [ ] Detectar big keys con DEBUG OBJECT y redis-cli --bigkeys
- [ ] Entender por qué las big keys degradan el rendimiento
- [ ] Usar SLOWLOG GET/RESET e interpretar las entradas
- [ ] Implementar el patrón cache-aside
- [ ] Mitigar penetración, avalancha y desglose de caché
- [ ] Implementar rate limiting con fixed window (INCR+EXPIRE) y sliding window (ZSET)
- [ ] Diseñar colas de trabajo, sesiones, contadores y rankings con Redis
- [ ] Usar PUBLISH/SUBSCRIBE y entender la pérdida de mensajes sin suscriptores
- [ ] Explicar el sharding por hash slot del Cluster (CRC16, 16384 slots)
- [ ] Proteger Redis con requirepass y ACLs (USER, NOPERM, CAT)
- [ ] Monitorizar con INFO, MONITOR (solo debug) y redis-benchmark

## Apuntes

### Expiración de claves

Redis permite fijar un tiempo de vida (TTL) a cada clave con EXPIRE, PEXPIRE o el
argumento `EX`/`PX` de SET. Las claves expiradas se eliminan con **dos estrategias
combinadas**: expiración **perezosa (lazy)** y expiración **activa**.

#### Expiración perezosa (lazy)

- Una clave solo se borra **cuando se accede a ella** y su TTL ya venció.
- Al ejecutar un comando sobre una clave expirada, Redis la descarta y devuelve
  nil / 0 como si no existiera.
- Es la primera línea de defensa: nunca verás una clave expirada "viva" al leerla.

#### Expiración activa

- Redis también recorre periódicamente (por defecto, 10 veces por segundo) una
  muestra aleatoria de claves con TTL y elimina las vencidas.
- El objetivo es no dejar acumular miles de claves muertas solo porque nadie las
  lee. El barrido es **acotado** para no bloquear el servidor.

**Consecuencia práctica**: una clave expirada ocupa memoria hasta que la lees o
hasta que el ciclo activo la limpia. Con muchísimas claves con TTL, `INFO
expired_keys` te dice cuántas se han eliminado.

```
> SET sesion:1 "token-abc" EX 300
OK
> TTL sesion:1
(integer) 298
> EXPIRE contador 60
(integer) 1
> PERSIST contador        # quitar el TTL
OK
> INFO stats | grep expired_keys
expired_keys:123
```

Tabla de comandos de expiración:

| Comando | Descripción | Complejidad |
|---|---|---|
| EXPIRE key s | Pone TTL en segundos | O(1) |
| PEXPIRE key ms | Pone TTL en milisegundos | O(1) |
| EXPIREAT key timestamp | Expira en timestamp Unix | O(1) |
| TTL key | Segundos que quedan (-1 sin TTL, -2 inexistente) | O(1) |
| PTTL key | Milisegundos que quedan | O(1) |
| PERSIST key | Elimina el TTL | O(1) |

#### maxmemory y políticas de expulsión

Cuando el uso de memoria alcanza `maxmemory`, Redis aplica la política
`maxmemory-policy` para decidir qué claves expulsar (si expulsa alguna):

| Política | Alcance | Comportamiento |
|---|---|---|
| noeviction | — | Devuelve error en escrituras; no expulsa nada |
| allkeys-lru | Todas las claves | Expulsa la menos usada recientemente |
| volatile-lru | Solo con TTL | Expulsa la menos usada recientemente (entre las con TTL) |
| allkeys-lfu | Todas las claves | Expulsa la menos frecuente (frecuencia de uso) |
| volatile-lfu | Solo con TTL | Expulsa la menos frecuente (entre las con TTL) |
| volatile-ttl | Solo con TTL | Expulsa la que expira antes |
| volatile-random | Solo con TTL | Expulsa una aleatoria |
| allkeys-random | Todas las claves | Expulsa una aleatoria |

```
> CONFIG SET maxmemory 100mb
OK
> CONFIG SET maxmemory-policy allkeys-lru
OK
> CONFIG GET maxmemory-policy
1) "maxmemory-policy"
2) "allkeys-lru"
```

**Claves importantes**:
- `volatile-*` **no toca** las claves sin TTL: útil si quieres preservar datos
  permanentes y expulsar solo lo temporal.
- Si no hay claves con TTL y usas `volatile-*`, Redis se comporta como
  noeviction (empieza a rechazar escrituras).
- `allkeys-*` puede expulsar **cualquier** clave, incluida la que acabas de
  escribir si la memoria está al límite.

#### LRU vs LFU: cómo elegir

- **LRU** (Least Recently Used): expulsa la clave que hace más que no se usa.
  Aproximado en Redis (muestreo de `maxmemory-samples`), no exacto.
- **LFU** (Least Frequently Used): expulsa la clave con menor frecuencia de acceso
  histórica. Mejor para cargas con patrones estables (una clave muy usada en un
  momento puntual no se expulsa solo por no haberse tocado hace tiempo).

| Criterio | LRU | LFU |
|---|---|---|
| Modelo mental | "No la tocan desde hace tiempo" | "Casi nunca la tocan" |
| Caso típico | Caché con accesos recientes | Caché con picos y accesos sostenidos |
| Parámetros extra | maxmemory-samples | lfu-log-factor, lfu-decay-time |
| Coste | Menor | Algo mayor (contabilidad de frecuencia) |

**Regla práctica**: para una caché genérica, `allkeys-lru`. Para datos
persistentes que no deben perderse, o sin TTL, usa `volatile-lru` o noeviction.
Usa `allkeys-lfu` si tu carga de trabajo tiene claves "calientes" de larga
duración que hay que preservar.

### SCAN vs KEYS

KEYS es cómodo pero peligroso: **recorre TODAS las claves y bloquea el servidor**
durante todo el recorrido (single-threaded). En producción, con millones de
claves, un KEYS puede congelar Redis durante segundos.

#### Por qué KEYS bloquea

KEYS se ejecuta en el hilo principal: mientras recorre y compara patrones, ningún
otro cliente puede hacer nada. La complejidad es O(N) sobre todas las claves.

```
> KEYS *
1) "usuario:1"
2) "usuario:2"
   ... (con 5M de claves, esto bloquea varios segundos)
```

#### SCAN con cursor

SCAN recorre el espacio de claves **por partes**: cada llamada devuelve un cursor
para continuar y un conjunto pequeño de claves. Nunca bloquea mucho rato.

```
> SCAN 0
1) "17"                       # cursor para la siguiente iteración
2) 1) "k1"
   2) "k2"
> SCAN 17
1) "0"                        # cursor 0 → recorrido terminado
2) 1) "k9"
```

El patrón típico desde un cliente:

```
cursor = "0"
repeat:
    cursor, claves = SCAN cursor
    procesar(claves)
until cursor == "0"
```

#### MATCH y COUNT

- `MATCH patron`: filtra por patrón glob. **Importante**: MATCH filtra lo que ya
  devolvió SCAN; no reduce el coste del recorrido.
- `COUNT n`: sugiere cuántos elementos devolver por llamada (por defecto 10). Es
  una sugerencia, no una garantía; valores grandes (1000) aceleran el recorrido a
  costa de bloquear un poco más.

```
> SCAN 0 MATCH usuario:* COUNT 1000
1) "8123"
2) 1) "usuario:1"
   2) "usuario:2"
```

#### Garantías de SCAN

- **Termina siempre**: volviendo cursores eventualmente llegarás a 0.
- **Completa (bajo ciertas condiciones)**: si el dataset no se modifica durante el
  recorrido, se garantiza que SCAN ve cada clave al menos una vez.
- **Puede repetir claves**: durante el recorrido, una clave puede aparecer más de
  una vez; tu código debe tolerar duplicados.
- **Si se añaden/eliminan claves** durante el recorrido, una clave puede no
  aparecer. SCAN no da una foto consistente.

Variantes para los otros tipos de datos: HSCAN, SSCAN, ZSCAN.

### Big keys

Una **big key** es una clave cuyo valor es muy grande (un string de varios MB, una
lista/hash/set/zset con cientos de miles de elementos). No hay un umbral oficial;
un buen criterio es "una clave cuyo valor no cabe en memoria holgada y degrada el
rendimiento".

#### Por qué son un problema

- **Comandos que la recorren bloquean**: LRANGE 0 -1, HGETALL, SMEMBERS, ZRANGE
  sobre una big key bloquean el servidor mientras copian el valor.
- **Afectan a la replicación y AOF**: cada cambio de la clave se reenvía/replica
  completo, duplicando el coste.
- **Dificultan el failover**: la copia inicial a una réplica o el rehash en clúster
  cargan la clave entera a la vez.
- **Fragmentan la memoria**: valores grandes suelen fragmentarse.

#### Detección

`redis-cli --bigkeys` recorre el dataset con SCAN y muestra las 5 claves más
grandes por tipo:

```bash
redis-cli --bigkeys
# Biggest string found so far '"usuario:42"' with 52428800 bytes
# Biggest list   found so far '"cola:logs"'  with 1000001 items
```

También puedes inspeccionar una clave concreta:

```
> DEBUG OBJECT usuario:42
Value at:0x... refcount:1 encoding:raw serializedlength:52428800 ...
> STRLEN usuario:42
(integer) 52428800
```

El campo `serializedlength` da una aproximación del tamaño en bytes.

#### Qué hacer con las big keys

- **Dividirlas**: un hash gigante se puede shardear por rango de campos
  (`usuario:42:datos:0..999`), o una lista enorme separarse por fechas.
- **Usar el tipo correcto**: si solo necesitas rangos pequeños, LRANGE con índices
  en lugar de traer todo; si necesitas agregación, script Lua server-side.
- **Evitar comandos completos**: HSCAN/SSCAN/ZSCAN en lugar de HGETALL/SMEMBERS.

### Slow queries (SLOWLOG)

Redis registra los comandos que superan un umbral de tiempo de ejecución en el
**slow log**.

#### Configuración

```
> CONFIG SET slowlog-log-slower-than 10000    # umbral en microsegundos (10 ms)
OK
> CONFIG SET slowlog-max-len 128              # entradas que se guardan
OK
```

#### SLOWLOG GET y SLOWLOG RESET

```
> SLOWLOG GET 2
1) 1) (integer) 14             # id de la entrada
   2) (integer) 1724180000     # timestamp Unix
   3) (integer) 23456          # microsegundos que tardó
   4) 1) "KEYS"                # comando
      2) "user*"
   5) "127.0.0.1:6379"         # cliente
   6) ""                       # nombre del cliente (si hay)
> SLOWLOG LEN
(integer) 14
> SLOWLOG RESET
OK
```

#### Cómo interpretarlo

- Un comando en el slow log no significa "bug": significa que tardó más que tu
  umbral (que debe fijarse en función de tu SLA de latencia).
- Revisa **qué comandos** aparecen con frecuencia (KEYS, HGETALL, LRANGE, Lua) y
  optimízalos (SCAN, rangos acotados, scripts cortos).
- El slow log no captura el tiempo de espera de red ni la cola: mide la ejecución
  efectiva en el hilo principal.

### Patrones de producción

Estos son los patrones de diseño más usados con Redis en aplicaciones reales.

#### Cache-aside

La aplicación lee primero la caché; si no hay dato (miss), lee de la fuente
(BD/API), escribe el resultado en Redis con TTL y lo devuelve.

```
GET cache:usuario:42        → miss
GET de la BD                → dato
SET cache:usuario:42 "dato" EX 300
```

**Invalidación**: al actualizar, la aplicación borra la clave (`DEL`) o la
reescribe. El TTL garantiza que un fallo de invalidación no deja datos eternos.

#### Penetración de caché, avalancha y desglose

- **Penetración**: ataques/consultas de claves **que no existen** (ej. ids 0, -1).
  Cada consulta llega a la BD. Mitigación: cachear el "no existe" con TTL corto,
  o filtros de Bloom.
- **Desglose (breakdown)**: una clave **muy caliente** expira justo cuando hay un
  pico; todas las peticiones golpean la BD a la vez. Mitigación: mutex/redis lock
  para reconstruir una sola vez, o TTL "suave" con valor expirado pero devuelto.
- **Avalancha**: muchas claves expiran a la vez y todas las peticiones caen sobre
  la BD. Mitigación: TTL con **jitter** (aleatorizar +0..N s), o precalentamiento.

```
# TTL con jitter para evitar avalanchas
> SET producto:1 '{"precio":100}' PX 300000
> SET producto:2 '{"precio":150}' PX 300000+rand
```

#### Rate limiting: fixed window (INCR + EXPIRE)

Límite de N peticiones por ventana fija (ej. 5 por minuto). Se usa INCR y el
primer INCR fija el TTL de la ventana:

```
> INCR rate:user:7
(integer) 1
> EXPIRE rate:user:7 60
(integer) 1
```

Si el valor supera N, se rechaza. Sencillo y de O(1), pero tiene un punto débil:
los límites coinciden con el borde de la ventana (puede haber 2N peticiones en
menos de una ventana si se cruza el límite).

#### Rate limiting: sliding window (ZSET)

Ventana deslizante exacta con un sorted set por usuario: cada petición añade un
miembro con score = timestamp; se borran las entradas fuera de la ventana y se
cuentan las restantes.

```
> ZREMRANGEBYSCORE rate:user:7 0 <ahora - 60_000>
> ZADD rate:user:7 <ahora> peticion-123
> ZCARD rate:user:7
(integer) 5
```

Se borran con una TTL global (por ejemplo `EXPIRE rate:user:7 120`) para no dejar
zsets eternos. Es exacto pero de mayor coste (dos Z* + ZCARD); para volúmenes muy
altos se prefiere el fixed window o un script Lua.

#### Colas de trabajo

LPUSH + BRPOP forman una cola FIFO con pop **bloqueante**: los workers esperan sin
consumir CPU.

```
# productor
> LPUSH cola:emails "bienvenida@a.com"
> LPUSH cola:emails "promo@b.com"
# consumidor (bloquea hasta que haya trabajo)
> BRPOP cola:emails 0
1) "cola:emails"
2) "promo@b.com"
```

Ventaja clave: si un worker muere procesando, la tarea puede reintentarse
(relaunch con lpush de vuelta). Para "entregar y no perder si falla" se suelen
usar listas + conjuntos de procesando, o Streams con grupos de consumidores.

#### Sesiones

Almacenar sesiones con clave `sesion:<id>`, valor hash/string con TTL:

```
> SET sesion:abc123 '{"user":42,"exp":...}' EX 3600
OK
> GET sesion:abc123
```

La sesión "muere" sola por el TTL; el logout borra con DEL. Redis permite
compartir sesiones entre todos los servidores de una app (estado centralizado).

#### Contadores

INCR / INCRBY / DECR son atómicos, ideales para contadores de visitas, likes,
descargas. Con EXPIRE se convierten en contadores por ventana.

```
> INCR stats:visitas:2026-08-19
(integer) 1
> INCRBY stats:likes:post:99 5
(integer) 5
```

#### Rankings

Los sorted sets son el ranking por naturaleza: score = puntos, miembro = jugador.

```
> ZADD ranking 100 "ana" 90 "bea" 85 "carlos"
(integer) 3
> ZREVRANGE ranking 0 2 WITHSCORES
1) "ana"
2) "100"
> ZINCRBY ranking 10 "bea"     # actualizar puntuación
> ZREVRANK ranking "carlos"    # posición del jugador
(integer) 2
```

#### Pub/Sub

PUBLISH/SUBSCRIBE envían mensajes a canales. Es **fire-and-forget**: si no hay
suscriptor cuando se publica, el mensaje **se pierde** (no hay cola ni
persistencia).

```
# suscriptor (sesión 1)
> SUBSCRIBE noticias
Reading messages... (press Ctrl-C to quit)
# publicador (sesión 2)
> PUBLISH noticias "¡Hola!"
(integer) 1
```

- `PUBLISH canal msg` devuelve el número de suscriptores que recibieron el mensaje.
- `SUBSCRIBE` pone el cliente en modo suscripción (solo puede usar comandos de
  pub/sub).
- PSUBSCRIBE permite patrones (`PSUBSCRIBE noticias.*`).
- Para entrega durable y fan-out con histórico usa **Streams** (XADD/XREADGROUP),
  no Pub/Sub.

### Introducción a Redis Cluster

Redis Cluster reparte los datos entre varios nodos y da **escala horizontal**
automática con alta disponibilidad.

#### Sharding por hash slot

- El espacio de claves se divide en **16384 slots**.
- Cada clave se asigna a un slot con `HASH_SLOT = CRC16(clave) % 16384`.
- Cada nodo del cluster es dueño de un **rango de slots** (ej. nodo A: 0-5460,
  nodo B: 5461-10922, nodo C: 10923-16383).
- El cliente calcula el slot y habla con el nodo correcto; si acierta en el nodo
  equivocado, el nodo responde un redireccionamiento MOVED (o ASK durante una
  migración).

```
> CLUSTER INFO
cluster_state:ok
cluster_slots_assigned:16384
> CLUSTER KEYSLOT usuario:1
(integer) 5798
```

#### Por qué 16384 slots

- Suficientemente grande para repartir bien con pocos nodos y rebalancear con
  costo bajo.
- Suficientemente pequeño para que los mensajes de heartbeat entre nodos quepan
  en un solo paquete (el mapa de slots se propaga como bitmap en los mensajes
  gossip; 16384 bits = 2 KB).
- Permite redimensionar el cluster moviendo **rangos de slots** (migración
  gradual) sin rehash total de las claves.

#### Replicación en Cluster

- Cada nodo maestro puede tener **réplicas** (nodos esclavos).
- Si un maestro cae, su réplica promueve a maestro (failover automático) y se
  reasignan los slots.
- El cluster requiere como mínimo 3 maestros y tolera la caída de un nodo si hay
  mayoría (quórum) — la **red** debe permitir que todos los nodos se hablen entre
  sí en los puertos de cluster (bus de cluster, por defecto puerto + 10000).

#### Redes y arranque

```
# cada nodo
redis-server --cluster-enabled yes --port 7000
redis-server --cluster-enabled yes --port 7001
redis-server --cluster-enabled yes --port 7002

# montar el cluster
redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 \
  --cluster-replicas 0
# añadir nodo
redis-cli --cluster add-node 127.0.0.1:7003 127.0.0.1:7000
# redistribuir slots
redis-cli --cluster reshard 127.0.0.1:7000
```

**Ojo con las llaves multi-slot**: comandos con varias claves (MGET, DEL k1 k2, o
transacciones) solo funcionan si todas las claves están en el mismo slot. Se
resuelve con **hash tags**: `{usuario:42}:carrito` y `{usuario:42}:pedidos` caen
en el mismo slot porque el hash se calcula solo sobre lo que está entre `{}`.

### Seguridad

Redis por defecto es una **base de datos sin autenticación**: quien pueda
conectarse a la IP/puerto puede leer y escribir. Nunca lo expongas a Internet sin
protegerlo.

#### requirepass

Contraseña global (toda conexión la necesita):

```conf
requirepass mi-contraseña-fuerte
```

```
> AUTH mi-contraseña-fuerte
OK
```

Limitaciones: una sola contraseña para todos los usuarios; no permite permisos
finos.

#### ACLs (Access Control Lists)

Desde Redis 6, ACLs permiten usuarios, contraseñas y permisos por comando y por
clave.

```
> ACL SETUSER appdev on >clave-dev ~* +@all -@dangerous
OK
> ACL SETUSER appprod on >clave-prod ~cache:* +get +set +expire +ttl
OK
> ACL WHOAMI
"default"
> ACL LIST
1) "user default on nopass ~* &* +@all"
2) "user appdev on ..."
> ACL DELUSER appdev
OK
```

Componentes de un usuario ACL:

| Elemento | Significado |
|---|---|
| on / off | Usuario habilitado o no |
| \>contraseña | Asigna/renueva contraseña |
| <contraseña | Elimina contraseña |
| ~patrón | Patrón de claves a las que puede acceder (`~*` = todas) |
| \&patrón | Canales de pub/sub permitidos |
| +comando | Permite un comando (`+get`, `+set`) |
| -comando | Prohíbe un comando (`-flushall`, `-debug`) |
| +@cat | Permite una categoría de comandos (`+@read`, `+@write`, `+@admin`) |
| -@cat | Prohíbe una categoría (`-@dangerous`, `-@admin`) |
| allcommands / nocommands | Permite / prohíbe todos |
| allkeys / resetkeys | Todas / ninguna clave |
| NOPERM | (en respuestas) error: comando no permitido |

`+@all -@dangerous` es una forma habitual de "todo excepto lo peligroso"
(FLUSHALL, DEBUG, SHUTDOWN, CONFIG, KEYS, EVAL...). La categoría `@dangerous`
agrupa los comandos de riesgo.

#### Riesgo de exponer Redis en internet

- Sin AUTH, cualquiera puede **vaciarlo** (FLUSHALL), **leer datos** o usarlo como
  pivot para ataques (por ejemplo, escribir claves con payloads para explotar
  aplicaciones que deserializan).
- Con `requirepass` débil, es trivial de forzar (hay "shodans" de Redis abiertos).
- **Recomendaciones**: `bind` a IPs privadas, firewall (nunca 6379 abierto al
  público), `protected-mode yes`, `rename-command` para comandos peligrosos, y
  ACLs mínimas. Si es gestionado (Redis Cloud / AWS ElastiCache), protege el
  security group.

```
> CONFIG SET protected-mode yes
OK
# redis.conf
rename-command FLUSHALL ""        # deshabilitar
rename-command CONFIG "admin-config"  # renombrar a uno secreto
```

### Monitoreo

#### INFO

Exposición de métricas por sección (ver guía 03). Las secciones más útiles para
rendimiento:

```
> INFO memory        # used_memory, maxmemory, mem_fragmentation_ratio
> INFO stats         # instantaneous_ops_per_sec, keyspace_hits/misses
> INFO clients       # connected_clients, blocked_clients
> INFO commandstats  # calls y ussec_per_call por comando (para hot spots)
> INFO keyspace      # claves por db
```

```
> INFO stats | grep keyspace_hits
keyspace_hits:99100
keyspace_misses:900
# hit ratio ≈ 99 % → caché sana
```

#### MONITOR

`MONITOR` imprime **cada comando** que llega al servidor en tiempo real:

```
> MONITOR
1724180000.123 [0 127.0.0.1:52301] "GET" "usuario:42"
1724180000.125 [0 127.0.0.1:52302] "SET" "cache:x" "1"
```

**Solo para depurar**: MONITOR es un comando privilegiado, consume muchísimo CPU
y puede **duplicar la carga** del servidor. Nunca lo dejes corriendo en
producción; úsalo brevemente y con `+@dangerous` restringido.

#### redis-benchmark

Genera carga sintética para medir rendimiento y capacidad:

```bash
# 100.000 peticiones, 50 conexiones
redis-benchmark -h 127.0.0.1 -p 6379 -n 100000 -c 50 -t set,get,incr

# resultados típicos
# SET: 91234.53 requests per second
# GET: 101000.00 requests per second
# INCR: 90000.00 requests per second
```

- `-t set,get,incr`: solo esos comandos.
- `-P 100`: pipeline de 100 (mide el efecto del pipeline).
- Úsalo para dimensionar, comparar configuraciones o detectar regresiones; es una
  carga sintética, no tu tráfico real.

## Ejemplos de código

### Expiración y política de memoria

```bash
redis-cli
127.0.0.1:6379> SET cache:producto:1 '{"precio":100}' EX 300
OK
127.0.0.1:6379> TTL cache:producto:1
(integer) 298
127.0.0.1:6379> CONFIG SET maxmemory 100mb
OK
127.0.0.1:6379> CONFIG SET maxmemory-policy allkeys-lru
OK
127.0.0.1:6379> INFO memory | grep maxmemory
maxmemory:104857600
127.0.0.1:6379> INFO stats | grep expired_keys
expired_keys:57
```

### SCAN en lugar de KEYS

```bash
redis-cli
127.0.0.1:6379> SCAN 0 MATCH usuario:* COUNT 100
1) "284"
2) 1) "usuario:1"
   2) "usuario:2"
127.0.0.1:6379> SCAN 284 MATCH usuario:* COUNT 100
1) "0"
2) 1) "usuario:100"
127.0.0.1:6379> SLOWLOG GET 1
1) 1) (integer) 2
   2) (integer) 1724180100
   3) (integer) 341
   4) 1) "KEYS"
      2) "user*"
127.0.0.1:6379> SLOWLOG RESET
OK
```

### Rate limiting con fixed window y sliding window

```bash
redis-cli
# fixed window: máx 5 por minuto
127.0.0.1:6379> INCR rate:user:7
(integer) 1
127.0.0.1:6379> EXPIRE rate:user:7 60
(integer) 1
# sliding window: peticiones de los últimos 60 s
127.0.0.1:6379> ZREMRANGEBYSCORE rate:sw:7 0 1724180000
(integer) 1
127.0.0.1:6379> ZADD rate:sw:7 1724180000 req-001
(integer) 1
127.0.0.1:6379> ZCARD rate:sw:7
(integer) 1
127.0.0.1:6379> EXPIRE rate:sw:7 120
(integer) 1
```

### Cola de trabajo y ranking

```bash
redis-cli
# cola de trabajos
127.0.0.1:6379> LPUSH cola:jobs 'job-1'
(integer) 1
127.0.0.1:6379> BRPOP cola:jobs 0
1) "cola:jobs"
2) "job-1"
# ranking de jugadores
127.0.0.1:6379> ZADD ranking 100 ana 90 bea 85 carlos
(integer) 3
127.0.0.1:6379> ZREVRANGE ranking 0 2 WITHSCORES
1) "ana"
2) "100"
127.0.0.1:6379> ZINCRBY ranking 25 carlos
(integer) 110
127.0.0.1:6379> ZREVRANK ranking carlos
(integer) 0
```

### Pub/Sub y monitoreo

```bash
# terminal 1: suscriptor
redis-cli
127.0.0.1:6379> SUBSCRIBE noticias
Reading messages... (press Ctrl-C to quit)
# terminal 2: publicador
redis-cli
127.0.0.1:6379> PUBLISH noticias "lanzamiento v2"
(integer) 1

# benchmark y monitoreo
redis-benchmark -t set,get -n 100000 -c 50
redis-cli MONITOR
```

## Ejercicios relacionados

- [Ejercicios nivel 04](../ejercicios/nivel-04-*/)

## Errores comunes

### 1. Usar KEYS en producción
**Causa**: buscar patrones con KEYS sobre datasets grandes.
**Solución**: usar SCAN (con MATCH y COUNT) y recorrer con cursor; KEYS bloquea el
servidor completo.

### 2. Ignorar las garantías de SCAN
**Causa**: asumir que SCAN devuelve resultados únicos y completos siempre.
**Solución**: tolerar duplicados en el código; si el dataset cambia a mitad de
recorrido, una clave puede faltar.

### 3. No configurar maxmemory y llenar la RAM
**Causa**: sin maxmemory el sistema operativo acaba matando a Redis (OOM) o este
usa swap.
**Solución**: fijar maxmemory y una política (normalmente `allkeys-lru` para
caché), y vigilar `INFO memory`.

### 4. Elegir allkeys-* para datos que no deben perderse
**Causa**: usar allkeys-lru/allkeys-lfu con claves "de verdad" (contadores,
pedidos).
**Solución**: si las claves son persistentes, `noeviction` o `volatile-*` para que
solo se expulse lo temporal.

### 5. Confundir LRU con LFU
**Causa**: elegir política sin pensar en el patrón de acceso.
**Solución**: LRU para "no usada recientemente", LFU para "poco usada en general";
LFU preserva claves calientes de larga vida.

### 6. No dividir las big keys
**Causa**: un hash/lista gigante en una sola clave.
**Solución**: shardear la clave o usar HSCAN/SSCAN/ZSCAN y rangos acotados; nunca
HGETALL/SMEMBERS/LRANGE 0 -1 sobre valores enormes.

### 7. Ignorar el slow log
**Causa**: no fijar `slowlog-log-slower-than` ni revisar las entradas.
**Solución**: fijar un umbral acorde al SLA y auditar SLOWLOG GET con frecuencia
para encontrar comandos O(N) abusivos.

### 8. Cachear "no existe" sin TTL (penetración)
**Causa**: consultas a claves inexistentes caen siempre en la BD.
**Solución**: cachear el miss con TTL corto o usar filtros de Bloom; además,
aleatorizar TTLs para evitar avalanchas.

### 9. Publicar en Pub/Sub asumiendo entrega garantizada
**Causa**: creer que un mensaje PUBLISH llega aunque no haya suscriptor.
**Solución**: Pub/Sub es fire-and-forget; si necesitas persistencia o replay, usa
Streams (XADD/XREADGROUP).

### 10. Comandos multi-clave en Redis Cluster
**Causa**: MGET/DEL/SUNION entre claves de distintos slots.
**Solución**: usar hash tags `{clave}:sufijo` para que compartan slot, o ejecutar
por nodo.

### 11. Exponer Redis sin autenticación
**Causa**: puerto 6379 abierto sin AUTH ni ACLs; cualquiera puede FLUSHALL o leer
datos.
**Solución**: requirepass o ACLs con usuarios mínimos, `bind` a IPs privadas,
firewall y protected-mode yes.

### 12. Usar MONITOR en producción
**Causa**: dejar MONITOR corriendo "para ver qué pasa"; duplica la carga del
servidor.
**Solución**: usar MONITOR solo brevemente en entornos de depuración; para
métricas usa INFO/SLOWLOG/redis-benchmark.

### 13. Sesiones o caché sin TTL que crecen para siempre
**Causa**: olvidar EXPIRE en claves de sesión/caché.
**Solución**: siempre TTL razonable; revisar `INFO keyspace` para ver claves
acumuladas.

### 14. Fijar un solo TTL para todas las claves
**Causa**: todas expiran a la vez (avalancha de caché).
**Solución**: añadir jitter aleatorio al TTL y precalentar el cache tras
despliegues.

## Recursos

- [Expiración de claves (documentación oficial)](https://redis.io/docs/latest/develop/use/ttl/)
- [Eviction policies (maxmemory)](https://redis.io/docs/latest/reference/eviction/)
- [SCAN y KEYS](https://redis.io/docs/latest/commands/scan/)
- [SLOWLOG](https://redis.io/docs/latest/commands/slowlog-get/)
- [Redis Keyspace Notifications / TTL](https://redis.io/docs/latest/develop/use/keyspace-notifications/)
- [Redis Pub/Sub](https://redis.io/docs/latest/develop/use/pubsub/)
- [Redis Cluster (sharding)](https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/)
- [ACL (Access Control Lists)](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/)
- [Securidad en Redis](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [redis-benchmark](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/benchmarks/)
- [Referencia de comandos](https://redis.io/docs/latest/commands/)