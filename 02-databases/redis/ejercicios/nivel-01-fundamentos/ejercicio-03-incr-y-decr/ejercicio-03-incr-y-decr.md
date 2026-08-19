# Ejercicio 03 — INCR y DECR

- **Nivel:** 1/5
- **Tema:** `INCR`, `DECR`, `INCRBY`, `DECRBY`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET visitas 10
SET puntos 5
```

Responde las siguientes consultas con `redis-cli`:

1. Incrementa `visitas` en 1 con `INCR` (devuelve el nuevo valor).
2. Incrementa `visitas` de nuevo en 1.
3. Decrementa `visitas` en 1 con `DECR`.
4. Incrementa `visitas` en 5 con `INCRBY`.
5. Decrementa `puntos` en 2 con `DECRBY`.
6. Verifica el valor final de `puntos`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-03-incr-y-decr-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `INCR <clave>` incrementa el valor numérico en 1 y devuelve el resultado.
- Pista 2: `INCRBY <clave> <n>` permite sumar una cantidad concreta.
- Pista 3: `DECR <clave>` y `DECRBY <clave> <n>` funcionan igual pero restando.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
INCR visitas
INCR visitas
DECR visitas
INCRBY visitas 5
DECRBY puntos 2
GET puntos
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-incr-y-decr-test.sh   # requiere podman (levanta redis efímero)
```