# Redis

> Ruta de aprendizaje completa de Redis en español: guías de estudio, 30 ejercicios por niveles con tests y un proyecto final.

Redis es un almacén de datos en memoria de tipo key-value, extremadamente rápido (más de 100k operaciones/segundo), usado como **caché**, **cola de mensajes**, **gestor de sesiones**, **rankings** y **rate limiting**. Sus estructuras de datos (strings, listas, hashes, sets, sorted sets, bitmaps, geo y streams) lo convierten en la pieza central de cualquier sistema backend moderno.

Esta ruta asume que sabes lo básico de programación pero parte desde cero en Redis. Cada guía introduce la teoría con comandos ejecutables y enlaza a los ejercicios que la refuerzan.

> **Nota de entorno:** los ejercicios se ejecutan con `redis-cli` contra un Redis **efímero levantado con podman** (`docker.io/library/redis:7-alpine`), así que puedes practicarlos todos aquí mismo. Cada ejercicio incluye su propio `test.sh` que levanta Redis, carga el estado inicial, ejecuta la solución y compara la salida esperada.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Strings, números, expiración, keys, redis-cli y tipos de datos |
| [02 — Estructuras de datos](02-estructuras-de-datos.md) | Listas, hashes, sets, sorted sets, bitmaps, geo y streams |
| [03 — Transacciones y persistencia](03-transacciones-y-persistencia.md) | MULTI/EXEC, WATCH, pipelines, Lua, RDB/AOF, replicación |
| [04 — Avanzado y rendimiento](04-avanzado-y-rendimiento.md) | Expulsión LRU/LFU, SCAN, slow queries, clúster, seguridad |
| [05 — Patrones y producción](05-patrones-y-produccion.md) | Cache-aside, rate limiting, sesiones, colas, rankings, locks, despliegue |

## Ejercicios por nivel

Cada ejercicio es una carpeta con **enunciado, requisitos, pistas y solución** (`ejercicio-0N-slug.md`), el **estado inicial** (`setup.redis`), la **solución** (`solucion.redis`), la **salida esperada** (`expected.txt`) y un **script de tests** (`test.sh`) que verifica con podman.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | SET/GET, DEL/APPEND, INCR/DECR, EXPIRE/TTL, MSET/MGET, KEYS/DBSIZE |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Listas (basicas, pop, avanzadas) y hashes (basicos, contadores, busqueda) |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Sets, operaciones de sets, sorted sets, rangos, MULTI/EXEC, WATCH |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | Expiración avanzada, streams, grupos de consumidores, geo, bitmaps, Lua |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | Cache-aside, rate limiting, sesiones, colas de trabajo, contadores, rankings |

Índice completo: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Caché para un blog** — cache-aside, contadores de visitas y ranking de posts.
2. **Sesiones y cola de trabajos** — autenticación por sesión y procesamiento FIFO.
3. **[PROYECTO FINAL: E-commerce en tiempo real](ejercicios/proyectos/proyecto-final/)** — 15 consultas y tests automáticos sobre un sistema real.

## Cómo ejecutar los tests

Cada ejercicio se verifica desde su propia carpeta (requiere podman):

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-set-y-get
bash ejercicio-01-set-y-get-test.sh   # levanta redis efímero, aplica setup, ejecuta solución y compara
```