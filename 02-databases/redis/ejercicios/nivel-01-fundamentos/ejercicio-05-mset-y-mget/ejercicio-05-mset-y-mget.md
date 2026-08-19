# Ejercicio 05 — MSET y MGET

- **Nivel:** 1/5
- **Tema:** `MSET`, `MGET`, `SETNX`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
MSET nombre Ana edad 30 ciudad Madrid
SETNX promocion activa
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén de una sola vez los valores de `nombre`, `edad` y `ciudad` con `MGET`.
2. Intenta asignar `nombre` = `Otro` con `SETNX` (ya existe, devuelve 0).
3. Verifica que `nombre` sigue siendo `Ana`.
4. Crea las claves `email` y `pais` en un solo `MSET`.
5. Comprueba los valores de `email` y `pais` con `MGET`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-05-mset-y-mget-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `MSET <clave1> <valor1> <clave2> <valor2> ...` establece varias claves a la vez.
- Pista 2: `MGET <clave1> <clave2> ...` devuelve los valores en el mismo orden.
- Pista 3: `SETNX <clave> <valor>` solo asigna si la clave no existe (devuelve 1) y no hace nada si ya existe (devuelve 0).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
MGET nombre edad ciudad
SETNX nombre Otro
GET nombre
MSET email ana@mail.com pais ESP
MGET email pais
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-mset-y-mget-test.sh   # requiere podman (levanta redis efímero)
```