# 03 — Transacciones y persistencia

## Objetivos

- [ ] Comprender el modelo de ejecución single-threaded de Redis y sus implicaciones
- [ ] Entender por qué cada comando es atómico en Redis
- [ ] Usar MULTI para agrupar comandos y EXEC para ejecutarlos
- [ ] Usar DISCARD para descartar una transacción sin ejecutarla
- [ ] Interpretar las respuestas QUEUED de una transacción
- [ ] Explicar por qué Redis NO ofrece rollback y por qué es una decisión de diseño
- [ ] Distinguir entre errores de sintaxis y errores de ejecución dentro de una transacción
- [ ] Usar WATCH y UNWATCH para implementar optimistic locking
- [ ] Resolver una carrera usando WATCH con un contador de decremento condicional
- [ ] Acumular comandos con pipelines y conocer cuándo conviene usarlos
- [ ] Diferencia entre pipeline y MULTI (rendimiento vs atomicidad)
- [ ] Escribir scripts Lua con EVAL, EVALSHA, KEYS[], ARGV[] y redis.call()
- [ ] Usar SCRIPT LOAD, SCRIPT EXISTS y SCRIPT FLUSH
- [ ] Configurar persistencia RDB con SAVE, BGSAVE y la directiva save
- [ ] Configurar persistencia AOF con appendfsync y BGREWRITEAOF
- [ ] Comparar RDB vs AOF y elegir la estrategia según el caso de producción
- [ ] Leer y modificar configuración con CONFIG GET, CONFIG SET y redis.conf
- [ ] Interpretar INFO por secciones
- [ ] Configurar una réplica con REPLICAOF y entender la alta disponibilidad

## Apuntes

### Modelo de ejecución de Redis

Redis es un servidor **monohilo (single-threaded)** por cada instancia: todas las
operaciones de datos se ejecutan en un único hilo de eventos. Esto elimina por
completo la necesidad de locks en el acceso a los datos y simplifica muchísimo el
modelo mental que debes tener al razonar sobre concurrencia.

#### Por qué single-threaded es una ventaja

- **Sin condiciones de carrera a nivel de comando**: cada comando se ejecuta
  completo antes de que empiece el siguiente.
- **Sin locks ni semáforos**: no hay coste de sincronización en el camino crítico.
- **Predecibilidad**: la latencia es estable y el rendimiento predecible.
- **Memoria más eficiente**: no hay estructuras de sincronización.

El único precio a pagar es que **un comando lento bloquea a todos** los clientes.
Por eso operaciones como KEYS, SMEMBERS o LRANGE sobre estructuras enormes, o
scripts Lua demasiado largos, deben evitarse en producción.

#### Atomicidad por comando

Cada comando individual es **atómico**: no se puede intercalar nada dentro de un
GET, un LPUSH o un INCR. Por ejemplo, INCR se implementa internamente como
"leer → sumar → escribir", pero como no hay conmutación de hilo en medio, dos
clientes que hacen INCR simultáneamente nunca pierden una suma:

```
# Dos clientes ejecutan INCR a la vez sobre contador
# Resultado garantizado: 2, nunca 1
clientA> INCR contador
(integer) 1
clientB> INCR contador
(integer) 2
```

#### Cuando se necesita más que un comando

La atomicidad por comando NO es suficiente cuando una operación lógica requiere
varios pasos. Por ejemplo, "decrementar un contador pero solo si no baja de cero"
necesita dos comandos (GET + DECR) y otro cliente podría modificar la clave entre
ambos. Para esas situaciones Redis ofrece cuatro herramientas:

| Herramienta | Atomicidad | Naturaleza |
|---|---|---|
| MULTI / EXEC | Sí (bloqueo de ejecución) | Agrupa comandos sin lógica condicional |
| WATCH / UNWATCH | Optimista | Detecta cambios entre la lectura y la escritura |
| Pipeline | No | Optimiza el número de RTT (round trips) |
| Lua scripts | Sí | Ejecuta lógica arbitraria de forma atómica |

### Transacciones con MULTI y EXEC

Una transacción en Redis agrupa comandos que se ejecutan **en secuencia, sin
intercalación**, como bloque. Se inicia con MULTI y se dispara con EXEC.

#### Flujo básico

```
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> SET usuario:1:nombre "Ana"
QUEUED
127.0.0.1:6379> INCR estadisticas:usuarios
QUEUED
127.0.0.1:6379> EXEC
1) OK
2) (integer) 1
```

