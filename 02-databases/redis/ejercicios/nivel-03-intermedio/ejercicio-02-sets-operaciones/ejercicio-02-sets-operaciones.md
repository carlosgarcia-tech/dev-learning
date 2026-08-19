# Ejercicio 02 — Operaciones con sets

- **Nivel:** 3/5
- **Tema:** `SINTERSTORE`, `SUNIONSTORE`, `SDIFFSTORE`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SADD frutas_a manzana pera uva
SADD frutas_b pera platano uva
```

Los sets `frutas_a` y `frutas_b` comparten `pera` y `uva`.

Responde las siguientes consultas con `redis-cli`:

1. Guarda en el set `comunes` la intersección de `frutas_a` y `frutas_b` (elementos presentes en ambos).
2. Cuenta los elementos de `comunes`.
3. Guarda en el set `todas` la unión de `frutas_a` y `frutas_b` (elementos de cualquiera de los dos).
4. Cuenta los elementos de `todas`.
5. Guarda en el set `solo_a` la diferencia `frutas_a - frutas_b` (elementos de `frutas_a` que no están en `frutas_b`).
6. Cuenta los elementos de `solo_a`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-02-sets-operaciones-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `SINTERSTORE <destino> <set_a> <set_b>` guarda la intersección en `destino` y devuelve el número de elementos.
- Pista 2: `SUNIONSTORE <destino> <set_a> <set_b>` guarda la unión en `destino` y devuelve el número de elementos.
- Pista 3: `SDIFFSTORE <destino> <set_a> <set_b>` guarda la diferencia en `destino` y devuelve el número de elementos.
- Pista 4: La intersección de `frutas_a` y `frutas_b` es `{pera, uva}`; la unión es `{manzana, pera, uva, platano}`; la diferencia `frutas_a - frutas_b` es `{manzana}`.
- Pista 5: Estas variantes con `STORE` devuelven la cardinalidad del resultado, por lo que son deterministas (a diferencia de `SINTER`, `SUNION` o `SDIFF` directos, que devuelven los miembros sin orden garantizado).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
SINTERSTORE comunes frutas_a frutas_b
SCARD comunes
SUNIONSTORE todas frutas_a frutas_b
SCARD todas
SDIFFSTORE solo_a frutas_a frutas_b
SCARD solo_a
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-02-sets-operaciones-test.sh   # requiere podman (levanta redis efímero)
```