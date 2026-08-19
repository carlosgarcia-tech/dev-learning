# 05 — Patrones y producción
> Guía de patrones de diseño con Redis en producción: caché, rate limiting, sesiones distribuidas, colas, rankings, locks, pub/sub y streams, más despliegue, persistencia, seguridad y monitoreo. Todo comando está escrito para Redis 7.

---
## Objetivos
- [ ] Explicar el patrón **cache-aside (lazy loading)** y cuándo usarlo.
- [ ] Diferenciar cache-aside de write-through y escribir la implementación de cada uno.
- [ ] Identificar el problema de **cache penetration** y aplicar soluciones (cachear "null" y bloom filters).
- [ ] Explicar la **cache avalanche** y mitigarla con jitter en los TTL y fallbacks.
- [ ] Resolver el **cache breakdown (hot key)** con locks `SET NX EX` y renovación de valores.
- [ ] Implementar **rate limiting** con fixed window, sliding window y token bucket (Lua).
- [ ] Elegir la técnica de rate limiting correcta según el caso de uso.
- [ ] Diseñar **sesiones distribuidas** con HASH + EXPIRE y escalarlas horizontalmente.
- [ ] Construir **colas de trabajo** FIFO con `LPUSH` + `BRPOP` y garantías at-least-once.
- [ ] Implementar **contadores de tiempo real** y rankings diarios con `ZINCRBY`.
- [ ] Mantener **leaderboards** con sorted sets, empates y `ZREVRANK`.
- [ ] Crear **distributed locks** seguros con `SET key value NX PX` y conocer sus límites (fencing, Redlock).
- [ ] Distinguir **Pub/Sub** (fire-and-forget) de **Streams** (durables, consumer groups).
- [ ] Desplegar Redis en **standalone, maestro-replica, Sentinel y Cluster**.
- [ ] Aplicar **backups, AOF, seguridad (ACL, TLS) y monitoreo** en producción.

---
## Apuntes
### 1. Cache-aside (lazy loading)
Patrón de caché más común. La aplicación es responsable de poblar y actualizar la caché; Redis solo guarda lo que le piden.
#### 1.1 Flujo de lectura
1. `GET` en Redis.
2. Si existe (hit), devolver el valor directamente.
3. Si no existe (miss), leer de la base de datos.
4. `SET key value EX <ttl>` y devolver al cliente.

Este "cargar solo cuando falla" da nombre a *lazy loading*: la caché se llena a demanda, nunca por adelantado.
#### 1.2 Flujo de escritura
En cache-aside puro, las escrituras van solo a la DB y luego se invalida la caché con `DEL`, evitando escribir dos veces y el riesgo de consistencia entre ambos almacenes.
```
Cliente escribe → UPDATE en DB → DEL cache_key
```
#### 1.3 Ventajas
- Simple de implementar y depurar.
- Solo se cachean datos realmente leídos (uso eficiente de memoria).
- Si la caché falla, el sistema se degrada a DB sin romperse.
- El TTL actúa como red de seguridad ante datos desactualizados.
#### 1.4 Invalidation y problema de staleness
Variantes: TTL corto (dejar expirar, aceptando staleness), invalidación selectiva (`DEL` solo de las claves afectadas), o tags/patterns (frágil en Cluster por los hash slots). El *staleness* es inherente: entre la escritura en DB y la invalidación hay una ventana de lectura de dato viejo. Se acepta cuando la consistencia inmediata no es crítica; para consistencia estricta no se usa caché.
#### 1.5 Ejemplo completo
Caso: catálogo de productos, clave `product:{id}`.

```bash
# 1. Lectura en caché
redis-cli GET product:42
(nil)
# 2. Miss → leer de la base de datos (fuera de Redis)
# 3. Poblar la caché con TTL de 300 s
redis-cli SET product:42 '{"id":42,"name":"Silla ergonómica","price":89.90}' EX 300
# 4. Lectura posterior → hit, sin tocar la DB
redis-cli GET product:42
# 5. El producto cambió de precio → invalidar
redis-cli DEL product:42
```
### 2. Cache-through / write-through
Aquí la aplicación **siempre escribe primero en la caché** y un wrapper propaga la escritura a la DB de forma síncrona.

| Aspecto | Cache-aside | Write-through |
|---|---|---|
| Quién puebla la caché | La aplicación, en el miss | La caché misma (proxy) |
| Escritura | Solo a DB + `DEL` | Caché + DB síncrono |
| Latencia de escritura | Menor (una escritura) | Mayor (dos escrituras) |
| Consistencia | Ventana de staleness | Más fuerte: la caché se actualiza al instante |
| Riesgo | Dato viejo breve | Escribir en caché y que la DB falle |
| Complejidad de código | Baja | Media (write-through layer) |

