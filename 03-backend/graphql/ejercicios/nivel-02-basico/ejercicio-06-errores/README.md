# Ejercicio 06 - Errores en GraphQL

- **Nivel:** 2/5
- **Tema:** Queries y Mutations
- **Tiempo estimado:** 25 minutos

## Enunciado

GraphQL no usa status codes HTTP para errores de negocio: siempre devuelve HTTP 200 con un array `errors`. Crea en `expected.json` una respuesta de error que represente un usuario no encontrado, con `data: null`, un array `errors` con `message`, `path` y `extensions.code`.

Además, define en `schema.graphql` un campo `user(id: ID!): User` nullable (para que pueda devolver null) y escribe en `query.graphql` una query que pida un usuario inexistente.

## Requisitos

- [ ] `expected.json` tiene `"data": null`.
- [ ] `expected.json` tiene un array `errors` con al menos un error.
- [ ] El error tiene `message`.
- [ ] El error tiene `path` (array).
- [ ] El error tiene `extensions` con `code` (por ejemplo `NOT_FOUND`).
- [ ] `schema.graphql` define `user(id: ID!): User` (nullable, sin `!`).
- [ ] `query.graphql` pide un usuario.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un campo nullable (`User` sin `!`) permite que el resolver devuelva `null` sin propagar el error a toda la query.
- El array `errors` tiene objetos con `message`, `path`, `locations` y `extensions`.
- `extensions.code` es la convención para códigos estables: `NOT_FOUND`, `UNAUTHENTICATED`, etc.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  name: String!
  email: String
}

type Query {
  user(id: ID!): User
}
```

**query.graphql**

```graphql
query {
  user(id: "999") {
    id
    name
  }
}
```

**expected.json**

```json
{
  "data": null,
  "errors": [
    {
      "message": "User not found",
      "path": ["user"],
      "extensions": { "code": "NOT_FOUND" }
    }
  ]
}
```

</details>