MULTI devuelve OK y a partir de ahí todos los comandos se **encolan** en lugar de
ejecutarse. Redis responde `QUEUED` a cada comando encolado. Cuando llega EXEC,
Redis ejecuta los comandos uno tras otro sin intercalación y devuelve **un array
con las respuestas de cada comando** en orden.

#### Respuestas QUEUED

- Cada comando enviado dentro de MULTI responde `QUEUED`, no su resultado real.
- Solo al hacer EXEC recibes el array con los resultados reales, en el mismo orden.
- Si un comando tiene un error de sintaxis al encolarse, Redis responde un error
  inmediatamente (por ejemplo `ERR unknown command`) pero **continúa encolando**
  los siguientes.

```
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> SET a 1
QUEUED
127.0.0.1:6379> BADCMD a
(error) ERR unknown command 'BADCMD', with args beginning with: 'a',
127.0.0.1:6379> SET b 2
QUEUED
127.0.0.1:6379> EXEC
(error) EXECABORT Transaction discarded because of previous errors.
```

#### Errores de sintaxis vs errores de ejecución

Hay **dos tipos de error** y es fundamental distinguirlos:

**1. Errores en el encolado (sintaxis / comando desconocido / aridad):** se detectan
antes de EXEC. Si hay uno, EXEC devuelve `EXECABORT` y **no ejecuta nada**. Nadie
más puede escribir, y la transacción entera se descarta.

**2. Errores en ejecución (semánticos):** el comando es válido pero falla al
ejecutarse. Por ejemplo `LPUSH miLista` sobre una clave que contiene un string.
Estos errores **no abortan la transacción**: los comandos anteriores ya se
ejecutaron, los posteriores también, y el error aparece como un elemento del array
de resultados:

```
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> SET cadena "hola"
QUEUED
127.0.0.1:6379> LPUSH cadena 1 2 3
QUEUED
127.0.0.1:6379> SET otro "ok"
QUEUED
127.0.0.1:6379> EXEC
1) OK
2) (error) WRONGTYPE Operation against a key holding the wrong kind of value
3) OK
```

Observa que `SET cadena` y `SET otro` **sí** se aplicaron. El error no revirtió
nada. Esta es la semántica de Redis: **ejecuta todo o, si hay error de encolado,
nada; los errores en ejecución no paran la transacción**.

#### ¿Por qué NO hay rollback?

Cuando EXEC comienza a ejecutar, un error en ejecución **no deshace** lo anterior.
¿Por qué Redis no implementa ROLLBACK como las bases de datos relacionales?

- **Por diseño**: la filosofía de Redis es que los errores en ejecución son errores
  de programación (tipo de clave incorrecto) que deben detectarse en desarrollo,
  no en producción.
- **Por simplicidad y velocidad**: mantener un registro de undo para revertir
  cambios añadiría complejidad y rompería el camino de ejecución optimizado de Redis.
- **Porque rara vez ayuda**: los errores detectables antes de ejecutar (sintaxis,
  comando inexistente) descartan la transacción entera; los fallos restantes son
  semánticos y poco comunes.

La postura oficial del proyecto: "Los errores en tiempo de ejecución ocurren
normalmente por errores de programación... Redis no necesita hacer nada especial:
simplemente, si no puedes vivir con eso, usa una base de datos con rollback".

#### WATCH dentro de transacciones

MULTI/EXEC por sí solo no garantiza que los datos leídos **antes** de MULTI sigan
igual **al momento** de EXEC. Para eso existe WATCH (sección siguiente).

#### Tabla de comandos de transacciones

| Comando | Descripción | Complejidad |
|---|---|---|
| MULTI | Inicia una transacción; encola comandos posteriores | O(1) |
| EXEC | Ejecuta todos los comandos encolados de forma atómica | O(N) (N = comandos) |
| DISCARD | Descarta la transacción y limpia la cola | O(1) |
| WATCH key [...] | Marca claves; si cambian antes de EXEC, EXEC no ejecuta | O(1) por clave |
| UNWATCH | Olvida todas las claves marcadas con WATCH | O(1) |

### DISCARD

DISCARD descarta la transacción en curso: vacía la cola de comandos encolados y
deshace los WATCH de la conexión.

```
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> INCR contador
QUEUED
127.0.0.1:6379> DISCARD
OK
127.0.0.1:6379> GET contador
(nil)          # INCR nunca se ejecutó
```

### Optimistic locking con WATCH

