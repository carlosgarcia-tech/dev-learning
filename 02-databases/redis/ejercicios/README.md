# Ejercicios — Redis

30 ejercicios en 5 niveles de dificultad. Cada ejercicio es una carpeta con **enunciado, requisitos, pistas y solución** (`ejercicio-0N-slug.md`), el **estado inicial** (`setup.redis`), la **solución** (`solucion.redis`), la **salida esperada** (`expected.txt`) y un **script de tests** (`test.sh`) que levanta Redis con podman, aplica el setup, ejecuta la solución y compara la salida.

## Nivel 1 — Fundamentos

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [set-y-get](nivel-01-fundamentos/ejercicio-01-set-y-get/) | SET, GET, EXISTS, TYPE |
| 02 | [del-y-append](nivel-01-fundamentos/ejercicio-02-del-y-append/) | DEL, APPEND, STRLEN, GETSET |
| 03 | [incr-y-decr](nivel-01-fundamentos/ejercicio-03-incr-y-decr/) | INCR, DECR, INCRBY, DECRBY |
| 04 | [expire-y-ttl](nivel-01-fundamentos/ejercicio-04-expire-y-ttl/) | EXPIRE, TTL, PERSIST, SETEX |
| 05 | [mset-y-mget](nivel-01-fundamentos/ejercicio-05-mset-y-mget/) | MSET, MGET, SETNX |
| 06 | [keys-y-dbsize](nivel-01-fundamentos/ejercicio-06-keys-y-dbsize/) | KEYS (patrones), DBSIZE, EXISTS |

## Nivel 2 — Básico

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [listas-basicas](nivel-02-basico/ejercicio-01-listas-basicas/) | RPUSH, LPUSH, LRANGE, LLEN |
| 02 | [listas-pop-y-indexado](nivel-02-basico/ejercicio-02-listas-pop-y-indexado/) | LINDEX, LPOP, RPOP, LSET |
| 03 | [listas-avanzadas](nivel-02-basico/ejercicio-03-listas-avanzadas/) | LREM, LINSERT, LTRIM |
| 04 | [hashes-basicos](nivel-02-basico/ejercicio-04-hashes-basicos/) | HSET, HGET, HMGET, HGETALL, HLEN, HEXISTS |
| 05 | [hashes-contadores](nivel-02-basico/ejercicio-05-hashes-contadores/) | HINCRBY, HDEL, HEXISTS, HLEN |
| 06 | [hashes-busqueda](nivel-02-basico/ejercicio-06-hashes-busqueda/) | HKEYS, HVALS, HGETALL, HSTRLEN |

## Nivel 3 — Intermedio

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [sets-basicos](nivel-03-intermedio/ejercicio-01-sets-basicos/) | SADD, SCARD, SISMEMBER, SREM |
| 02 | [sets-operaciones](nivel-03-intermedio/ejercicio-02-sets-operaciones/) | SINTERSTORE, SUNIONSTORE, SDIFFSTORE |
| 03 | [sorted-sets-basicos](nivel-03-intermedio/ejercicio-03-sorted-sets-basicos/) | ZADD, ZCARD, ZSCORE, ZRANGE, ZRANK, ZREM |
| 04 | [sorted-sets-rangos](nivel-03-intermedio/ejercicio-04-sorted-sets-rangos/) | ZREVRANGE, ZRANGEBYSCORE, ZINCRBY |
| 05 | [multi-y-exec](nivel-03-intermedio/ejercicio-05-multi-y-exec/) | MULTI, QUEUED, EXEC, DISCARD |
| 06 | [pipelines-y-watch](nivel-03-intermedio/ejercicio-06-pipelines-y-watch/) | WATCH, UNWATCH, MULTI, EXEC |

## Nivel 4 — Avanzado

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [expiracion-avanzada](nivel-04-avanzado/ejercicio-01-expiracion-avanzada/) | SET EX, SETEX, PTTL, PERSIST, EXPIRE |
| 02 | [streams-basicos](nivel-04-avanzado/ejercicio-02-streams-basicos/) | XADD, XLEN, XRANGE (IDs explícitos) |
| 03 | [streams-grupos](nivel-04-avanzado/ejercicio-03-streams-grupos/) | XGROUP, XREADGROUP, XACK, XINFO |
| 04 | [geospatial](nivel-04-avanzado/ejercicio-04-geospatial/) | GEOADD, GEOPOS, GEODIST, GEOSEARCH |
| 05 | [bitmaps](nivel-04-avanzado/ejercicio-05-bitmaps/) | SETBIT, GETBIT, BITCOUNT |
| 06 | [lua-scripts](nivel-04-avanzado/ejercicio-06-lua-scripts/) | EVAL, KEYS[], ARGV[], redis.call |

## Nivel 5 — Experto

| # | Ejercicio | Tema |
|---|---|---|
| 01 | [cache-aside](nivel-05-experto/ejercicio-01-cache-aside/) | Caché con SET EX, GET, TTL |
| 02 | [rate-limiting](nivel-05-experto/ejercicio-02-rate-limiting/) | Contador de ventana + EXPIRE |
| 03 | [sesiones](nivel-05-experto/ejercicio-03-sesiones/) | Hash de sesión + expiración |
| 04 | [colas-de-trabajo](nivel-05-experto/ejercicio-04-colas-de-trabajo/) | FIFO con RPUSH + BLPOP |
| 05 | [contadores-tiempo-real](nivel-05-experto/ejercicio-05-contadores-tiempo-real/) | INCRBY + ZINCRBY |
| 06 | [ranking-zsets](nivel-05-experto/ejercicio-06-ranking-zsets/) | ZREVRANGE, ZREVRANK, ZINCRBY |

## Proyectos integradores

Proyectos que combinan todo lo aprendido en sistemas completos.

| Proyecto | Descripción |
|---|---|
| [Caché para un blog](proyectos/README.md#proyecto-1-caché-para-un-blog) | Cache-aside, contadores de visitas y ranking de posts |
| [Sesiones y cola de trabajos](proyectos/README.md#proyecto-2-sesiones-y-cola-de-trabajos) | Autenticación por sesión y cola FIFO |
| [PROYECTO FINAL: E-commerce en tiempo real](proyectos/proyecto-final/README.md) | 15 consultas + tests automáticos sobre un sistema real |