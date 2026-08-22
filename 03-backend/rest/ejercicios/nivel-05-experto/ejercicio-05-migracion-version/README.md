# Ejercicio 05 — Migración de versión de API

- **Nivel:** 5/5
- **Tema:** Deprecación, sunset y migración `/v1` → `/v2`
- **Tiempo estimado:** 30 min

## Enunciado

La API de productos migra de v1 a v2. En v2, el campo `price` se renombra a `unitPrice` y se añade `currency`. Implementa:

1. `respuesta_v1_deprecada.json`: respuesta de `GET /v1/products/prod_001` con la cabecera `Deprecation` y `Sunset` (fecha de apagado de v1).
2. `respuesta_v2.json`: respuesta de `GET /v2/products/prod_001` con los campos nuevos.
3. `respuesta_link.json`: cabecera `Link` con `rel="successor-version"` apuntando a la v2 (para guiar la migración).

## Requisitos

- [ ] `respuesta_v1_deprecada.json`: status 200, `headers.Deprecation` presente, `headers.Sunset` con fecha
- [ ] `respuesta_v1_deprecada.json` body usa `price` (no `unitPrice`)
- [ ] `respuesta_v2.json`: status 200, body con `unitPrice` y `currency`
- [ ] `respuesta_v1_deprecada.json` incluye `headers.Link` con `successor-version`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cabeceras de deprecación estándar: `Deprecation: true` (o fecha), `Sunset: <fecha>`, `Link: <url>; rel="deprecation"` o `rel="successor-version"`.
- v1 sigue funcionando (con avisos) hasta la fecha de sunset.
- Comunicación: changelog, email a integradores, banner en docs, métricas de uso de v1.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta_v1_deprecada.json`:
````json
{
  "status": 200,
  "headers": {
    "Content-Type": "application/json",
    "Deprecation": "true",
    "Sunset": "Wed, 31 Dec 2025 23:59:59 GMT",
    "Link": "</v2/products/prod_001>; rel=\"successor-version\""
  },
  "body": { "id": "prod_001", "name": "Teclado mecánico", "price": 89.90 }
}
````

`respuesta_v2.json`:
````json
{
  "status": 200,
  "headers": { "Content-Type": "application/json" },
  "body": { "id": "prod_001", "name": "Teclado mecánico", "unitPrice": 89.90, "currency": "EUR" }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
