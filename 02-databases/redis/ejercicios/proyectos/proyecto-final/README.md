# PROYECTO FINAL — E-commerce en tiempo real con Redis

El proyecto que integra **todas** las técnicas del bloque Redis sobre un sistema real evaluado con tests automáticos: strings con expiración (caché), hashes (productos, sesiones, carritos), listas (cola de pedidos), sorted sets (ranking de ventas), contadores atómicos y transacciones (MULTI/EXEC, WATCH).

## Qué incluye

- **Estado inicial entregado**: `setup.redis` carga 5 productos, 2 sesiones activas, 2 carritos, contadores de visitas/ventas, caché de productos calientes (cache-aside), ranking de ventas inicial y cola de pedidos.
- **15 consultas en `consultas/`**: operaciones reales de un e-commerce — desde leer un producto hasta transacciones MULTI/EXEC para registrar una venta y actualizar el ranking.
- **Batería de tests** en `tests/`: 15 scripts (`test-01`…`test-15`) que levantan Redis con podman, cargan el setup, ejecutan la consulta y comparan la salida contra `expected-*.txt`.
- **Evaluación objetiva**: todos los tests deben quedar en verde (`OK`) contra la solución de referencia.

## Estructura

```
proyecto-final/
├── README.md
├── setup.redis            # estado inicial (NO modificar)
├── consultas/             # 15 archivos .redis para resolver
│   ├── consulta-01.redis  … consulta-15.redis
└── tests/                 # 15 scripts + expected-*.txt
    ├── test-01.sh  …  test-15.sh
    └── expected-01.txt  …  expected-15.txt
```

## Fases

### Fase 0 — Exploración

Carga el estado inicial y revisa el modelo de datos:

```bash
podman run -d --name redis-final -p 6379:6379 redis:7-alpine
sleep 1
podman exec -i redis-final redis-cli < setup.redis
```

Inspecciona las claves:

```redis
KEYS *
HGETALL producto:1
HGETALL sesion:abc123
HGETALL carrito:1
ZRANGE ranking:ventas 0 -1 WITHSCORES
LRANGE cola:pedidos 0 -1
```

### Fase 1 — Lectura (consultas 01-02)

1. **consulta-01**: obtener el producto `producto:1` completo (`HGETALL`).
2. **consulta-02**: obtener la sesión de `abc123` con su TTL restante.

### Fase 2 — Carrito y contadores (consultas 03-07)

3. **consulta-03**: añadir el producto `4` (cantidad 1) al carrito del usuario 1 y verificar.
4. **consulta-04**: mostrar el carrito del usuario 1 completo.
5. **consulta-05**: registrar 2 visitas nuevas (contador atómico con `INCR`).
6. **consulta-06**: leer el producto 1 desde la caché (cache-aside) y su TTL.
7. **consulta-07**: crear un rate limiter para el usuario 2 (contador + `EXPIRE`).

### Fase 3 — Venta atómica (consultas 08-12)

8. **consulta-08**: registrar una venta en una transacción `MULTI/EXEC`: decrementar stock del producto 2, incrementar el contador de ventas y actualizar el ranking.
9. **consulta-09**: encolar un pedido nuevo (`RPUSH`) y comprobar la longitud de la cola.
10. **consulta-10**: procesar el primer pedido de la cola (`BLPOP`).
11. **consulta-11**: top 3 de productos más vendidos (`ZREVRANGE … WITHSCORES`).
12. **consulta-12**: comprobar el stock restante del producto 2 tras la venta.

### Fase 4 — Optimismo y cierre (consultas 13-15)

13. **consulta-13**: vigilar `lock:inventario` con `WATCH`, leerlo y `UNWATCH` (patrón de bloqueo optimista).
14. **consulta-14**: leer el contador total de ventas del día.
15. **consulta-15**: ranking de ventas completo (`ZREVRANGE` con `WITHSCORES`).

### Fase 5 — Cierre

Ejecuta los tests hasta que los 15 pasen:

```bash
cd tests
bash test-01.sh   # … hasta bash test-15.sh
```

Cada test levanta su propio Redis efímero con podman, por lo que son independientes y deterministas.

## Requisitos mínimos

- [ ] No modificar `setup.redis` ni los `expected-*.txt`.
- [ ] Resolver las 15 consultas en `consultas/` (cada archivo sin el texto `TODO`).
- [ ] `bash test-01.sh` … `bash test-15.sh` en verde (15/15 `OK`).
- [ ] Entender por qué la venta de la consulta-08 es atómica y qué pasa si un `EXEC` falla.

## Cómo se evalúa

Cada `test-NN.sh`:

1. Levanta un contenedor Redis efímero con podman.
2. Carga `setup.redis`.
3. Ejecuta `consultas/consulta-NN.redis`.
4. Compara la salida contra `tests/expected-NN.txt` con `diff`.

Si la salida coincide, imprime `OK` y termina con `exit(0)`; si no, muestra el `diff` y termina con `exit(1)`.