Ventaja: menos misses y menos datos obsoletos por escritura directa. Desventaja: cada escritura paga la latencia de dos almacenes y se cachean datos quizá nunca leídos. En la práctica muchos sistemas combinan cache-aside para leer con invalidación/write-through para escribir.
### 3. Cache penetration (caché penetración)
Ocurre al consultar **claves que no existen ni en caché ni en DB**: cada petición atraviesa la caché (miss), golpea la DB y devuelve "vacío". Un atacante puede saturar la DB con miles de IDs inventados.
#### 3.1 Solución 1: cachear el "null"
Ante un miss en la DB, guardar un valor centinela (`"NOT_FOUND"`) con TTL **corto** (60–300 s). Las consultas repetidas se responden desde caché.

```bash
redis-cli SET product:999 NOT_FOUND EX 120
redis-cli GET product:999
```
Limitación: un atacante que rota miles de IDs distintos sigue generando misses. Es una mitigación.
#### 3.2 Solución 2: Bloom filter
Responde con certeza "no existe" (falsos positivos posibles, falsos negativos imposibles). Se carga con los IDs válidos y se pregunta antes de ir a la DB.

```bash
# RedisBloom: BF.RESERVE / BF.ADD / BF.EXISTS
redis-cli BF.RESERVE product_catalog 0.01 100000
redis-cli BF.MADD product_catalog 42 100 200 300
redis-cli BF.EXISTS product_catalog 999   # (integer) 0 → cortar
redis-cli BF.EXISTS product_catalog 42    # (integer) 1 → ir a caché/DB
```
Sin el módulo se puede simular con un SET de IDs válidos (caro). El bloom filter es ideal cuando el espacio de claves es grande y casi todas las consultas son a IDs inexistentes.
### 4. Cache avalanche
Muchas claves comparten el **mismo TTL** y expiran a la vez; la DB recibe una ráfaga masiva de misses (típico al arrancar con TTLs uniformes).
#### 4.1 Mitigación con jitter
Añadir un componente aleatorio al TTL para desincronizar expiraciones.

```bash
# TTL base 3600 + jitter 0-600 s → cada clave expira en un momento distinto
redis-cli SET product:42 '{"id":42}' EX 3763
redis-cli SET product:43 '{"id":43}' EX 3511
redis-cli SET product:44 '{"id":44}' EX 3927
```
En código: `ttl = base + random(0, jitter)`.
#### 4.2 Fallback / multinivel
- **Capa secundaria**: si Redis falla, leer de una caché en memoria o de la DB con un semáforo/lock.
- **Backoff exponencial**: si la DB devuelve error, no reintentar en bucle.
- **Warm-up escalonado**: re-poblar la caché de forma gradual tras un reinicio.
#### 4.3 Tabla resumen de fallos de caché
| Fenómeno | Causa | Efecto | Mitigación |
|---|---|---|---|
| Cache penetration | Claves que no existen | Misses inútiles a DB | Cachear null, bloom filter |
| Cache avalanche | Expiración simultánea masiva | Ráfaga de misses a la vez | Jitter en TTL, fallback |
| Cache breakdown | Una clave caliente expira | Un punto golpea la DB | Lock `SET NX EX`, renovación |
### 5. Cache breakdown (hot key / thundering herd)
Una sola clave con volumen altísimo (noticia viral, perfil famoso). Al expirar, **todas** las peticiones concurrentes ven miss y golpean la DB a la vez: *thundering herd*.
#### 5.1 Solución con locks
Ante un miss, se intenta adquirir un lock por clave. Solo el ganador consulta la DB y re-puebla; los demás esperan y releen de caché.

```bash
# Solo quien consiga el lock re-puebla
redis-cli SET lock:product:42 "$(hostname):$(date +%s)" NX EX 5
(integer) 1   # adquirido → ir a DB, poblar, luego DEL lock
# Los demás: SET devuelve nil → esperar y volver a GET
redis-cli GET product:42
```
#### 5.2 Renovación de valores
Si una clave caliente sigue siendo leída antes de expirar, se renueva su TTL para que no expire en hora punta.

```bash
redis-cli EXPIRE product:42 3600
redis-cli TTL product:42
```
Variante *stale-while-revalidate*: servir el valor viejo y regenerar en segundo plano; con Redis 7 se puede usar `GETEX` (obtener y renovar/expirar atómicamente).
### 6. Rate limiting
Limitar peticiones por cliente en una ventana de tiempo. Tres técnicas con Redis.
#### 6.1 Fixed window (INCR + EXPIRE)
```bash
# Ventana de 60 s, máx 10 peticiones por IP
redis-cli INCR rl:ip:203.0.113.7:60
(integer) 1
redis-cli EXPIRE rl:ip:203.0.113.7:60 60
# Petición 11 → supera el límite → rechazar
redis-cli INCR rl:ip:203.0.113.7:60
(integer) 11
```
Versión atómica con Lua (evita dos idas y vueltas):

