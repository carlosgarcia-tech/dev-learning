# Ejercicio 06 — KEYS y DBSIZE

- **Nivel:** 1/5
- **Tema:** `KEYS`, `DBSIZE`, `EXISTS`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET usuario:1 Ana
SET usuario:2 Luis
SET producto:1 mesa
SET producto:2 silla
SET color:1 rojo
```

Responde las siguientes consultas con `redis-cli`:

1. Lista todas las claves que empiecen por `usuario:` con `KEYS usuario:*`.
2. Lista todas las claves que empiecen por `producto:` con `KEYS producto:*`.
3. Consulta el número total de claves en la base de datos con `DBSIZE`.
4. Comprueba si existe la clave `color:1` (devuelve 1 o 0).

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-06-keys-y-dbsize-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `KEYS <patrón>` busca claves usando comodines como `*` (todo) y `?` (un carácter).
- Pista 2: `DBSIZE` devuelve el número de claves de la base de datos actual.
- Pista 3: `EXISTS <clave>` devuelve `1` si la clave existe y `0` si no.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
KEYS usuario:*
KEYS producto:*
DBSIZE
EXISTS color:1
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-06-keys-y-dbsize-test.sh   # requiere podman (levanta redis efímero)
```