# Ejercicio 02 — DEL y APPEND

- **Nivel:** 1/5
- **Tema:** `DEL`, `APPEND`, `STRLEN`, `GETSET`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET msg Hola
APPEND msg ' mundo'
SET temp borrar
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén el valor de `msg` (debe incluir el texto añadido con `APPEND`).
2. Consulta la longitud de `msg` con `STRLEN`.
3. Elimina la clave `temp` con `DEL`.
4. Comprueba si existe la clave `temp` después de borrarla (devuelve 1 o 0).
5. Usa `GETSET` para reemplazar el valor de `msg` por `nuevo`.
6. Verifica el nuevo valor de `msg`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-02-del-y-append-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `APPEND <clave> <valor>` concatena el valor al final de la cadena.
- Pista 2: `STRLEN <clave>` devuelve el número de caracteres de la cadena.
- Pista 3: `DEL <clave>` devuelve el número de claves eliminadas y `GETSET <clave> <valor>` devuelve el valor anterior antes de reemplazarlo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
GET msg
STRLEN msg
DEL temp
EXISTS temp
GETSET msg nuevo
GET msg
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-02-del-y-append-test.sh   # requiere podman (levanta redis efímero)
```