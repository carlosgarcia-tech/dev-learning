# Ejercicio 04 — POST con validación

- **Nivel:** 2/5
- **Tema:** Validación de entrada y error 422
- **Tiempo estimado:** 20 min

## Enunciado

Implementa la respuesta de `POST /products` cuando la petición es **inválida**. La petición envía:

```json
{ "name": "", "price": -5, "stock": "mucho" }
```

La respuesta debe:

- Devolver status **422 Unprocessable Entity**.
- `Content-Type: application/problem+json`.
- Un body de error RESTful con un array `errors` que liste **todos** los fallos de validación (no uno a uno): `name` (vacío/muy corto), `price` (negativo), `stock` (tipo incorrecto).

## Requisitos

- [ ] El status es **422**
- [ ] `Content-Type` es `application/problem+json`
- [ ] `body.errors` es un array con al menos 3 errores
- [ ] Cada error tiene `field`, `code` y `message`
- [ ] Se reportan los 3 campos fallidos (`name`, `price`, `stock`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- 422 = sintaxis JSON correcta pero semántica inválida (validación). 400 sería para JSON mal formado.
- Reporta **todos** los errores a la vez, no el primero.
- Códigos estables (`min_length`, `min_value`, `invalid_type`) para que el cliente pueda traducirlos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````json
{
  "status": 422,
  "headers": { "Content-Type": "application/problem+json" },
  "body": {
    "type": "https://docs.api.example/errors/validation",
    "title": "Validation Failed",
    "status": 422,
    "detail": "Uno o más campos son inválidos",
    "errors": [
      { "field": "name", "code": "min_length", "message": "name debe tener al menos 2 caracteres" },
      { "field": "price", "code": "min_value", "message": "price debe ser >= 0" },
      { "field": "stock", "code": "invalid_type", "message": "stock debe ser un entero" }
    ]
  }
}
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
