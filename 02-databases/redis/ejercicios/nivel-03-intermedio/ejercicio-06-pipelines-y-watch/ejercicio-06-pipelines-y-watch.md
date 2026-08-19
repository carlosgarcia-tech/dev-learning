# Ejercicio 06 — WATCH, MULTI y EXEC

- **Nivel:** 3/5
- **Tema:** `WATCH`, `UNWATCH`, `MULTI`, `EXEC`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET contador 0
SET lock libre
```

`WATCH` vigila una clave y aborta la transacción si esta es modificada por otro cliente antes del `EXEC`. `UNWATCH` cancela la vigilancia sin ejecutar nada.

Responde las siguientes consultas con `redis-cli`:

1. Vigila la clave `contador` con `WATCH`.
2. Lee el valor actual de `contador`.
3. Cancela la vigilancia con `UNWATCH`.
4. Inicia una transacción con `MULTI`.
5. Dentro de la transacción, incrementa `contador` en `1` con `INCR`.
6. Dentro de la transacción, vuelve a incrementar `contador` en `1` con `INCR`.
7. Ejecuta la transacción con `EXEC`.
8. Comprueba el valor final de `contador`.
9. Comprueba que existe la clave `lock` con `EXISTS`.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-06-pipelines-y-watch-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `WATCH <clave>` vigila una o más claves y responde `OK`.
- Pista 2: `UNWATCH` cancela toda la vigilancia y responde `OK`.
- Pista 3: `MULTI` inicia la transacción y los comandos encolados responden `QUEUED`.
- Pista 4: `EXEC` ejecuta la cola y devuelve los resultados en orden (aquí `1` y `2`).
- Pista 5: `GET contador` tras el `EXEC` devuelve `2`, y `EXISTS lock` devuelve `1`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
WATCH contador
GET contador
UNWATCH
MULTI
INCR contador
INCR contador
EXEC
GET contador
EXISTS lock
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-06-pipelines-y-watch-test.sh   # requiere podman (levanta redis efímero)
```