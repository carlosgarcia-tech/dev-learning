# Ejercicio 02 — Rate limiting

- **Nivel:** 5/5
- **Tema:** `DECR`, `EXPIRE`, contador de ventana fija
- **Tiempo estimado:** 20 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup):

```redis
SET limiter:user:7 4
EXPIRE limiter:user:7 60
```

Responde las siguientes consultas con `redis-cli`:

1. Decrementa el contador `limiter:user:7` cinco veces seguidas (una por cada petición entrante).
2. Obtén el valor final del contador.

Observa cómo el contador pasa de 4 a 3, 2, 1, 0 y finalmente -1: cuando llega a 0 se considera que el límite de peticiones se ha agotado.

## Requisitos

- [ ] Cada comando se ejecuta con `redis-cli` contra el servidor
- [ ] Los comandos devuelven el resultado esperado
- [ ] Los tests pasan: `bash ejercicio-02-rate-limiting-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- **Apuntes:** este es el patrón de **limitador de ventana fija** (fixed-window counter) usado en APIs para proteger el backend. Se guarda un contador por usuario/ventana; cada petición lo decrementa y, si queda por debajo de 0, se rechaza. El `EXPIRE` restablece la ventana automáticamente. Redis encaja por tres razones: `DECR` es atómico (no hay condiciones de carrera entre peticiones concurrentes), es O(1) y el `EXPIRE` evita tener que limpiar contadores viejos manualmente.
- Pista 1: `DECR <clave>` resta 1 al valor y devuelve el resultado.
- Pista 2: `EXPIRE <clave> <segundos>` fija el tiempo de vida de la clave.
- Pista 3: `GET <clave>` devuelve el valor final del contador.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````redis
DECR limiter:user:7
DECR limiter:user:7
DECR limiter:user:7
DECR limiter:user:7
DECR limiter:user:7
GET limiter:user:7
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-02-rate-limiting-test.sh   # requiere podman (levanta redis efímero)
```