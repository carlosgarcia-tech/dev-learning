# Ejercicio 05 - Custom scalar

- **Nivel:** 3/5
- **Tema:** Schema y Tipos
- **Tiempo estimado:** 30 minutos

## Enunciado

Define un **custom scalar** `DateTime` en el schema y úsalo en el tipo `Post` para los campos `createdAt` y `updatedAt`. GraphQL no trae tipo fecha nativo, así que se declara como scalar.

## Requisitos

- [ ] Se declara `scalar DateTime` en el schema.
- [ ] `Post` tiene `createdAt: DateTime!` y `updatedAt: DateTime!`.
- [ ] `User` tiene `createdAt: DateTime!`.
- [ ] `type Query` define `post(id: ID!): Post`.
- [ ] La query pide `createdAt` y `updatedAt`.
- [ ] `expected.json` tiene fechas en formato ISO 8601.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un custom scalar se declara con `scalar Nombre`.
- En el servidor, el scalar necesita lógica de `serialize`/`parseValue`/`parseLiteral`.
- En el schema SDL solo se declara; la validación real se hace en código.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
scalar DateTime

type User {
  id: ID!
  name: String!
  createdAt: DateTime!
}

type Post {
  id: ID!
  title: String!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Query {
  post(id: ID!): Post
}
```

**query.graphql**

```graphql
query {
  post(id: "1") {
    id
    title
    createdAt
    updatedAt
  }
}
```

**expected.json**

```json
{
  "data": {
    "post": {
      "id": "1",
      "title": "Hola GraphQL",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-15T10:30:00Z"
    }
  }
}
```

</details>
