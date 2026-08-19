# Ejercicio 03 — Sesiones

- **Nivel:** 5/5
- **Tema:** `HSET`, `HGETALL`, `TTL`, `EXPIRE`, sesiones en hash
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
HSET session:abc user_id 42
HSET session:abc rol admin
EXPIRE session:abc 1800
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén todos los campos y valores de la sesión `session:abc`.
2. Consulta el TTL restante de la sesión (en segundos).
3. Actualiza el campo `last_seen` de la sesión al timestamp `1234567890`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-03-sesiones-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- **Apuntes:** este es el patrón de **sesiones de usuario** en caché, típico de aplicaciones web. Se guarda cada sesión como un hash (una clave, múltiples campos: `user_id`, `rol`, `last_seen`, ...) y se le asigna un TTL que la invalida al caducar. Redis encaja porque `HSET`/`HGETALL` operan sobre un solo hash con O(1), los hashes permiten agrupar datos relacionados sin multiplicar claves, y el `EXPIRE` implementa el *timeout* de la sesión de forma nativa.
- Pista 1: `HGETALL <clave>` devuelve todos los pares campo-valor del hash.
- Pista 2: `TTL <clave>` devuelve el tiempo de vida restante en segundos.
- Pista 3: `HSET <clave> <campo> <valor>` crea o actualiza un campo del hash (devuelve 1 si es nuevo).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
HGETALL session:abc
TTL session:abc
HSET session:abc last_seen 1234567890
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-sesiones-test.sh   # requiere podman (levanta redis efímero)
```