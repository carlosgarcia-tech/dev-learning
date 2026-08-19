# Ejercicio 04 — EXPIRE y TTL

- **Nivel:** 1/5
- **Tema:** `EXPIRE`, `TTL`, `PERSIST`, `SETEX`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET sesion abc123
SET token t987
EXPIRE token 3600
SETEX cupon 86400 descuento
```

Responde las siguientes consultas con `redis-cli`:

1. Consulta el `TTL` de `sesion` (clave sin expiración).
2. Consulta el `TTL` de una clave inexistente como `noexiste`.
3. Comprueba si existe la clave `cupon`.
4. Obtén el valor de `cupon` creada con `SETEX`.
5. Elimina la expiración de `token` con `PERSIST`.
6. Verifica que `token` ya no tiene expiración consultando su `TTL`.
7. Asigna una expiración de 3600 segundos a `sesion` con `EXPIRE`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-04-expire-y-ttl-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `TTL <clave>` devuelve `-1` si la clave existe sin expiración y `-2` si no existe.
- Pista 2: `SETEX <clave> <segundos> <valor>` crea una clave con expiración en un solo comando.
- Pista 3: `PERSIST <clave>` elimina la expiración y devuelve `1` si lo consigue.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
TTL sesion
TTL noexiste
EXISTS cupon
GET cupon
PERSIST token
TTL token
EXPIRE sesion 3600
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-04-expire-y-ttl-test.sh   # requiere podman (levanta redis efímero)
```