WATCH implementa **bloqueo optimista**: en lugar de bloquear recursos, se "vigilan"
claves y se verifica al final si cambiaron. Si alguna clave vigilada cambió,
**EXEC devuelve nil** y no ejecuta nada, dejándote reintentar.

#### Concepto

```
127.0.0.1:6379> WATCH inventario:zapatillas
OK
127.0.0.1:6379> GET inventario:zapatillas
(integer) 5            # lectura
... otro cliente SET inventario:zapatillas 100 ...
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> DECR inventario:zapatillas
QUEUED
127.0.0.1:6379> EXEC
(nil)                  # clave modificada → EXEC aborta silenciosamente
```

Si el EXEC devuelve nil, **ninguno** de los comandos encolados se ejecutó; la
aplicación debe reintentar el ciclo completo (WATCH → lectura → MULTI → EXEC).

- WATCH es **acumulativo**: puedes vigilar varias claves `WATCH k1 k2 k3`.
- Un solo EXEC o UNWATCH limpia todos los WATCH de la conexión.
- Si la clave vigilada **expira** por TTL, también cuenta como "modificada".
- Si EXEC devolvió nil, haz **otro WATCH** antes del siguiente ciclo.

#### UNWATCH

Olvida todas las claves vigiladas sin ejecutar nada. Se usa cuando decides no
ejecutar la transacción y no quieres que un futuro EXEC se vea afectado por
vigilancias viejas:

```
127.0.0.1:6379> WATCH inventario:a inventario:b
OK
127.0.0.1:6379> UNWATCH
OK                          # se olvidan ambas claves
```

#### Caso: contador con decremento condicional

Imagina un stock: solo se puede decrementar si el valor actual es mayor que 0.
Con GET + DECR por separado habría una carrera: si dos clientes leen 1 a la vez,
ambos decrementan y el stock acaba en -1.

Con WATCH la carrera se evita: el cliente B detectará el cambio y reintentará, o
comprobará el valor antes de DECR.

```
127.0.0.1:6379> WATCH stock:producto:42
OK
127.0.0.1:6379> GET stock:producto:42
(integer) 1
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> DECR stock:producto:42
QUEUED
127.0.0.1:6379> EXEC
1) (integer) 0                # alguien más modificó → devolvería nil
```

Si el EXEC devuelve nil, el cliente sabe que el stock fue tocado por otro y debe
**releer el valor y decidir de nuevo** (quizá ahora ya es 0 y no puede vender).

#### Cuándo usar WATCH

- Cuando necesitas "leer → decidir → escribir" con varios pasos y hay concurrencia.
- No es gratis: cada reintento añade latencia; en contención alta, un script Lua
  atómico suele ser mejor opción.
- Comandos atómicos ya existentes (INCR, DECR, SETNX, SET key v NX EX) cubren
  muchos casos sin necesidad de WATCH.

### Pipelines

Un pipeline es una **optimización de red**: en vez de enviar N comandos en N
viajes de ida y vuelta (RTT), se envían todos juntos en una sola escritura y se
reciben todas las respuestas juntas.

Cada comando cuesta al menos **un RTT** (round trip time): en una LAN ~0.1 ms, así
que 1000 comandos son 1000 RTT. Con pipeline se mandan en **un solo RTT**:

```
Sin pipeline: cmd1 ─▶ RTT ◀─ r1   cmd2 ─▶ RTT ◀─ r2   cmd3 ...
Con pipeline: cmd1 cmd2 ... cmdN ─▶ RTT ◀─ r1 r2 ... rN
```

- El pipeline **no cambia el número de operaciones** del servidor: solo reduce la
  latencia de red.
- Es útil con muchos comandos **independientes** entre sí.
- OJO: se ejecutan en orden de llegada, pero **no son atómicos entre sí**: otro
  cliente puede intercalarse entre los comandos del pipeline.

#### redis-cli --pipe

`redis-cli --pipe` lee comandos del stdin (en formato crudo, estilo protocolo RESP)
y los envía de forma masiva, ideal para cargas masivas (bulk load):

```bash
# genera comandos y los manda por pipeline
(echo -e "SET k1 v1\nSET k2 v2\nSET k3 v3") | redis-cli --pipe

# salida típica:
# All data transferred. Waiting for the last reply...
# Last reply received from server.
# errors: 0, replies: 3
```

Desde un cliente programático, la API gestiona el envío/lectura en bloque
automáticamente (p. ej. `pipeline()` en redis-py, o `mget`/`mset`).

#### Cuándo usar pipelines

- Carga inicial masiva de datos.
- Múltiples lecturas/escrituras que no dependen unas de otras.
- Reducción de latencia en operaciones batch.

