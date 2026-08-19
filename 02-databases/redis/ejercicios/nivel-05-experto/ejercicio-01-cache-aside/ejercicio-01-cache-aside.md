# Ejercicio 01 — Cache-aside

- **Nivel:** 5/5
- **Tema:** `GET`, `TTL`, `EXISTS`, patrón cache-aside
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET cache:producto:1 '{id:1,nombre:mesa}' EX 300
SET cache:producto:2 '{id:2,nombre:silla}'
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén el valor cacheado del producto 1.
2. Consulta el TTL restante de `cache:producto:1` (en segundos).
3. Comprueba si existe la clave `cache:producto:2` (devuelve 1 o 0).

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-01-cache-aside-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- **Apuntes:** este es el patrón **cache-aside** (o lazy loading). La aplicación consulta primero la caché con `GET`; si hay *hit* devuelve el dato, si hay *miss* lee de la base de datos y vuelve a poblar la caché con `SET ... EX <ttl>`. Redis encaja perfectamente: `GET`/`SET` son O(1) y la expiración con `EX` evita que la caché se quede con datos obsoletos para siempre.
- Pista 1: `GET <clave>` devuelve el valor almacenado.
- Pista 2: `TTL <clave>` devuelve el tiempo de vida restante en segundos (o `-1` si no expira).
- Pista 3: `EXISTS <clave>` devuelve `1` si existe y `0` si no.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
GET cache:producto:1
TTL cache:producto:1
EXISTS cache:producto:2
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-01-cache-aside-test.sh   # requiere podman (levanta redis efímero)
```