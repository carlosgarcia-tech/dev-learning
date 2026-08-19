# Ejercicio 06 — Hashes: búsqueda e inspección

- **Nivel:** 2/5
- **Tema:** `HKEYS`, `HVALS`, `HGETALL`, `HSTRLEN`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
HSET producto:1 nombre mesa precio 120 stock 5
HSET producto:2 nombre silla precio 40 stock 12
```

Responde las siguientes consultas con `redis-cli`:

1. Muestra todos los campos de `producto:1`.
2. Muestra todos los valores de `producto:2`.
3. Muestra todos los campos y valores de `producto:1`.
4. Obtén la longitud (en bytes) del valor del campo `nombre` de `producto:1`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-06-hashes-busqueda-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `HKEYS <clave>` devuelve solo los campos; `HVALS <clave>` solo los valores.
- Pista 2: `HGETALL <clave>` devuelve campos y valores alternados.
- Pista 3: `HSTRLEN <clave> <campo>` devuelve la longitud en bytes del valor.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
HKEYS producto:1
HVALS producto:2
HGETALL producto:1
HSTRLEN producto:1 nombre
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-06-hashes-busqueda-test.sh   # requiere podman (levanta redis efímero)
```