No uses pipeline para operaciones que necesitan el resultado de un comando para
calcular el siguiente (ahí necesitas lógica, probablemente un script Lua).

#### Diferencias entre pipeline y MULTI

| Aspecto | Pipeline | MULTI / EXEC |
|---|---|---|
| Objetivo principal | Reducir RTT / latencia de red | Ejecutar de forma atómica |
| Atomicidad | NO (los comandos pueden intercalarse) | SÍ (bloque atómico) |
| Respuesta | Arrays con todas las respuestas | Array de respuestas por comando |
| Se puede combinar | Sí, un pipeline puede envolver un MULTI/EXEC | Sí |
| Coste del servidor | Solo I/O de red | Reserva de cola + ejecución bloqueante |

En la práctica **se combinan**: envías MULTI+comandos+EXEC por un pipeline para
obtener atomicidad Y bajo RTT.

### Scripting Lua

Redis permite ejecutar scripts escritos en Lua de forma **atómica** en el
servidor: la herramienta más potente para operaciones multi-paso con lógica
condicional.

#### EVAL

```
EVAL "return redis.call('SET', KEYS[1], ARGV[1])" 1 nombre "Ana"
```

- El primer argumento es el script (string Lua); el segundo, el **número de claves**.
- Los nombres de claves van en **KEYS[]** y el resto de argumentos en **ARGV[]**.
  Por convención se declaran las claves como KEYS, porque la replicación y la
  evaluación de slots del clúster dependen de que estén declaradas.

#### redis.call() vs redis.pcall()

- `redis.call('COMANDO', args...)` ejecuta un comando Redis; si falla, **aborta el
  script** con el error.
- `redis.pcall('COMANDO', args...)` ejecuta el comando y devuelve el error como
  tabla para poder manejarlo en Lua.

```
EVAL "return redis.pcall('GET', KEYS[1])" 1 inexistente
# (nil)
```

#### KEYS[] y ARGV[] con un ejemplo real

Un rate limiter atómico: permitir máximo 5 accesos por minuto por usuario.

```
EVAL "
local actual = tonumber(redis.call('GET', KEYS[1]) or '0')
if actual >= tonumber(ARGV[1]) then
  return 0
end
redis.call('INCR', KEYS[1])
redis.call('EXPIRE', KEYS[1], ARGV[2])
return 1
" 1 rate:user:42 5 60
```

Todo este bloque se ejecuta **sin que ningún otro cliente pueda intercalarse**, lo
que elimina la carrera que tendrías con GET+INCR sueltos.

#### EVALSHA y SCRIPT LOAD

Cada vez que haces EVAL, el servidor compila el script. Para evitar recompilar en
cada llamada, se puede **cargar el script** una vez y ejecutar su **SHA1 hash**:

```
> SCRIPT LOAD "return redis.call('SET', KEYS[1], ARGV[1])"
"b1c...sha1..."
> EVALSHA b1c...sha1... 1 miClave "valor"
OK
```

- `EVALSHA sha1 numkeys ...` ejecuta un script ya cargado por su hash.
- Si el hash no existe, devuelve error `NOSCRIPT` y la aplicación debe recompilar
  con EVAL o SCRIPT LOAD. En clúster, los scripts deben cargarse en **todos** los
  nodos que lo usen.

#### SCRIPT LOAD / SCRIPT EXISTS / SCRIPT FLUSH

| Comando | Descripción | Complejidad |
|---|---|---|
| SCRIPT LOAD <script> | Compila el script y devuelve su SHA1 | O(longitud) |
| SCRIPT EXISTS sha1 [...] | Devuelve 1/0 si el script está en caché | O(N) |
| SCRIPT FLUSH | Elimina todos los scripts en caché | O(N) |
| SCRIPT KILL | Mata un script en ejecución (si no escribió) | O(1) |
| EVALSHA | Ejecuta un script por su SHA1 | O(longitud) |
| EVAL | Compila y ejecuta un script | O(longitud) |

#### Ventajas de Lua

- **Atomicidad de múltiples pasos**: lectura + cálculo + escritura sin intercalación.
- **Menos RTT**: toda la lógica va en un solo viaje de red.
- **Lógica condicional** dentro del servidor (if/else, bucles, llamadas múltiples).
- **Reutilizable**: EVALSHA evita recompilar el script.

#### Casos de uso típicos

1. **Rate limiter atómico** (el ejemplo anterior).
2. **Transferencias entre cuentas**: debitar A y acreditar B, validando saldo en
   el mismo script.
