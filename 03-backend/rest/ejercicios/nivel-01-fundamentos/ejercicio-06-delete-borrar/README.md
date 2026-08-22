# Ejercicio 06 — DELETE borrar

- **Nivel:** 1/5
- **Tema:** Borrado de recursos con DELETE
- **Tiempo estimado:** 10 min

## Enunciado

Implementa la respuesta de `DELETE /products/prod_001`. La respuesta debe:

- Devolver status **204 No Content** (éxito sin cuerpo) **o** **200 OK** con un body que indique el borrado.
- Si decides 204, no debe haber `body` (o ser `null`).

Además, en `respuesta_404.json` indica qué responder si el producto no existe.

## Requisitos

- [ ] El status es **204** (sin body) **o** **200** (con body de confirmación)
- [ ] Si es 204, `body` es `null` o está ausente
- [ ] `respuesta_404.json` usa status 404 y un body de error RESTful
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 204 = "no hay contenido que devolver"; ideal para DELETE silencioso.
- DELETE es **idempotente**: borrar algo ya borrado no da error 5xx (típicamente 404 o 204).
- El error 404 sigue RFC 7807 con `type`, `title`, `status`, `detail`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json` (opción 204):
````json
{ "status": 204, "headers": {}, "body": null }
````

`respuesta.json` (opción 200, alternativa):
````json
{ "status": 200, "headers": { "Content-Type": "application/json" },
  "body": { "id": "prod_001", "deleted": true, "deletedAt": "2024-01-15T12:00:00Z" } }
````

`respuesta_404.json`:
````json
{ "status": 404, "headers": { "Content-Type": "application/problem+json" },
  "body": { "type": "https://docs.api.example/errors/not-found", "title": "Not Found", "status": 404, "detail": "Producto prod_001 no existe" } }
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