```lua
-- rate_limit_fixed.lua
-- ARGV[1] = límite, ARGV[2] = ventana (segundos)
local key      = KEYS[1]
local limit    = tonumber(ARGV[1])
local window   = tonumber(ARGV[2])
local current  = redis.call("INCR", key)
if current == 1 then
  redis.call("EXPIRE", key, window)
end
if current > limit then
  return { 0, current }        -- rechazado
end
return { 1, current }          -- permitido
```
Ventaja: mínima memoria. Desventaja: dos picos en el borde de la ventana pueden sumar hasta 2× el límite ("burst problem").
#### 6.2 Sliding window con ZSET
Cada petición añade un miembro con timestamp como score; se descartan los viejos y se cuenta lo que queda.

```bash
# Registrar la petición
redis-cli ZADD rl:ip:203.0.113.7 1735689600000 "req:12345"
# 1. Eliminar peticiones fuera de la ventana de 60 s
redis-cli ZREMRANGEBYSCORE rl:ip:203.0.113.7 -inf 1735689540000
# 2. Contar las peticiones dentro de la ventana
redis-cli ZCARD rl:ip:203.0.113.7
```
Script Lua atómico: limpiar, contar y decidir en un paso.

```lua
-- rate_limit_sliding.lua
-- ARGV[1] = límite, ARGV[2] = ventana (ms), ARGV[3] = now (ms), ARGV[4] = miembro
local key       = KEYS[1]
local limit     = tonumber(ARGV[1])
local window    = tonumber(ARGV[2])
local now       = tonumber(ARGV[3])
local member    = ARGV[4]

redis.call("ZREMRANGEBYSCORE", key, "-inf", now - window)
local count = redis.call("ZCARD", key)
if count >= limit then
  return { 0, count }
end
redis.call("ZADD", key, now, member)
redis.call("PEXPIRE", key, window * 2)
return { 1, count + 1 }
```
#### 6.3 Token bucket (Lua)
Un "depósito" que se rellena a ritmo constante; admite ráfagas controladas.

```lua
-- token_bucket.lua
-- KEYS[1] = bucket
-- ARGV[1] = capacidad, ARGV[2] = tokens/seg, ARGV[3] = tokens pedidos
local key       = KEYS[1]
local capacity  = tonumber(ARGV[1])
local rate      = tonumber(ARGV[2])
local requested = tonumber(ARGV[3])

local bucket = redis.call("HGETALL", key)
local tokens = tonumber(bucket[2] or capacity)
local last   = tonumber(bucket[4] or 0)
local now    = redis.call("TIME")[1]
local elapsed = now - last
tokens = math.min(capacity, tokens + elapsed * rate)

if tokens >= requested then
  tokens = tokens - requested
  redis.call("HSET", key, "tokens", tokens, "last", now)
  redis.call("EXPIRE", key, math.ceil(capacity / rate) * 2)
  return { 1, tokens }        -- permitido
end
redis.call("HSET", key, "tokens", tokens, "last", now)
return { 0, tokens }          -- rechazado
```
#### 6.4 Comparación y cuándo usar cada uno
| Técnica | Precisión | Memoria | Ráfagas | Complejidad | Cuándo usarla |
|---|---|---|---|---|---|
| Fixed window | Baja (efecto borde 2×) | Mínima | Puede duplicar | Muy baja | Límites simples, gran volumen, tolera imprecisión |
| Sliding window | Alta | Media-Alta | No (cuenta exacta) | Media | Cuotas estrictas y precisas |
| Token bucket | Media | Mínima | Sí, controladas | Media | APIs con SLA de burst, shaping de tráfico |

Regla: si solo necesitas "no más de N por minuto" y el 2× te vale, fixed window. Si la cuota debe ser exacta, sliding window. Para picos limitados, token bucket.
### 7. Sesiones distribuidas
Con varios servidores de aplicación, la sesión no puede vivir en la memoria de un solo nodo. Redis actúa como almacén central.
#### 7.1 Modelo HASH + EXPIRE
```bash
redis-cli HSET session:a1b2c3 user_id 42 role admin lang es cart_items 3
redis-cli EXPIRE session:a1b2c3 3600
redis-cli HGETALL session:a1b2c3
redis-cli HSET session:a1b2c3 lang en
# Renovar el TTL en cada petición (sliding session)
redis-cli EXPIRE session:a1b2c3 3600
```
#### 7.2 Escalado horizontal
- Cualquier nodo puede leer/escribir la sesión (servidores stateless).
- Se escala con **maestro-replica** para lecturas y **Sentinel** para HA, o **Cluster** para volumen enorme.
- La cookie solo guarda el ID; los datos viven en Redis.
- Alternativa: `SET session:id json EX` si prefieres un único valor JSON.
#### 7.3 Logout e invalidación
```bash
# Invalida la sesión en todos los nodos al instante
redis-cli DEL session:a1b2c3
```
También se puede mantener un *denylist* de tokens revocados con TTL para invalidar JWTs antes de su expiración natural.
### 8. Colas de trabajo (work queues)
Listas + bloqueo = FIFO eficiente.
#### 8.1 FIFO con LPUSH + BRPOP
```bash
# Productor encola
redis-cli LPUSH jobs:emails "send:welcome@user42"
redis-cli LPUSH jobs:emails "send:reset@user7"
# Consumidor bloquea esperando trabajo (0 = indefinido)
redis-cli BRPOP jobs:emails 0
1) "jobs:emails"
2) "send:reset@user7"
```
#### 8.2 Garantías de entrega
- **At-most-once**: `LPUSH`/`RPOP`. El mensaje se pierde si el consumidor muere tras recibirlo.
- **At-least-once**: `BRPOPLPUSH`/`LMOVE`. El trabajo se mueve a una lista "en proceso" antes de ejecutarse; si el consumidor muere, otro lo recupera. Puede haber duplicados.