3. **Inventarios con condiciones** (vender solo si hay stock).
4. **Comparar y fijar (CAS)** con lógica arbitraria.
5. **Recorrer estructuras y agregar** sin traer los datos al cliente.

```
-- Transferencia atómica: solo si el origen tiene saldo
EVAL "
local saldo = tonumber(redis.call('GET', KEYS[1]) or '0')
local monto = tonumber(ARGV[1])
if saldo < monto then
  return redis.error_reply('SALDO_INSUFICIENTE')
end
redis.call('DECRBY', KEYS[1], monto)
redis.call('INCRBY', KEYS[2], monto)
return 'OK'
" 2 cuenta:a cuenta:b 100
```

#### Precauciones

- **Los scripts bloquean el servidor** mientras corren: manténlos cortos y sin
  loops grandes (un bucle infinito bloquea a todos los clientes).
- No accedas a claves que no declares en KEYS: rompería la compatibilidad con el
  clúster y la replicación.

### Persistencia RDB

RDB (Redis DataBase) es el formato de **snapshot (instantánea)** binario: una
copia puntual de todos los datos en disco.

#### Cómo funciona

- En momentos determinados, Redis hace un **fork** y el proceso hijo escribe el
  dataset a un archivo `.rdb` (por defecto `dump.rdb`) mientras el padre sigue
  sirviendo peticiones (copia por escritura, copy-on-write).

#### SAVE vs BGSAVE

| Comando | Bloquea el servidor | Uso recomendado |
|---|---|---|
| SAVE | SÍ, bloquea todo | Backups manuales planificados, con bajo tráfico |
| BGSAVE | NO (fork + hijo) | Uso normal / automatizado |

```
> SAVE
OK                 # bloquea el servidor hasta terminar
> BGSAVE
Background saving started
```

- `BGSAVE` devuelve de inmediato; comprueba el resultado con `LASTSAVE` (timestamp
  Unix del último snapshot) o `INFO persistence.rdb_last_bgsave_status`.
- Si hay un BGSAVE en curso, un nuevo BGSAVE falla (o `BGSAVE SCHEDULE` lo encola).
- `stop-writes-on-bgsave-error yes` (por defecto): Redis **deja de aceptar
  escrituras** si un BGSAVE falla, para no prometer persistencia que no puede
  cumplir. `INFO persistence` expone `rdb_changes_since_last_save`, etc.

#### Snapshots automáticos: directiva save

En `redis.conf` la directiva `save` define cuándo hacer snapshots. Formato:
`save <segundos> <cambios>`. Si hay al menos `<cambios>` escrituras en `<segundos>`
segundos, se dispara un BGSAVE.

Configuración por defecto de Redis:

```conf
save 3600 1      # al menos 1 cambio en 3600 s → snapshot
save 300 100     # al menos 100 cambios en 300 s → snapshot
save 60 10000    # al menos 10000 cambios en 60 s → snapshot
```

Se desactivan los snapshots con `save ""`.

#### Cuándo usar RDB

- **Adecuado para**: backups periódicos, datasets grandes que se quieren cargar
  rápido al arrancar, replicación (el snapshot inicial de una réplica suele ser un
  RDB), casos donde se tolera perder los últimos minutos de datos.
- **Limitación**: entre snapshot y snapshot, si el proceso muere se pierden los
  cambios de ese intervalo (la política por defecto puede perder hasta 1 minuto en
  picos altos de escritura).

#### RDBFORCE y últimas mejoras

- `INFO persistence` expone `rdb_last_save_time`, `rdb_changes_since_last_save`, etc.
- `--rdb-delay`, `stop-writes-on-bgsave-error yes` (por defecto Redis **deja de
  aceptar escrituras** si un BGSAVE falla, para no prometer persistencia que no
  puede cumplir).

### Persistencia AOF

AOF (Append Only File) registra **cada operación de escritura** en un log anexado,
con el que se reconstruye el dataset al arrancar.

#### Activación y comportamiento

```conf
appendonly yes
appendfilename "appendonly.aof"
appendfsync always|everysec|no
```

La directiva `appendfsync` define **cuándo** se sincroniza el buffer con el disco:

| Valor | fsync | Durabilidad | Coste de rendimiento |
|---|---|---|---|
| always | Cada comando | Máxima: no se pierde nada | Muy alto (cada escritura sync) |
| everysec | 1 vez por segundo | Pérdida de hasta 1 s | Bajo (recomendado) |
| no | Lo decide el SO | Pérdida arbitraria | El menor |

