# Ejercicio 06 — Scripts Lua

- **Nivel:** 4/5
- **Tema:** `EVAL`, `KEYS[1]`, `ARGV[1]`, `redis.call`
- **Tiempo estimado:** 15-20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET balance 100
```

Responde las siguientes consultas con `redis-cli`:

1. Ejecuta un script `EVAL` que devuelva el valor de la clave pasada como `KEYS[1]` (clave `balance`).
2. Ejecuta un script `EVAL` que incremente el valor de `KEYS[1]` en `ARGV[1]` con `INCRBY` (clave `balance`, incremento `50`).
3. Obtén el valor de `balance` con `GET` para verificar el resultado.

> **Nota:** los comandos `EVAL` contienen comillas dobles y llamadas a `redis.call`; escribe el script tal cual.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-06-lua-scripts-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `EVAL "<script>" <numkeys> <key1> ...` ejecuta el script; `1` indica el número de claves.
- Pista 2: Dentro del script, `KEYS[1]` es la primera clave y `ARGV[1]` el primer argumento adicional.
- Pista 3: `redis.call('GET', KEYS[1])` devuelve el valor de la clave; `redis.call('INCRBY', KEYS[1], ARGV[1])` la incrementa.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
EVAL "return redis.call('GET', KEYS[1])" 1 balance
EVAL "return redis.call('INCRBY', KEYS[1], ARGV[1])" 1 balance 50
GET balance
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-06-lua-scripts-test.sh   # requiere podman (levanta redis efímero)
```