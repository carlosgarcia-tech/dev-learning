# Ejercicio 05 — MULTI y EXEC

- **Nivel:** 3/5
- **Tema:** `MULTI`, `QUEUED`, `EXEC`, `DISCARD`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET cuenta 100
```

Las transacciones en Redis se inician con `MULTI`, los comandos se encolan y responden `QUEUED`, y se ejecutan todos juntos con `EXEC`. Con `DISCARD` se descarta la cola sin ejecutar.

Responde las siguientes consultas con `redis-cli`:

1. Inicia una transacción con `MULTI`.
2. Dentro de la transacción, incrementa `cuenta` en `1` con `INCR`.
3. Dentro de la transacción, incrementa `cuenta` en `10` con `INCRBY`.
4. Ejecuta la transacción con `EXEC`.
5. Comprueba el valor final de `cuenta`.
6. Inicia una nueva transacción con `MULTI`.
7. Dentro de la transacción, decrementa `cuenta` con `DECR`.
8. Descarta la transacción con `DISCARD` (sin ejecutarla).
9. Comprueba que `cuenta` sigue sin cambios.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-05-multi-y-exec-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Pista 1: `MULTI` inicia la transacción y responde `OK`.
- Pista 2: Los comandos encolados responden `QUEUED` hasta que se llama a `EXEC`.
- Pista 3: `EXEC` ejecuta todos los comandos encolados y devuelve un array con cada resultado en orden.
- Pista 4: `DISCARD` vacía la cola de comandos sin ejecutar ninguno y responde `OK`.
- Pista 5: Tras el `EXEC` el valor de `cuenta` es `111` (100 + 1 + 10); tras el `DISCARD` sigue siendo `111`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
MULTI
INCR cuenta
INCRBY cuenta 10
EXEC
GET cuenta
MULTI
DECR cuenta
DISCARD
GET cuenta
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-05-multi-y-exec-test.sh   # requiere podman (levanta redis efímero)
```