```bash
# Reservar: mover a "en proceso" y bloquear
redis-cli BRPOPLPUSH jobs:emails jobs:emails:processing 0
# (procesar...)
# Al terminar, confirmar quitándolo de "processing"
redis-cli LREM jobs:emails:processing 1 "send:reset@user7"
```
En Redis 6.2+ `LMOVE`/`BLMOVE` son las versiones recomendadas (`BRPOPLPUSH` está deprecada).
#### 8.3 Trabajo fallido y dead letter
Al fallar se re-encola con un contador de reintentos; al superar el máximo, va a una *dead letter queue*.

```bash
redis-cli HINCRBY jobs:emails:attempts "send:reset@user7" 1
# Si HGET >= 3 → mandar a dead letter
redis-cli LPUSH jobs:emails:deadletter "send:reset@user7"
```
| Garantía | Qué significa | Cómo en Redis | Uso típico |
|---|---|---|---|
| At-most-once | Puede perder mensajes | `RPOP` directo | Notificaciones no críticas |
| At-least-once | No pierde, puede duplicar | `BRPOPLPUSH`/`LMOVE` + confirmar | Correos, jobs idempotentes |
| Exactly-once | No se puede garantizar de forma real | Idempotencia del consumidor | — |

Para tareas críticas con ACK, grupos y replay, ver Streams (apartado 12).
### 9. Contadores de tiempo real
#### 9.1 Contador simple
```bash
redis-cli INCR stats:visits
redis-cli INCRBY stats:likes:42 5
redis-cli DECR stats:visits
```
#### 9.2 Contadores segmentados por periodo
Clave por día/hora con EXPIRE para auto-limpieza.

```bash
redis-cli INCR stats:visits:2026-08-19
redis-cli INCR stats:visits:2026-08-19:14
redis-cli EXPIRE stats:visits:2026-08-19:14 3600
```
#### 9.3 HINCRBY por segmento
```bash
redis-cli HINCRBY stats:visits:2026-08-19 mobile 1
redis-cli HINCRBY stats:visits:2026-08-19 desktop 1
redis-cli HGETALL stats:visits:2026-08-19
```
#### 9.4 Ranking diario con ZINCRBY
Un sorted set por día: usuario → puntuación.

```bash
redis-cli ZINCRBY stats:points:2026-08-19 10 "user:42"
redis-cli ZINCRBY stats:points:2026-08-19 5 "user:7"
redis-cli ZREVRANGE stats:points:2026-08-19 0 4 WITHSCORES
```
Resolución por día/hora: una clave distinta por unidad o un sorted set con score = timestamp para cortar rangos.
### 10. Rankings y top-N (leaderboards)
Los **sorted sets** son la estructura estrella.
#### 10.1 Operaciones base
```bash
redis-cli ZADD game:scores 1500 "player:alice"
redis-cli ZADD game:scores 2100 "player:bob"
redis-cli ZADD game:scores 980 "player:carla"
# Top-N descendente
redis-cli ZREVRANGE game:scores 0 2 WITHSCORES
redis-cli ZRANGE game:scores 0 -1
redis-cli ZRANGEBYSCORE game:scores 1000 2000
redis-cli ZREVRANK game:scores "player:bob"
redis-cli ZINCRBY game:scores 100 "player:carla"
```
#### 10.2 Empates
Con la misma puntuación, el orden es lexicográfico. Para "rango 1º compartido" (estilo concurso) se cuenta cuántos tienen más puntos:

```bash
# Jugadores con score mayor + 1 = puesto
redis-cli ZCOUNT game:scores (1500 +inf
```
#### 10.3 Leaderboards en juegos
- ZSET por nivel/liga/temporada.
- Paginación con `ZREVRANGE key offset offset+page-1 WITHSCORES`.
- Puntuaciones temporales en un ZSET separado, combinadas al calcular.
- El ZSET (skiplist) da `ZADD`/`ZREVRANGE` en O(log N), suficiente para millones de jugadores.
### 11. Distributed locks
Coordinar un recurso compartido entre varios procesos/máquinas.
#### 11.1 Lock básico con SET NX PX
```bash
redis-cli SET lock:deploy "host1:pid42" NX PX 30000
OK
# Otro proceso intenta adquirir → nil (falla)
redis-cli SET lock:deploy "host2:pid43" NX PX 30000
(nil)
# Liberar (solo el dueño)
redis-cli DEL lock:deploy
```
Nunca liberar con `DEL` ciego: el lock puede haber expirado y ser tomado por otro. Liberar verificando el token:

```lua
-- release_lock.lua
-- KEYS[1] = lock, ARGV[1] = token del dueño
if redis.call("GET", KEYS[1]) == ARGV[1] then
  return redis.call("DEL", KEYS[1])
end
return 0
```
#### 11.2 Extensión (locks largos)
Un "watchdog" renueva el lock mientras la tarea siga viva.

```lua
-- renew_lock.lua
-- KEYS[1] = lock, ARGV[1] = token, ARGV[2] = nuevo TTL (ms)
if redis.call("GET", KEYS[1]) == ARGV[1] then
  return redis.call("PEXPIRE", KEYS[1], tonumber(ARGV[2]))
end
return 0
```
#### 11.3 Desventajas y fencing
- **Un solo maestro**: si cae y una réplica promociona, puede "perder" el lock → dos procesos con lock.
- **Fencing token**: el recurso protegido debe validar un token incremental y rechazar operaciones con token viejo. Redis no lo genera por sí solo.
- **Redlock**: adquiere el lock en N nodos independientes (mayoría). Controversial (Kleppmann vs Sanfilippo); recomendado solo para casos muy críticos con fencing. Para la mayoría, un solo maestro + token + TTL basta.

| Aspecto | Lock simple | Redlock |
|---|---|---|
| Nodos | 1 | N independientes |
| Tolerancia a fallo | Ninguna | Hasta (N-1)/2 nodos caídos |
| Complejidad | Baja | Alta |
| Uso típico | Workflows internos | Sistemas distribuidos críticos |

Regla: usa locks para **evitar doble trabajo**, nunca como única barrera de seguridad.
### 12. Pub/Sub
Patrón publish-subscribe: publicadores envían a canales; suscriptores reciben.
#### 12.1 Comandos
```bash
# Suscriptor (terminal A) — canal exacto
redis-cli SUBSCRIBE noticias
# Suscriptor (terminal B) — patrón
redis-cli PSUBSCRIBE noticias:*
# Publicador (terminal C)
redis-cli PUBLISH noticias "Hola mundo"
redis-cli PUBLISH noticias:deportes "Gol"
```
`SUBSCRIBE` escucha un canal exacto; `PSUBSCRIBE` escucha por patrón (`noticias:*`, `user:??`).
#### 12.2 Fire-and-forget
Es **fire-and-forget**: si no hay suscriptores al publicar, el mensaje se pierde. No hay almacenamiento, replay ni ACK.
#### 12.3 Cuándo NO usar Pub/Sub
- Tareas críticas que no pueden perderse → usar colas/Streams.
- Envíos que deben persistir hasta procesarse.
- En Cluster el `PUBLISH` se propaga a todos los nodos, pero los mensajes publicados en un nodo no siempre llegan a suscriptores en otros sin configuración extra.

| Característica | Pub/Sub | Streams |
|---|---|---|
| Persistencia | No (se pierde) | Sí (append log) |
| Suscriptores offline | No reciben nada | Recuperan por offset |
| ACK | No | Sí (XACK) |
| Consumo por grupos | No (broadcast) | Sí (consumer groups) |
| Uso | Notificaciones ligeras | Mensajería confiable |
### 13. Streams: reemplazo robusto
Append-only log con IDs, ACK y consumer groups.
#### 13.1 Producir y consumir
```bash
redis-cli XADD orders '*' user 42 amount 89.90
"1735689600000-0"
# Desde el principio (0) o solo nuevos ($)
redis-cli XREAD COUNT 10 STREAMS orders 0
redis-cli XREAD BLOCK 0 STREAMS orders '$'
```
#### 13.2 Consumer groups
```bash
redis-cli XGROUP CREATE orders workers 0 MKSTREAM
# Leer "su" mensaje (>) = nuevos, no entregados
redis-cli XREADGROUP GROUP workers worker-1 COUNT 1 STREAMS orders '>'
# Confirmar tras procesar
redis-cli XACK orders workers 1735689600000-0
(integer) 1
```
El mensaje queda *pending* hasta el `XACK`. Si el consumidor muere, otro puede reclamarlo (`XAUTOCLAIM`, antes `XCLAIM`).
#### 13.3 Persistencia del offset y replay
- Cada consumidor guarda su último ID; puede reiniciar desde donde quedó (`XPENDING`, `XREADGROUP` con ID concreto).
- `XRANGE` re-lee rangos históricos → replay.
- `XTRIM` / `XADD ... MAXLEN` limita el crecimiento.