`everysec` es el valor recomendado en producción: combina buen rendimiento con
pérdida acotada.

#### Reescritura (compresión): BGREWRITEAOF

Con el tiempo el AOF crece con comandos redundantes (miles de INCR que podrían ser
un solo SET). `BGREWRITEAOF` reescribe el archivo desde cero con el estado actual
del dataset:

```
> BGREWRITEAOF
Background append only file rewriting started
```

- Se dispara automáticamente según `auto-aof-rewrite-percentage`.
- Un proceso hijo reescribe el archivo mientras el padre sigue anexando; al final
  Redis intercambia los archivos y aplica los cambios pendientes.

En Redis 7 el AOF puede comenzar con una sección RDB (datos actuales como
snapshot) y continuar con el log incremental: cargas más rápidas y archivo más
compacto:

```conf
aof-use-rdb-preamble yes
```

#### ¿Qué pasa si el AOF está corrupto?

`redis-check-aof --fix appendonly.aof` repara archivos truncados; con
`aof-load-truncated yes` Redis arranca aunque la última escritura esté incompleta.

### RDB vs AOF

| Criterio | RDB | AOF |
|---|---|---|
| Formato | Snapshot binario puntual | Log de escrituras |
| Pérdida de datos | La del intervalo entre snapshots | Según appendfsync (0 a ~1 s) |
| Tamaño | Más pequeño | Más grande (se controla con reescritura) |
| Carga al arrancar | Muy rápida | Más lenta (replay de comandos) |
| Efecto en rendimiento | Impacto puntual (fork) | Impacto continuo (escrituras) |
| Preferencia de uso | Backups, arranques rápidos | Durabilidad fina |

En Redis 7 es habitual **activar ambos** (RDB + AOF): el RDB acelera arranques y
carga de réplicas; el AOF garantiza pérdida mínima.

#### Recomendaciones de producción

- **Si quieres durabilidad**: AOF con `appendfsync everysec` + reescritura
  automática + RDB activo.
- **Si prefieres rendimiento máximo**: solo RDB con política `save` razonable, o
  persistencia desactivada (cache pura, siempre recreable).
- **Nunca** confíes solo en la persistencia para alta disponibilidad: usa
  replicación.
- Prueba restauraciones con regularidad: un backup que nunca restauras no es un
  backup.

### Configuración

Redis se configura desde el archivo `redis.conf` al arrancar y, en caliente, con
`CONFIG GET/SET`.

#### redis.conf

Algunas directivas clave:

```conf
# Persistencia
save 3600 1 300 100 60 10000
appendonly yes
appendfsync everysec

# Memoria
maxmemory 512mb
maxmemory-policy allkeys-lru

# Seguridad y red
requirepass mi-super-secreto
bind 127.0.0.1
port 6379
replicaof maestro-ip 6379
replica-read-only yes
```

#### CONFIG GET y CONFIG SET

```
> CONFIG GET save
1) "save"
2) "3600 1 300 100 60 10000"
> CONFIG GET maxmemory
1) "maxmemory"
2) "512mb"
> CONFIG SET maxmemory 1gb
OK
> CONFIG REWRITE
OK              # escribe los cambios en el redis.conf
```

- `CONFIG GET parametro*` admite globs (`CONFIG GET *memory*`).
- `CONFIG SET` modifica en caliente sin reiniciar.
- `CONFIG REWRITE` persiste la configuración actual en el redis.conf.
- Algunos parámetros no se pueden cambiar en caliente y requieren reinicio.

#### Parámetros relevantes por línea de comandos

```bash
redis-server --save "" --appendonly no           # sin persistencia
redis-server --save 60 10000 --appendonly yes    # snapshot + AOF
redis-server /etc/redis/redis.conf --port 7000   # desde archivo de config
```

#### INFO y sus secciones

`INFO` devuelve un texto con secciones; `INFO <seccion>` filtra:

```
> INFO server          # versión, proceso, uptime
> INFO clients         # conexiones activas
> INFO memory          # used_memory, frag, peak
> INFO persistence     # rdb/aof, last save, last rewrite
> INFO replication     # role, connected_slaves, offset
> INFO stats           # commands_processed, keyspace_hits, misses
> INFO keyspace        # db0:keys=N,expires=M
```

```
> INFO server | grep redis_version
redis_version:7.2.4
> INFO replication | grep master_link_status
master_link_status:up
> INFO memory | grep maxmemory
maxmemory:536870912
```

