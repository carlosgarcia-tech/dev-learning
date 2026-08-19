# Ejercicio 03 — Streams con grupos de consumidores

- **Nivel:** 4/5
- **Tema:** `XGROUP CREATE`, `XREADGROUP`, `XACK`, `XINFO GROUPS`
- **Tiempo estimado:** 15-20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
XADD eventos 1-0 tipo login
XADD eventos 2-0 tipo click
XADD eventos 3-0 tipo logout
```

Responde las siguientes consultas con `redis-cli`:

1. Crea el grupo de consumidores `g1` en el stream `eventos` a partir del ID `0`.
2. Lee con `XREADGROUP` desde el grupo `g1` como consumidor `consumidor`, pidiendo 2 entradas con `COUNT 2` usando `>` (solo mensajes nuevos).
3. Confirma los mensajes `1-0` y `2-0` con `XACK`.
4. Consulta la información del grupo con `XINFO GROUPS`.

> **Nota:** `XREADGROUP` con `>` entrega los IDs del stream; la salida muestra eventos, ids y campos.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-03-streams-grupos-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `XGROUP CREATE <stream> <grupo> <id>` crea el grupo; `0` lo crea desde el principio.
- Pista 2: `XREADGROUP GROUP <grupo> <consumidor> COUNT <n> STREAMS <stream> >` lee mensajes nuevos sin marcar como entregados a otros.
- Pista 3: `XACK <stream> <grupo> <id...>` confirma los mensajes procesados; `XINFO GROUPS <stream>` muestra consumidores, pendientes y lag.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
XGROUP CREATE eventos g1 0
XREADGROUP GROUP g1 consumidor COUNT 2 STREAMS eventos >
XACK eventos g1 1-0 2-0
XINFO GROUPS eventos
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-streams-grupos-test.sh   # requiere podman (levanta redis efímero)
```