| Concepto | Comando |
|---|---|
| Añadir mensaje | `XADD` |
| Leer stream | `XREAD` |
| Leer como grupo | `XREADGROUP` |
| Confirmar | `XACK` |
| Ver pendientes | `XPENDING` |
| Reclamar huérfanos | `XAUTOCLAIM` |
| Recorrer historial | `XRANGE`, `XREVRANGE` |
| Podar | `XTRIM`, `XADD ... MAXLEN ~` |
| Info de grupos | `XINFO GROUPS` |
### 14. Modos de despliegue
#### 14.1 Standalone
Un solo proceso. Simple, ideal para desarrollo. Punto único de fallo.
#### 14.2 Maestro-replica (REPLICAOF)
Copias de solo lectura; escala lecturas y da redundancia.

```bash
# En el nodo replica (asíncrona por defecto)
redis-cli REPLICAOF 10.0.0.5 6379
# Volver a maestro
redis-cli REPLICAOF NO ONE
```
- Las escrituras van solo al maestro.
- Replicación asíncrona: puede haber pérdida pequeña en un failover. `WAIT` fuerza espera de confirmación.
#### 14.3 Sentinel (HA)
Sentinel supervisa maestros, detecta caídas y promueve réplicas automáticamente. Los clientes le preguntan dónde está el maestro. Quórum típico: 3 procesos Sentinel.
#### 14.4 Cluster (sharding)
Distribuye los datos en **16384 hash slots** (`CRC16(key) % 16384`). Hay replicación y failover automático.

```bash
redis-cli -c -p 7000 CLUSTER INFO
redis-cli -c CLUSTER NODES
redis-cli CLUSTER KEYSLOT user:42
```
- Claves en el mismo slot pueden ser multi-clave atómicas; de slots distintos NO → usar *hash tags* `{user:42}:cart`.
- Los clientes deben ser cluster-aware (`MOVED`/`ASK`) o usar `-c`.
#### 14.5 Sharding manual vs automático
| Aspecto | Manual (shard en la app) | Cluster automático |
|---|---|---|
| Asignación clave→nodo | La app (hash mod N) | Redis (slots CRC16) |
| Rebalanceo | Manual, re-hashear | Redistribución de slots |
| Multi-clave | Limitado a un shard | Limitado a un slot (hash tags) |
| Cuándo | Volumen moderado | Crecimiento previsible |
### 15. Backup y recuperación
#### 15.1 RDB (snapshots)
```bash
redis-cli BGSAVE
Background saving started

cp /var/lib/redis/dump.rdb /backup/redis-$(date +%F).rdb
```
Al arrancar, Redis carga el RDB si existe. Config:

```conf
save 900 1        # guardar si ≥1 cambio en 900 s
save 300 10       # guardar si ≥10 cambios en 300 s
dbfilename dump.rdb
dir /var/lib/redis
```
Compacto e ideal para backups; si Redis muere se pierde lo escrito desde el último snapshot.
#### 15.2 AOF (Append Only File)
Registro de cada escritura; mejor durabilidad, más pesado.

```conf
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec   # por segundo (recomendado)
```
```bash
# Reescribir compactando (no bloqueante)
redis-cli BGREWRITEAOF
```
Con `aof-use-rdb-preamble yes`, el AOF reescrito empieza con un RDB y sigue con comandos.
#### 15.3 Estrategia recomendada
| Estrategia | Frecuencia | Para qué |
|---|---|---|
| RDB + copia externa | Cada X horas/día | Recuperación completa |
| AOF everysec | Continuo | Minimizar pérdida de datos |
| BGSAVE periódico | Automático (save) | Puntos de restauración |
| Backups a otro disco/bucket | Diario | Desastres |

- Guarda RDB/AOF en almacenamiento externo.
- Prueba restauraciones periódicamente: un backup que no se restaura no es un backup.
### 16. Monitoreo y operación
#### 16.1 INFO
```bash
redis-cli INFO server
redis-cli INFO memory
redis-cli INFO stats
redis-cli INFO replication
redis-cli INFO keyspace
```
Campos clave: `used_memory`, `used_memory_human`, `maxmemory`, `connected_clients`, `keyspace_hits`, `keyspace_misses`, `rdb_last_bgsave_status`.
#### 16.2 Memoria
```bash
redis-cli MEMORY USAGE product:42
redis-cli MEMORY DOCTOR
redis-cli INFO memory
```
Políticas de expulsión (`maxmemory-policy`):

