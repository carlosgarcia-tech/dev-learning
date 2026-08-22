# Ejercicio 01 — Diseño de API completa con OpenAPI

- **Nivel:** 5/5
- **Tema:** Especificación OpenAPI/Swagger
- **Tiempo estimado:** 45 min

## Enunciado

Escribe la especificación OpenAPI 3.0 completa para el recurso `/products` de una API de e-commerce en `openapi.yaml`. La spec debe cubrir:

1. `GET /products` — listar con query params `limit`, `offset` y respuesta 200.
2. `POST /products` — crear con request body y respuestas 201, 422.
3. `GET /products/{id}` — obtener uno con respuestas 200, 404.
4. `DELETE /products/{id}` — borrar con respuesta 204.
5. Componentes: schemas `Product`, `ProductCreate`, `ProductList`, `Error`.

## Requisitos

- [ ] El archivo `openapi.yaml` existe y es YAML/JSON válido
- [ ] Declara `openapi: 3.0.3` (o 3.1.x)
- [ ] Tiene los 4 endpoints (`/products` GET/POST, `/products/{id}` GET/DELETE)
- [ ] Define los schemas `Product`, `ProductCreate`, `Error` en `components/schemas`
- [ ] `GET /products/{id}` declara 200 y 404
- [ ] `POST /products` declara 201 y 422
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Empieza por `openapi`, `info` (title, version) y `servers`.
- En `paths` defines cada endpoint con `get`/`post`/`delete` y sus `parameters`, `requestBody`, `responses`.
- Reutiliza schemas con `$ref: '#/components/schemas/...'`.
- Valida el YAML con `python3 -c "import yaml; yaml.safe_load(open('openapi.yaml'))"` (requiere PyYAML) o usa `json` si lo escribes en JSON.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Ver `openapi.yaml` en esta misma carpeta (archivo starter completo).

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
