# Ejercicio 04 — Rangos en sorted sets

- **Nivel:** 3/5
- **Tema:** `ZREVRANGE`, `ZRANGEBYSCORE`, `ZINCRBY`, `ZSCORE`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
ZADD ventas 100 prod_a
ZADD ventas 250 prod_b
ZADD ventas 180 prod_c
ZADD ventas 320 prod_d
```

El sorted set `ventas` guarda productos con sus ventas como score, de menor a mayor: `prod_a` (100), `prod_c` (180), `prod_b` (250), `prod_d` (320).

Responde las siguientes consultas con `redis-cli`:

1. Muestra los 2 productos con más ventas (rango `0 1` en orden descendente).
2. Muestra los productos con ventas entre `150` y `300` (ambos inclusive).
3. Incrementa las ventas de `prod_a` en `50`.
4. Consulta el score actual de `prod_a`.
5. Muestra todos los productos en orden ascendente para verificar el nuevo orden.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-04-sorted-sets-rangos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `ZREVRANGE <zset> <inicio> <fin>` devuelve los miembros entre dos posiciones en orden descendente de score.
- Pista 2: `ZRANGEBYSCORE <zset> <min> <max>` devuelve los miembros cuyo score está entre `min` y `max` (inclusive por defecto), en orden ascendente.
- Pista 3: `ZINCRBY <zset> <incremento> <miembro>` incrementa el score de un miembro y devuelve el nuevo score.
- Pista 4: `ZSCORE <zset> <miembro>` devuelve el score de un miembro.
- Pista 5: Tras incrementar `prod_a` en 50 su score pasa de `100` a `150`, con lo que pasa por delante de `prod_c` (180) en el orden ascendente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
ZREVRANGE ventas 0 1
ZRANGEBYSCORE ventas 150 300
ZINCRBY ventas 50 prod_a
ZSCORE ventas prod_a
ZRANGE ventas 0 -1
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-04-sorted-sets-rangos-test.sh   # requiere podman (levanta redis efímero)
```