| Política | Descripción | Cuándo |
|---|---|---|
| `noeviction` | Error al escribir si hay tope | Nunca perder datos |
| `allkeys-lru` | Expulsa el menos usado recientemente | Caché genérica |
| `allkeys-lfu` | Expulsa el menos frecuente | Caché con patrones estables |
| `volatile-lru` | Solo claves con TTL, LRU | Caché mixta |
| `allkeys-random` | Expulsa al azar | Sin jerarquía de uso |
| `volatile-ttl` | Expulsa la que expira antes | Caché con TTL |
#### 16.3 Slow queries, monitor y benchmark
```bash
redis-cli SLOWLOG GET 10
redis-cli SLOWLOG LEN
# MONITOR: solo debug puntual, NUNCA en producción (degrada mucho)
redis-cli MONITOR

redis-cli --latency
redis-benchmark -q -c 50 -n 100000 -t SET,GET,INCR
redis-cli --stat
```
### 17. Seguridad en producción
#### 17.1 requirepass y bind
```conf
requirepass "un-secreto-muy-largo"
bind 127.0.0.1 10.0.0.10
protected-mode yes
```
Con `protected-mode yes` y sin bind explícito, Redis solo acepta conexiones locales. **Nunca expongas Redis a internet sin TLS + ACL.**
#### 17.2 ACLs (Redis 6+)
Usuarios con permisos granulares en vez de una sola contraseña.

```bash
# Usuario de solo lectura
redis-cli ACL SETUSER monitor ON '>moni_pass_123' ~* +@read -config
# Usuario de app sin comandos peligrosos
redis-cli ACL SETUSER api ON '>api_pass_456' ~cache:* ~session:* +@all -config -flushall -flushdb -keys -shutdown
# Usuario por defecto desactivado
redis-cli ACL SETUSER default OFF

redis-cli ACL LIST
redis-cli ACL WHOAMI
```
Sintaxis: `USER <name> ON/OFF >password ~pattern +comando -comando @categoria`.
#### 17.3 Renombrar/deshabilitar comandos peligrosos
```conf
rename-command CONFIG ""
rename-command FLUSHALL ""
rename-command FLUSHDB ""
rename-command KEYS "listkeys-debug"
rename-command DEBUG ""
```
Renombrar con `""` deshabilita; con otro nombre, disfraza. Cuidado si herramientas de monitoreo dependen de esos comandos.
#### 17.4 TLS
```conf
port 0
tls-port 6380
tls-cert-file /etc/redis/server.crt
tls-key-file /etc/redis/server.key
tls-ca-cert-file /etc/redis/ca.crt
tls-auth-clients yes
```
TLS protege en tránsito; ACLs y protección de comandos protegen en origen. Ambas.

---
## Ejemplos de código
### Ejemplo 1 — Cache-aside completo con jitter y null-caching
```bash
# -- Escenario: leer un producto (la DB no existe aquí; Redis es la caché).
# 1) Leer de caché
VAL=$(redis-cli GET product:42)
# 2) Hit → devolver
if [ -n "$VAL" ]; then echo "CACHÉ: $VAL"; exit 0; fi
# 3) Miss → consultar la DB (simulado). Si no existe → cachear "null" con TTL corto
redis-cli SET product:42 NOT_FOUND EX 120
exit 0
# 4) Si existe → poblar con TTL base + jitter (3600 + aleatorio 0-600)
redis-cli SET product:42 '{"id":42,"name":"Silla"}' EX 3897
# 5) Escritura posterior → invalidar
redis-cli DEL product:42
```
### Ejemplo 2 — Rate limiting fixed window atómico (Lua)
```lua
-- fixed.lua — redis-cli --eval fixed.lua rl:ip:203.0.113.7 , 10 60
local key = KEYS[1]
local limit = tonumber(ARGV[1])
local window = tonumber(ARGV[2])
local current = redis.call("INCR", key)
if current == 1 then
  redis.call("EXPIRE", key, window)
end
if current > limit then
  return { 0, current }
end
return { 1, current }
```
```bash
redis-cli --eval fixed.lua rl:ip:203.0.113.7 , 10 60
1) (integer) 1
2) (integer) 1
```
### Ejemplo 3 — Cola de trabajo at-least-once con LMOVE y dead letter
```bash
# Productor
redis-cli LPUSH jobs:pdf "doc:100"
redis-cli LPUSH jobs:pdf "doc:200"
# Consumidor: reserva moviendo a "processing"
redis-cli LMOVE jobs:pdf jobs:pdf:processing LEFT RIGHT
# Éxito → confirmar (quitar de processing)
redis-cli LREM jobs:pdf:processing 1 "doc:100"
# Fallo → HINCRBY intentos; si intentos >= 3 → dead letter
redis-cli HINCRBY jobs:pdf:attempts "doc:100" 1
redis-cli LPUSH jobs:pdf:deadletter "doc:100"
```
### Ejemplo 4 — Leaderboard con empates y stream de pedidos
```bash
redis-cli ZADD game:s1 1500 player:alice
redis-cli ZADD game:s1 2100 player:bob
redis-cli ZADD game:s1 980  player:carla
redis-cli ZADD game:s1 1500 player:dan   # empate con alice

redis-cli ZREVRANGE game:s1 0 2 WITHSCORES
redis-cli ZCOUNT game:s1 (1500 +inf    # puesto "estilo concurso" de alice

redis-cli XADD orders '*' user 42 amount 89.90
redis-cli XGROUP CREATE orders workers 0 MKSTREAM
redis-cli XREADGROUP GROUP workers w1 COUNT 1 STREAMS orders '>'
redis-cli XACK orders workers 1735689600000-0
```
### Ejemplo 5 — Distributed lock con renovación
```bash
# Adquirir con token y TTL
redis-cli SET lock:job:nightly "host1:token-abc" NX PX 30000
# Renovar si la tarea sigue viva (watchdog cada 10 s)
redis-cli --eval renew.lua lock:job:nightly , "host1:token-abc" 30000
# Liberar con verificación de token
redis-cli --eval release.lua lock:job:nightly , "host1:token-abc"
```
---
## Ejercicios relacionados
- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)
- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — Experto](../ejercicios/nivel-05-experto/)
- [Proyectos](../ejercicios/proyectos/)