### Replicación maestro-réplica

La replicación mantiene **copias exactas** de un nodo maestro (primario) en uno o
más nodos réplica: escala lecturas y sobrevive a caídas del maestro.

#### REPLICAOF

Para convertir un servidor en réplica de otro:

```
# en el nodo réplica
> REPLICAOF 192.168.1.10 6379
OK

# para revertir: volver a ser maestro
> REPLICAOF NO ONE
OK
```

- La réplica recibe una copia inicial (normalmente un RDB) y después un flujo
  continuo de comandos replicados.
- Por defecto las réplicas son **solo lectura** (`replica-read-only yes`).
- `REPLICASOF` es el alias moderno de `SLAVEOF`.

#### Cómo funciona la replicación

1. El maestro inicia un `BGSAVE` y lo envía a la réplica; la réplica carga el
   snapshot.
2. A partir de ahí, el maestro envía cada escritura a la réplica, manteniendo un
   **offset de replicación** para detectar retraso.
3. Si la conexión se cae, se reanuda desde el offset si es posible; si no, se
   reinicia el snapshot.

```
> INFO replication
# Replication
role:master
connected_slaves:1
slave0:ip=192.168.1.11,port=6379,state=online,offset=12345
```

#### Alta disponibilidad: Sentinel y Clúster

- **Redis Sentinel**: monitoriza maestros y, si uno falla, promueve una réplica a
  maestro automáticamente (failover). No hace sharding; pensado para pocos nodos
  con réplicas. Se configura con directivas `sentinel monitor <nombre> <ip> <port>
  <quorum>` y se suelen desplegar al menos 3 sentinels.
- **Redis Cluster**: particionado de datos (sharding) entre nodos + réplicas +
  failover automático. La elección cuando los datos ya no caben en un solo nodo.

**En producción**: réplica (lecturas / failover manual), Sentinel (failover
automático) o Clúster (escala horizontal). Nunca una instancia única sin réplica
si hay SLA.

## Ejemplos de código

### Transacción básica con MULTI/EXEC y DISCARD

```bash
redis-cli
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> SET carrito:1:total 0
QUEUED
127.0.0.1:6379> INCRBY carrito:1:total 120
QUEUED
127.0.0.1:6379> INCRBY carrito:1:total 45
QUEUED
127.0.0.1:6379> EXEC
1) OK
2) (integer) 120
3) (integer) 165
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> SET carrito:1:total 0
QUEUED
127.0.0.1:6379> DISCARD
OK
127.0.0.1:6379> GET carrito:1:total
"165"          # el SET no se aplicó
```

### WATCH para un contador condicional (stock)

```bash
redis-cli
127.0.0.1:6379> SET stock:sku-7 3
OK
127.0.0.1:6379> WATCH stock:sku-7
OK
127.0.0.1:6379> GET stock:sku-7
"3"
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> DECR stock:sku-7
QUEUED
127.0.0.1:6379> EXEC
1) (integer) 2
127.0.0.1:6379> WATCH stock:sku-7
OK
# otro cliente ejecuta: SET stock:sku-7 99
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> DECR stock:sku-7
QUEUED
127.0.0.1:6379> EXEC
(nil)          # la clave cambió → no ejecutó nada
```

### Rate limiter atómico con Lua

```bash
redis-cli
127.0.0.1:6379> EVAL "local c = tonumber(redis.call('GET', KEYS[1]) or '0') if c >= tonumber(ARGV[1]) then return 0 end redis.call('INCR', KEYS[1]) redis.call('EXPIRE', KEYS[1], ARGV[2]) return 1" 1 rate:user:7 5 60
(integer) 1
127.0.0.1:6379> SCRIPT LOAD "return redis.call('GET', KEYS[1])"
"3ddb...sha1"
127.0.0.1:6379> EVALSHA 3ddb...sha1 1 rate:user:7
"1"
```

### Carga masiva con pipeline

```bash
# comandos SET en formato crudo, enviados por pipeline
printf 'SET k1 v1\r\nSET k2 v2\r\nSET k3 v3\r\n' | redis-cli --pipe

# medir el impacto con la utilidad del cliente
redis-benchmark -t set -n 100000 -P 100
```

### Persistencia en acción

```bash
redis-cli
127.0.0.1:6379> BGSAVE
Background saving started
127.0.0.1:6379> BGREWRITEAOF
Background append only file rewriting started
127.0.0.1:6379> CONFIG GET appendfsync
1) "appendfsync"
2) "everysec"
127.0.0.1:6379> INFO persistence
# Persistence
loading:0
rdb_last_bgsave_status:ok
aof_enabled:1
```

