# Ejercicio 02 — Listas: pop e indexado

- **Nivel:** 2/5
- **Tema:** `LINDEX`, `LPOP`, `RPOP`, `LSET`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
RPUSH fila a b c d
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén el primer elemento de `fila` (índice 0).
2. Obtén el último elemento de `fila` (índice -1).
3. Extrae y elimina el primer elemento de `fila`.
4. Extrae y elimina el último elemento de `fila`.
5. Muestra los elementos restantes de `fila`.
6. Reemplaza el elemento del índice 0 por `X`.
7. Muestra `fila` de nuevo para comprobar el cambio.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-02-listas-pop-y-indexado-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `LINDEX <clave> <índice>` lee un elemento sin eliminarlo.
- Pista 2: `LPOP` y `RPOP` devuelven el elemento y lo eliminan de la lista.
- Pista 3: `LSET <clave> <índice> <valor>` sobrescribe el elemento en esa posición.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
LINDEX fila 0
LINDEX fila -1
LPOP fila
RPOP fila
LRANGE fila 0 -1
LSET fila 0 X
LRANGE fila 0 -1
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-02-listas-pop-y-indexado-test.sh   # requiere podman (levanta redis efímero)
```
