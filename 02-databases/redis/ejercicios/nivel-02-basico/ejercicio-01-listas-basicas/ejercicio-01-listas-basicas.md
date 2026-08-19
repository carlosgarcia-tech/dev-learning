# Ejercicio 01 — Listas básicas

- **Nivel:** 2/5
- **Tema:** `RPUSH`, `LPUSH`, `LRANGE`, `LLEN`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
RPUSH tareas lavar
RPUSH tareas planchar
LPUSH tareas urgente
```

Responde las siguientes consultas con `redis-cli`:

1. Obtén la longitud de la lista `tareas`.
2. Muestra todos los elementos de `tareas`.
3. Muestra solo los dos primeros elementos de `tareas`.
4. Muestra los dos últimos elementos de `tareas`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-01-listas-basicas-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `RPUSH <clave> <valor>` añade al final y `LPUSH <clave> <valor>` al principio.
- Pista 2: `LLEN <clave>` devuelve la cantidad de elementos.
- Pista 3: `LRANGE <clave> <inicio> <fin>` recorre la lista; `0 -1` muestra todo y los índices negativos cuentan desde el final.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
LLEN tareas
LRANGE tareas 0 -1
LRANGE tareas 0 1
LRANGE tareas -2 -1
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-01-listas-basicas-test.sh   # requiere podman (levanta redis efímero)
```