## Ejercicios relacionados

- [Ejercicios nivel 03](../ejercicios/nivel-03-*/)

## Errores comunes

### 1. Asumir que EXEC aborta ante un error en ejecución
**Causa**: creer que un comando que falla dentro de EXEC revierte los anteriores.
**Solución**: los errores en ejecución no abortan; solo los de encolado
(sintaxis/comando desconocido) abortan con EXECABORT.

### 2. No reintentar tras un EXEC que devuelve nil con WATCH
**Causa**: usar WATCH y, si EXEC devuelve nil, ignorarlo y continuar.
**Solución**: EXEC nil significa "no ejecuté nada": releer, re-evaluar la
condición y reintentar el ciclo WATCH → MULTI → EXEC.

### 3. Olvidar UNWATCH o reutilizar vigilancias viejas
**Causa**: ejecutar otra transacción con WATCH de un ciclo anterior.
**Solución**: usar UNWATCH (o un EXEC) al terminar el ciclo; no reutilizar WATCH.

### 4. Confundir pipeline con transacción
**Causa**: asumir que un pipeline es atómico.
**Solución**: el pipeline solo agrupa I/O; para atomicidad usa MULTI/EXEC (o Lua).

### 5. Scripts Lua que acceden a claves no declaradas en KEYS
**Causa**: usar valores en ARGV o literales como nombres de clave.
**Solución**: declarar todas las claves en KEYS para que la replicación y el
clúster puedan rastrear las escrituras.

### 6. Bucles infinitos o scripts demasiado largos en Lua
**Causa**: un script con `while true` o recorridos enormes bloquea el servidor.
**Solución**: scripts cortos sin loops grandes; `SCRIPT KILL` (si no escribió) o
`SHUTDOWN NOSAVE` como último recurso.

### 7. Asumir que RDB no pierde datos
**Causa**: pensar que el snapshot de cada `save` garantiza durabilidad total.
**Solución**: RDB pierde lo escrito tras el último snapshot; si necesitas pérdida
mínima usa AOF (`appendfsync everysec`) o ambos.

### 8. Usar SAVE en producción
**Causa**: lanzar SAVE manualmente con tráfico alto; bloquea el servidor entero.
**Solución**: usar BGSAVE (fork + hijo) o los snapshots automáticos de `save`.

### 9. No reescribir el AOF y dejar que crezca sin control
**Causa**: ignorar `auto-aof-rewrite-percentage`; el archivo acumula comandos
redundantes.
**Solución**: activar la reescritura automática o lanzar BGREWRITEAOF.

### 10. Exponer Redis sin autenticación
**Causa**: arrancar Redis en 0.0.0.0 sin requirepass ni ACLs.
**Solución**: requirepass o ACLs, `bind` a interfaces de confianza y desactivar
comandos peligrosos (CONFIG, KEYS) en entornos gestionados.

### 11. Configurar CONFIG SET pero no persistir los cambios
**Causa**: los cambios en caliente se pierden al reiniciar.
**Solución**: usar `CONFIG REWRITE` o editar `redis.conf`.

### 12. No monitorizar la replicación
**Causa**: asumir que la réplica está sincronizada sin comprobarlo.
**Solución**: revisar `INFO replication` (`master_link_status:up`,
`master_repl_offset` igual en ambos) y alertar ante retraso.

### 13. Escribir en la réplica
**Causa**: `replica-read-only no` o escrituras locales en la réplica; divergencia.
**Solución**: mantener `replica-read-only yes` salvo casos muy específicos.

### 14. Perder respuestas QUEUED y desordenar resultados
**Causa**: tratar las respuestas QUEUED como resultados reales.
**Solución**: los resultados reales llegan solo en el array de EXEC, en orden.

## Recursos

- [Transacciones (documentación oficial)](https://redis.io/docs/latest/develop/use/transactions/)
- [Atomicidad (librar la documentación)](https://redis.io/docs/latest/develop/use/features/atomicity/)
- [Scripting Lua (EVAL)](https://redis.io/docs/latest/develop/programmability/eval-intro/)
- [Persistencia (RDB y AOF)](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [Replicación maestro-réplica](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/)
- [Redis Sentinel](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
- [Referencia de comandos](https://redis.io/docs/latest/commands/)
- [Guía de comandos de transacciones](https://redis.io/docs/latest/commands/?group=transactions)
