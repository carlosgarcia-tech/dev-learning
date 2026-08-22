# Ejercicio 01 - Mutation para crear

- **Nivel:** 2/5
- **Tema:** Queries y Mutations
- **Tiempo estimado:** 20 minutos

## Enunciado

Define en `schema.graphql` una mutation `createUser` que reciba un **input type** `CreateUserInput` con `name` y `email`, y devuelva el `User` creado. Luego escribe en `query.graphql` la mutation correspondiente seleccionando `id`, `name` y `email`.

## Requisitos

- [ ] Se define `input CreateUserInput` con `name: String!` y `email: String!`.
- [ ] `type Mutation` define `createUser(input: CreateUserInput!): User!`.
- [ ] La mutation en `query.graphql` pasa un input con `name` y `email`.
- [ ] La mutation selecciona `id`, `name` y `email` del resultado.
- [ ] `expected.json` contiene la respuesta esperada con un `id`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los input types se definen con la palabra `input`, no `type`.
- Una mutation se declara con `mutation { ... }`.
- El input se pasa como objeto literal: `input: { name: "Ana", email: "ana@x.com" }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
input CreateUserInput {
  name: String!
  email: String!
}

type User {
  id: ID!
  name: String!
  email: String!
}

type Query {
  user(id: ID!): User
}

type Mutation {
  createUser(input: CreateUserInput!): User!
}
```

**query.graphql**

```graphql
mutation {
  createUser(input: { name: "Ana", email: "ana@x.com" }) {
    id
    name
    email
  }
}
```

**expected.json**

```json
{
  "data": {
    "createUser": {
      "id": "1",
      "name": "Ana",
      "email": "ana@x.com"
    }
  }
}
```

</details>
