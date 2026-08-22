# Ejercicio 04 — Rate Limiting Simulado

- **Nivel:** 4/5
- **Tema:** Rate limiting y código 429
- **Tiempo estimado:** 30 min

## Enunciado

El servidor `server.sh` (puerto 8098) permite **3 peticiones por minuto** a `GET /api`. A partir de la 4ª, responde **429 Too Many Requests** con `Retry-After`.

Completa `respuesta.json` indicando el código de la 3ª petición (200) y el de la 4ª (429), y completa `peticiones.http` con una petición GET.

## Requisitos

- [ ] `peticiones.http` tiene `GET /api HTTP/1.1`
- [ ] `respuesta.json` es JSON válido
- [ ] `respuesta.json` tiene `dentro_limite: 200` y `fuera_limite: 429`
- [ ] `respuesta.json` menciona `Retry-After`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El rate limit cuenta peticiones por ventana de tiempo.
- Al exceder, el servidor responde 429 con `Retry-After` (segundos a esperar).
- Los headers `X-RateLimit-Limit`, `X-RateLimit-Remaining` informan el estado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`peticiones.http`:

```http
GET /api HTTP/1.1
Host: localhost:8098
```

`respuesta.json`:

```json
{
  "dentro_limite": 200,
  "fuera_limite": 429,
  "header_reintento": "Retry-After"
}
```

Comprobar:

```bash
for i in 1 2 3 4; do
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8098/api
done
# 200, 200, 200, 429
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
