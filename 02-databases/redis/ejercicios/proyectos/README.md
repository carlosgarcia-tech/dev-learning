# Proyectos integradores — Redis

Proyectos que combinan **todo** lo aprendido en las guías y ejercicios: strings, expiración, hashes, listas, sets, sorted sets, streams, transacciones, WATCH, Lua y patrones de producción.

Cada proyecto se organiza en **fases**. Completa las fases en orden y verifica cada una ejecutando los comandos contra un Redis local (podman).

Los dos primeros proyectos son de dificultad creciente y se resuelven a mano. El **Proyecto 3 es el PROYECTO FINAL**: un e-commerce en tiempo real con estado inicial entregado (`setup.redis`), 15 consultas/operaciones para resolver y una batería de **tests automatizados** que evalúan el resultado.

---

## Proyecto 1 — Caché para un blog

Sistema de caché para un blog que sirve posts y evita golpear la base de datos. Se diseña y ejecuta a mano (sin tests).

Fases:
1. **Caché de posts (cache-aside)**: para cada post, `SET post:<id> <html> EX <ttl>`. Lectura: `GET post:<id>` primero; si falta (nil), se genera y se guarda con `SETEX`. Simula 3 posts con TTL de 300 s y comprueba `TTL`, `GET` y `EXISTS`.
2. **Contador de visitas**: `INCR contador:visitas:<dia>` por post y total. Simula 5 visitas al post 1 y 3 al post 2; comprueba los contadores y usa `HINCRBY` si quieres llevar visitas por post en un hash.
3. **Ranking de posts populares**: `ZINCRBY ranking:posts <n> post:<id>` al registrar cada visita. Al final, top 3 con `ZREVRANGE ranking:posts 0 2 WITHSCORES`.
4. **Invalidación**: al editar un post, `DEL post:<id>` para que la próxima lectura regenere el caché. Simula la edición del post 1 y comprueba que `EXISTS post:1` es 0.

Requisitos mínimos:
- [ ] Todas las claves con el prefijo correcto (`post:`, `contador:`, `ranking:`).
- [ ] TTL en todas las claves de caché.
- [ ] Demostrar cache-aside: lectura → miss → escritura → hit.

---

## Proyecto 2 — Sesiones y cola de trabajos

Sistema de autenticación por sesión + cola de trabajos asíncrona para un servicio web. Se diseña y ejecuta a mano (sin tests).

Fases:
1. **Sesiones**: `HSET sesion:<token> user_id <id> nombre <n> rol <rol>` + `EXPIRE sesion:<token> 1800`. Simula 2 usuarios logueados y comprueba `HGETALL`, `TTL` y `HEXISTS`.
2. **Renovación**: al recibir una petición, renuevas el TTL (`EXPIRE sesion:<token> 1800`) si queda tiempo; si el token no existe, la sesión caducó.
3. **Cola de trabajos FIFO**: `RPUSH cola:trabajos <job>` para encolar y `BLPOP cola:trabajos 0` para procesar. Simula 3 trabajos, procesa 2 con `BLPOP` (timeout 1) y comprueba `LLEN` restante.
4. **Trabajo atómico con contador**: cada trabajo procesado incrementa `INCR contador:trabajos:hechos`. Comprueba que el contador coincide con los trabajos sacados.

Requisitos mínimos:
- [ ] Sesiones en hash con expiración (logout = `DEL sesion:<token>`).
- [ ] Cola FIFO con listas (`RPUSH` + `BLPOP`).
- [ ] Contador atómico de trabajos procesados.

---

## Proyecto 3 — PROYECTO FINAL: E-commerce en tiempo real

El proyecto que integra **todas** las técnicas del bloque Redis sobre un sistema real y evaluado con tests automáticos. Ver [su especificación completa](./proyecto-final/README.md).

Qué incluye:
- **Estado inicial entregado**: `setup.redis` (5 productos, 2 sesiones, 2 carritos, contadores, caché cache-aside, ranking inicial y cola de pedidos) con datos coherentes entre sí.
- **15 consultas en `consultas/`**: lectura de productos y sesiones, carrito, contadores atómicos, cache-aside, rate limiting, venta atómica con `MULTI/EXEC`, cola de pedidos, ranking top-3 y ranking completo, `WATCH`/`UNWATCH`.
- **Batería de tests** en `tests/`: 15 scripts (`test-01`…`test-15`) que levantan Redis efímero con podman, cargan el setup, ejecutan la consulta y comparan la salida contra `expected-*.txt`.
- **Evaluación objetiva**: todos los tests deben quedar en verde (`OK`) contra la solución de referencia.

Fases:
1. **Exploración** (Fase 0): cargar `setup.redis` y revisar el modelo (`KEYS *`, `HGETALL`, `ZRANGE`, `LRANGE`).
2. **Lectura y contadores** (consultas 01-07): producto, sesión, carrito, visitas, cache-aside, rate limiting.
3. **Venta atómica** (consultas 08-12): transacción `MULTI/EXEC`, cola de pedidos, top-3 y stock.
4. **Cierre** (consultas 13-15): `WATCH`/`UNWATCH`, contador total y ranking completo. Ejecutar los 15 tests hasta que pasen.

Requisitos mínimos (resumen; los criterios completos están en `proyecto-final/README.md`):
- [ ] No modificar `setup.redis` ni los `expected-*.txt`.
- [ ] Resolver las 15 consultas en `consultas/` (cada archivo sin el texto `TODO`).
- [ ] `bash test-01.sh` … `bash test-15.sh` en verde (15/15 `OK`).

---

## Requisitos para ejecutar los proyectos

Redis se levanta con podman (o cualquier Redis 7 local):

```bash
podman run -d --name redis-dev -p 6379:6379 redis:7-alpine
sleep 1
podman exec -i redis-dev redis-cli < setup.redis   # o redirige a redis-cli
```