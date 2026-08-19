# Ejercicio 06 — Rankings con sorted sets

- **Nivel:** 5/5
- **Tema:** `ZADD`, `ZREVRANGE`, `ZREVRANK`, `ZINCRBY`, rankings top-N
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
ZADD ranking 100 ana
ZADD ranking 90 luis
ZADD ranking 80 marta
ZADD ranking 95 pablo
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén el top-3 del ranking (los 3 primeros puestos en orden descendente).
2. Lista el ranking completo con sus puntuaciones, de mayor a menor.
3. Consulta la posición (rank) de `ana` en el ranking.
4. Suma 10 puntos a `marta` con `ZINCRBY`.
5. Vuelve a listar el ranking completo con puntuaciones y observa el nuevo orden.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-06-ranking-zsets-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- **Apuntes:** este es el patrón de **rankings top-N** (gamificación, líderes, trending). Un sorted set mantiene los miembros siempre ordenados por su score, de modo que el top-N se obtiene sin ordenar nada a mano. Redis encaja porque `ZADD`/`ZREVRANGE`/`ZREVRANK`/`ZINCRBY` son O(log N) (el conjunto está indexado internamente), `ZINCRBY` actualiza la posición del miembro de forma atómica en un solo paso, y todo el ranking vive en una única clave sin joins ni índices secundarios.
- Pista 1: `ZREVRANGE <clave> <inicio> <fin>` devuelve los miembros en orden descendente de score (`0 2` = top-3).
- Pista 2: Añade `WITHSCORES` a `ZREVRANGE` para incluir las puntuaciones.
- Pista 3: `ZREVRANK <clave> <miembro>` devuelve la posición del miembro (0 = primero); `ZINCRBY <clave> <incremento> <miembro>` suma puntos y reordena automáticamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
ZREVRANGE ranking 0 2
ZREVRANGE ranking 0 -1 WITHSCORES
ZREVRANK ranking ana
ZINCRBY ranking 10 marta
ZREVRANGE ranking 0 -1 WITHSCORES
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-06-ranking-zsets-test.sh   # requiere podman (levanta redis efímero)
```