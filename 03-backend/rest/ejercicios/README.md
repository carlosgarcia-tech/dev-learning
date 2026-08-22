# Ejercicios — REST

Cada ejercicio tiene enunciado, requisitos, pistas y solución al final (plegable). Los tests validan JSON y estructura de respuestas con `python3`.

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | Diseñar URL RESTful, GET lista, GET por id, POST crear, PUT actualizar, DELETE borrar | ⬜ |
| [nivel-02-basico](nivel-02-basico/) | Paginación limit/offset, filtrado, orden, POST con validación, errores 404/400, relaciones | ⬜ |
| [nivel-03-intermedio](nivel-03-intermedio/) | PATCH vs PUT, HATEOAS, versionado, soft delete, PATCH con validación, sub-recursos anidados | ⬜ |
| [nivel-04-avanzado](nivel-04-avanzado/) | Rate limiting, Bearer token, paginación cursor, field selection, idempotency key, bulk operations | ⬜ |
| [nivel-05-experto](nivel-05-experto/) | API con OpenAPI, webhooks, async 202, API gateway, migración de versión, microservicios | ⬜ |
| [proyectos](proyectos/) | API REST completa de e-commerce | ⬜ |

## Cómo usar los ejercicios

1. Entra a la carpeta del ejercicio.
2. Lee el `README.md` con el enunciado y requisitos.
3. Examina `peticion.json` (la petición de ejemplo) y `respuesta.json` (la respuesta esperada).
4. Ejecuta `bash test.sh` para validar.

```bash
cd 03-backend/rest/ejercicios/nivel-01-fundamentos/ejercicio-01-disenar-url-restful
bash test.sh
```

> Cada `test.sh` valida con `python3` que los JSON sean válidos, que la estructura cumpla el contrato REST y que los códigos de estado sean correctos. No requiere servidor en marcha.
