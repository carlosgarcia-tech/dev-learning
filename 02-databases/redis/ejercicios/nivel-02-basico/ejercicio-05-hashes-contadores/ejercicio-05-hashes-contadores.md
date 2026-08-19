# Ejercicio 05 — Hashes y contadores

- **Nivel:** 2/5
- **Tema:** `HINCRBY`, `HDEL`, `HEXISTS`, `HLEN`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
HSET estadisticas:web visitas 100
HSET estadisticas:web usuarios 25
```

Responde las siguientes consultas con `redis-cli`:

1. Incrementa el contador `visitas` de `estadisticas:web` en 50.
2. Comprueba el nuevo valor de `visitas`.
3. Elimina el campo `usuarios` de `estadisticas:web`.
4. Comprueba si `usuarios` sigue existiendo (devuelve 1 o 0).
5. Obtén el número de campos que quedan en `estadisticas:web`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-05-hashes-contadores-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `HINCRBY <clave> <campo> <incremento>` suma al valor numérico y devuelve el resultado.
- Pista 2: `HDEL <clave> <campo>` elimina el campo y devuelve `1` si existía.
- Pista 3: `HEXISTS` devuelve `1`/`0` y `HLEN` cuenta los campos restantes.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
HINCRBY estadisticas:web visitas 50
HGET estadisticas:web visitas
HDEL estadisticas:web usuarios
HEXISTS estadisticas:web usuarios
HLEN estadisticas:web
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-hashes-contadores-test.sh   # requiere podman (levanta redis efímero)
```
