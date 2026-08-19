# Ejercicio 03 — Sorted sets básicos

- **Nivel:** 3/5
- **Tema:** `ZADD`, `ZCARD`, `ZSCORE`, `ZRANGE`, `ZRANK`, `ZREM`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
ZADD ranking 10 ana
ZADD ranking 30 luis
ZADD ranking 20 marta
```

El sorted set `ranking` guarda miembros ordenados por su score (puntuación), de menor a mayor: `ana` (10), `marta` (20), `luis` (30).

Responde las siguientes consultas con `redis-cli`:

1. Cuenta cuántos miembros tiene el sorted set `ranking`.
2. Consulta el score de `luis`.
3. Muestra todos los miembros en orden ascendente de score (rango `0 -1`).
4. Consulta la posición (rank) de `marta`, empezando por `0`.
5. Elimina a `luis` del sorted set.
6. Cuenta de nuevo los miembros de `ranking`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-03-sorted-sets-basicos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `ZADD <zset> <score> <miembro>` añade un miembro con su score.
- Pista 2: `ZCARD <zset>` devuelve el número de miembros.
- Pista 3: `ZSCORE <zset> <miembro>` devuelve el score de un miembro.
- Pista 4: `ZRANGE <zset> <inicio> <fin>` devuelve los miembros entre dos posiciones (índices inclusivos, `0 -1` = todos) en orden ascendente de score.
- Pista 5: `ZRANK <zset> <miembro>` devuelve la posición (empezando en `0`) según el orden ascendente.
- Pista 6: `ZREM <zset> <miembro>` elimina un miembro y devuelve el número de eliminados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
ZCARD ranking
ZSCORE ranking luis
ZRANGE ranking 0 -1
ZRANK ranking marta
ZREM ranking luis
ZCARD ranking
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-sorted-sets-basicos-test.sh   # requiere podman (levanta redis efímero)
```