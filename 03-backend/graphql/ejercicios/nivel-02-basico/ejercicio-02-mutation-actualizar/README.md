# Ejercicio 02 - Mutation para actualizar

- **Nivel:** 2/5
- **Tema:** Queries y Mutations
- **Tiempo estimado:** 20 minutos

## Enunciado

Define en `schema.graphql` una mutation `updateUser` que reciba un `id` y un **input type** `UpdateUserInput` con campos opcionales (`name`, `email`). El input debe permitir actualizaciones parciales (campos nullable). Devuelve el `User` actualizado.

## Requisitos

- [ ] Se define `input UpdateUserInput` con `name: String` y `email: String` (ambos nullable).
- [ ] `type Mutation` define `updateUser(id: ID!, input: UpdateUserInput!): User!`.
- [ ] La mutation en `query.graphql` actualiza el nombre.
- [ ] La mutation selecciona `id`, `name` y `updatedAt`.
- [ ] `expected.json` contiene la respuesta.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para updates parciales, los campos del input deben ser **nullable** (sin `!`).
- La mutation recibe dos argumentos: `id` e `input`.
- Buena práctica: devolver el objeto mutado para que el cliente actualice su caché.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
scalar DateTime

input UpdateUserInput {
  name: String
  email: String
}

type User {
  id: ID!
  name: String!
  email: String!
  updatedAt: DateTime
}

type Query {
  user(id: ID!): User
}

type Mutation {
  updateUser(id: ID!, input: UpdateUserInput!): User!
}
```

**query.graphql**

```graphql
mutation {
  updateUser(id: "1", input: { name: "Ana García" }) {
    id
    name
    updatedAt
  }
}
```

**expected.json**

```json
{
  "data": {
    "updateUser": {
      "id": "1",
      "name": "Ana García",
      "updatedAt": "2024-01-15T10:00:00Z"
    }
  }
}
```

</details>
