# Ejercicio 03 — Listas avanzadas

- **Nivel:** 2/5
- **Tema:** `LREM`, `LINSERT`, `LTRIM`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
RPUSH log err1 warn1 err2 warn2
RPUSH cola 1 2 3 4 5
```

Responde las siguientes consultas con `redis-cli`:

1. Elimina una aparición de `err1` en la lista `log`.
2. Muestra el contenido actual de `log`.
3. Inserta `errX` justo después de `warn1` en `log`.
4. Muestra `log` de nuevo para comprobar el cambio.
5. Recorta `cola` para que solo conserve los elementos entre los índices 1 y 3.
6. Muestra `cola` para comprobar el resultado.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-03-listas-avanzadas-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `LREM <clave> <contador> <valor>` elimina apariciones de `<valor>`; con `1` elimina solo una.
- Pista 2: `LINSERT <clave> BEFORE|AFTER <pivote> <valor>` inserta relativo a un elemento existente.
- Pista 3: `LTRIM <clave> <inicio> <fin>` descarta todo lo que quede fuera del rango.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
LREM log 1 err1
LRANGE log 0 -1
LINSERT log AFTER warn1 errX
LRANGE log 0 -1
LTRIM cola 1 3
LRANGE cola 0 -1
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-listas-avanzadas-test.sh   # requiere podman (levanta redis efímero)
```