---
## Errores comunes
1. **`SET` sin TTL para datos que expiran.** *Causa:* poblar la caché con `SET` a secas. *Solución:* `SET key value EX <ttl>` o `SETEX`; un valor sin TTL nunca expira.
2. **`DEL` ciego al liberar un lock distribuido.** *Causa:* el lock expiró, otro lo tomó, y el primero borra el lock ajeno. *Solución:* liberar con Lua verificando el token.
3. **TTL uniforme en toda la caché (avalancha).** *Causa:* todas las claves expiran a la vez. *Solución:* jitter aleatorio en el TTL y fallback.
4. **No cachear claves inexistentes (penetración).** *Causa:* IDs inexistentes golpean la DB. *Solución:* cachear "null" con TTL corto o bloom filter.
5. **Rate limiting sin atomicidad.** *Causa:* `INCR`, leer y decidir en pasos separados → carreras. *Solución:* script Lua o `SET NX EX`.
6. **Pensar que Pub/Sub es persistente.** *Causa:* asumir que `PUBLISH` se entrega sin suscriptores. *Solución:* Streams o colas para mensajería que no puede perderse.
7. **Bloquear sin límite en producción.** *Causa:* `BRPOP key 0` indefinido mantiene conexiones y complica timeouts. *Solución:* timeouts razonables y circuit breakers.
8. **Usar `KEYS *` en producción.** *Causa:* escaneo bloqueante en datasets grandes. *Solución:* `SCAN` incremental o indexar con sorted sets.
9. **`MONITOR` dejado corriendo.** *Causa:* depurar y olvidar apagarlo → rendimiento destruido. *Solución:* solo segundos en entorno aislado.
10. **Exponer Redis a internet.** *Causa:* puerto 6379 abierto sin protección. *Solución:* `protected-mode yes`, bind interno, firewall, TLS y ACL.
11. **Ignorar `maxmemory` y políticas de expulsión.** *Causa:* Redis crece sin límite y cae en swap o falla escrituras. *Solución:* fijar `maxmemory` y política (`allkeys-lru` para caché).
12. **Una sola `requirepass` sin ACL.** *Causa:* sin diferenciar permisos. *Solución:* usuarios ACL con permisos mínimos y secretos fuertes.
13. **No configurar persistencia.** *Causa:* `appendonly no` y `save` desactivados → el reinicio borra datos. *Solución:* AOF `everysec` + RDB + backups probados.
14. **Multi-key en Cluster entre slots distintos.** *Causa:* `MSET a 1 b 2` con `a` y `b` en slots diferentes → `CROSSSLOT`. *Solución:* hash tags `{user:42}:a` o pipelines.
15. **Scripts Lua con `redis.call` incorrecto.** *Causa:* mezclar `KEYS` y `ARGV`, o comandos no permitidos en scripts. *Solución:* claves por `KEYS` (para el slot en Cluster) y datos por `ARGV`.

---
## Recursos
- Documentación oficial: <https://redis.io/docs/latest/>
- Command reference de Redis 7: <https://redis.io/docs/latest/commands/>
- Patrones de diseño oficiales: <https://redis.io/docs/latest/develop/use/patterns/>
- Distributed locks (Redlock): <https://redis.io/docs/latest/develop/use/patterns/distributed-locks/>
- Persistencia (RDB/AOF): <https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/>
- Replicación y Sentinel: <https://redis.io/docs/latest/operate/oss_and_stack/management/replication/>
- Redis Cluster: <https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/>
- Seguridad (ACL, TLS): <https://redis.io/docs/latest/operate/oss_and_stack/management/security/>
- Optimización y monitoreo: <https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/>
- Streams en profundidad: <https://redis.io/docs/latest/develop/data-types/streams/>
- Protocolo RESP: <https://redis.io/docs/latest/develop/reference/protocol-spec/>
- RedisBlog — casos de uso: <https://redis.io/blog/>

---

*Fin de la guía 05 — Patrones y producción.*