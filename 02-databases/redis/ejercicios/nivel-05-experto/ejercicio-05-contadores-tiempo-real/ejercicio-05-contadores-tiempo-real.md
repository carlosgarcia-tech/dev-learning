# Ejercicio 05 — Contadores en tiempo real

- **Nivel:** 5/5
- **Tema:** `INCRBY`, `GET`, `ZINCRBY`, `ZSCORE`, `ZRANGE ... WITHSCORES`
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
INCRBY contador:ventas:hoy 5
INCRBY contador:ventas:hoy 3
ZINCRBY ranking:dias 5 hoy
ZINCRBY ranking:dias 3 hoy
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén el valor del contador de ventas de hoy.
2. Consulta la puntuación (score) de la clave `hoy` en el ranking `ranking:dias`.
3. Lista el contenido del ranking del día con sus puntuaciones.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-05-contadores-tiempo-real-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- **Apuntes:** este es el patrón de **contadores en tiempo real** (métricas, ventas, visualizaciones). Los contadores simples se acumulan con `INCRBY` y las agregaciones por período se llevan en sorted sets con `ZINCRBY`, donde cada miembro es una clave (día, producto, ...) y su score es el total acumulado. Redis encaja porque `INCRBY`/`ZINCRBY` son atómicos (dos peticiones concurrentes no pierden incrementos), O(1), y no requieren *locking* como en una base relacional.
- Pista 1: `GET <clave>` devuelve el valor del contador acumulado.
- Pista 2: `ZSCORE <clave> <miembro>` devuelve la puntuación de un miembro del sorted set.
- Pista 3: `ZRANGE <clave> 0 -1 WITHSCORES` lista todos los miembros con sus scores en orden ascendente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
GET contador:ventas:hoy
ZSCORE ranking:dias hoy
ZRANGE ranking:dias 0 -1 WITHSCORES
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-contadores-tiempo-real-test.sh   # requiere podman (levanta redis efímero)
```