# Ejercicio 01 — Expiración avanzada

- **Nivel:** 4/5
- **Tema:** `SET EX`, `SETEX`, `TTL`, `PTTL`, `PERSIST`, `EXPIRE`
- **Tiempo estimado:** 15-20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET normal valor
SETEX api:key 120 limit
```

Responde las siguientes consultas con `redis-cli`:

1. Consulta el `TTL` de la clave `normal` (no tiene expiración).
2. Consulta el `TTL` de la clave `inexistente` (no existe).
3. Comprueba si existe la clave `api:key` (devuelve 1 o 0).
4. Obtén el valor de `api:key`.
5. Elimina la expiración de `normal` con `PERSIST` (devuelve 1 si la tenía, 0 si no).
6. Consulta de nuevo el `TTL` de `normal`.
7. Asigna una expiración de 300 segundos a `normal` con `EXPIRE` (devuelve 1).
8. Obtén el valor de `normal`.

> **Nota:** los tests usan comandos deterministas y evitan consultar el `TTL` de claves con expiración activa, ya que ese valor varía con el tiempo.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-01-expiracion-avanzada-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `TTL <clave>` devuelve `-1` si la clave existe sin expiración y `-2` si no existe.
- Pista 2: `PERSIST <clave>` elimina la expiración y devuelve `1` si la tenía, `0` si no.
- Pista 3: `EXPIRE <clave> <segundos>` asigna una expiración y devuelve `1` si tuvo éxito.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
TTL normal
TTL inexistente
EXISTS api:key
GET api:key
PERSIST normal
TTL normal
EXPIRE normal 300
GET normal
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-01-expiracion-avanzada-test.sh   # requiere podman (levanta redis efímero)
```