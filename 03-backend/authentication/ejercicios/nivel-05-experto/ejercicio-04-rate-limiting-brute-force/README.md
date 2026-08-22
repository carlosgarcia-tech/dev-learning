# Ejercicio 04 — Rate limiting brute force

- **Nivel:** 5/5
- **Tema:** Protección contra brute force con rate limiting y backoff exponencial
- **Tiempo estimado:** 45 min

## Enunciado

Un ataque de brute force prueba todas las contraseñas posibles. La defensa principal es el rate limiting: limitar el número de intentos por IP y por cuenta, con backoff exponencial.

Tu tarea es implementar la lógica de rate limiting en `rate_limit.json` simulando 8 intentos de login consecutivos desde la misma IP.

Reglas:

1. Máximo 5 intentos por IP en 15 minutos.
2. Tras 5 fallos, se aplica backoff exponencial: el intento 6 espera 2s, el 7 espera 4s, el 8 espera 8s.
3. Tras el bloqueo, la IP no puede loguearse hasta que expire el bloqueo.

Pasos:

1. Completa `rate_limit.json` con el estado de cada intento.
2. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `rate_limit.json` es JSON válido
- [ ] `max_intentos_ip` es `5`
- [ ] `ventana_segundos` es `900` (15 min)
- [ ] `intentos` es un array con 8 elementos
- [ ] Intentos 1-5: `permitido: true`
- [ ] Intentos 6-8: `permitido: false`
- [ ] Intento 6: `backoff_segundos: 2`
- [ ] Intento 7: `backoff_segundos: 4`
- [ ] Intento 8: `backoff_segundos: 8`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los primeros 5 intentos se permiten (aunque fallen como login).
- A partir del intento 6, la IP está bloqueada.
- El backoff exponencial: `2^(n - max_intentos)` donde n es el número de intento.
  - Intento 6: 2^(6-5) = 2^1 = 2s
  - Intento 7: 2^(7-5) = 2^2 = 4s
  - Intento 8: 2^(8-5) = 2^3 = 8s
- El backoff crece exponencialmente para desincentivar la automatización.
- Combinar rate limiting por IP con CAPTCHA tras N fallos mejora la defensa.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`rate_limit.json`:

```json
{
  "ip": "192.168.1.100",
  "max_intentos_ip": 5,
  "ventana_segundos": 900,
  "intentos": [
    { "n": 1, "permitido": true, "backoff_segundos": 0 },
    { "n": 2, "permitido": true, "backoff_segundos": 0 },
    { "n": 3, "permitido": true, "backoff_segundos": 0 },
    { "n": 4, "permitido": true, "backoff_segundos": 0 },
    { "n": 5, "permitido": true, "backoff_segundos": 0 },
    { "n": 6, "permitido": false, "backoff_segundos": 2 },
    { "n": 7, "permitido": false, "backoff_segundos": 4 },
    { "n": 8, "permitido": false, "backoff_segundos": 8 }
  ]
}
```

Código equivalente:

```python
import redis
import time

r = redis.Redis(decode_responses=True)

def check_rate_limit(ip, max_attempts=5):
    key = f"login_attempts:{ip}"
    attempts = r.incr(key)
    if attempts == 1:
        r.expire(key, 900)
    
    if attempts > max_attempts:
        backoff = 2 ** (attempts - max_attempts)
        return {"permitido": False, "backoff_segundos": backoff}
    return {"permitido": True, "backoff_segundos": 0}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
