# Ejercicio 01 — SET y GET

- **Nivel:** 1/5
- **Tema:** `SET`, `GET`, `EXISTS`, `TYPE`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET usuario:1:nombre Ana
SET usuario:1:ciudad Madrid
SET usuario:2:nombre Luis
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén el valor de `usuario:1:nombre`.
2. Obtén el valor de `usuario:2:nombre`.
3. Comprueba si existe la clave `usuario:1:nombre` (devuelve 1 o 0).
4. Comprueba si existe la clave `usuario:9:nombre` (no existe).
5. Consulta el tipo de dato de `usuario:1:ciudad`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-01-set-y-get-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `GET <clave>` devuelve el valor almacenado.
- Pista 2: `EXISTS <clave>` devuelve `1` si existe y `0` si no.
- Pista 3: `TYPE <clave>` devuelve el tipo (string, list, set, hash, zset).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
GET usuario:1:nombre
GET usuario:2:nombre
EXISTS usuario:1:nombre
EXISTS usuario:9:nombre
TYPE usuario:1:ciudad
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-01-set-y-get-test.sh   # requiere podman (levanta redis efímero)
```