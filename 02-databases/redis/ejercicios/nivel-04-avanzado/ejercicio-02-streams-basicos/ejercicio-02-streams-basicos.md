# Ejercicio 02 — Streams básicos

- **Nivel:** 4/5
- **Tema:** `XADD`, `XLEN`, `XRANGE`
- **Tiempo estimado:** 15-20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
XADD eventos 1-0 tipo login
XADD eventos 2-0 tipo click
XADD eventos 3-0 tipo logout
```

Responde las siguientes consultas con `redis-cli`:

1. Consulta el número de entradas del stream `eventos` con `XLEN`.
2. Consulta todas las entradas del stream `eventos` con `XRANGE`.
3. Consulta solo las entradas con IDs entre `2-0` y `3-0`.

> **Nota:** se usan IDs explícitos (`1-0`, `2-0`, `3-0`) para que la salida sea determinista.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-02-streams-basicos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `XLEN <stream>` devuelve el número de entradas del stream.
- Pista 2: `XRANGE <stream> - +` devuelve todas las entradas en orden de inserción.
- Pista 3: `XRANGE <stream> <inicio> <fin>` filtra por rango de IDs.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
XLEN eventos
XRANGE eventos - +
XRANGE eventos 2-0 3-0
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-02-streams-basicos-test.sh   # requiere podman (levanta redis efímero)
```