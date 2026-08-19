# Ejercicio 04 — Hashes básicos

- **Nivel:** 2/5
- **Tema:** `HSET`, `HGET`, `HMGET`, `HGETALL`, `HLEN`, `HEXISTS`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
HSET user:1 nombre Ana
HSET user:1 edad 30
HSET user:1 ciudad Madrid
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén el valor del campo `nombre` de `user:1`.
2. Obtén a la vez los valores de los campos `nombre` y `ciudad`.
3. Muestra todos los campos y valores de `user:1`.
4. Obtén el número de campos de `user:1`.
5. Comprueba si `user:1` tiene un campo `edad` (devuelve 1 o 0).

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-04-hashes-basicos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `HGET <clave> <campo>` lee un solo campo; `HMGET <clave> <campo>...` lee varios a la vez.
- Pista 2: `HGETALL <clave>` devuelve todos los campos y valores alternados.
- Pista 3: `HLEN <clave>` cuenta los campos y `HEXISTS <clave> <campo>` devuelve `1` si existe y `0` si no.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
HGET user:1 nombre
HMGET user:1 nombre ciudad
HGETALL user:1
HLEN user:1
HEXISTS user:1 edad
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-04-hashes-basicos-test.sh   # requiere podman (levanta redis efímero)
```
