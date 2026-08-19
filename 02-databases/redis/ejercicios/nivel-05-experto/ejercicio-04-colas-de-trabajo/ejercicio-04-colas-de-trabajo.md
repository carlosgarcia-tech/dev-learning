# Ejercicio 04 — Colas de trabajo

- **Nivel:** 5/5
- **Tema:** `RPUSH`, `LLEN`, `BLPOP`, `LRANGE`, colas FIFO con listas
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
RPUSH cola:trabajos t1
RPUSH cola:trabajos t2
RPUSH cola:trabajos t3
```

Responde las siguientes consultas con `redis-cli`:

1. Consulta la longitud actual de la cola `cola:trabajos`.
2. Extrae el primer trabajo de la cola usando un bloqueo con timeout de 1 segundo.
3. Extrae el siguiente trabajo (también con timeout de 1 segundo).
4. Consulta de nuevo la longitud de la cola.
5. Lista los elementos restantes de la cola.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-04-colas-de-trabajo-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- **Apuntes:** este es el patrón de **colas de trabajo FIFO** con listas Redis. Los productores encolan con `RPUSH` y los *workers* (consumidores) desencolan con `BLPOP`, que extrae por el otro extremo y, si la cola está vacía, bloquea al consumidor hasta que llegue trabajo o se agote el timeout. Redis encaja porque `RPUSH`/`BLPOP` son O(1) al operar por los extremos de la lista, y `BLPOP` evita *polling* ineficiente sobre la base de datos: los consumidores esperan dormidos y son despertados al instante.
- Pista 1: `LLEN <clave>` devuelve el número de elementos de la lista.
- Pista 2: `BLPOP <clave> <timeout>` extrae y devuelve el primer elemento (o bloquea hasta el timeout).
- Pista 3: `LRANGE <clave> 0 -1` lista todos los elementos de la cola en orden.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
LLEN cola:trabajos
BLPOP cola:trabajos 1
BLPOP cola:trabajos 1
LLEN cola:trabajos
LRANGE cola:trabajos 0 -1
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-04-colas-de-trabajo-test.sh   # requiere podman (levanta redis efímero)
```