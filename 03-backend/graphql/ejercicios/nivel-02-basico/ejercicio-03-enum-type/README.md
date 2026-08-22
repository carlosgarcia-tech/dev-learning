# Ejercicio 03 - Enum type

- **Nivel:** 2/5
- **Tema:** Schema y Tipos
- **Tiempo estimado:** 20 minutos

## Enunciado

Define en `schema.graphql` un **enum** `PostStatus` con los valores `DRAFT`, `PUBLISHED` y `ARCHIVED`. Úsalo en el tipo `Post` y en una mutation `updatePostStatus` que cambie el estado de un post.

## Requisitos

- [ ] Se define `enum PostStatus` con `DRAFT`, `PUBLISHED`, `ARCHIVED`.
- [ ] `Post` tiene un campo `status: PostStatus!`.
- [ ] `type Mutation` define `updatePostStatus(id: ID!, status: PostStatus!): Post!`.
- [ ] La mutation en `query.graphql` cambia el estado a `PUBLISHED`.
- [ ] `expected.json` contiene la respuesta con el nuevo estado.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un enum se declara con `enum Nombre { VALOR1 VALOR2 }`.
- Los valores del enum no llevan comillas en GraphQL.
- El enum se usa como tipo normal: `status: PostStatus!`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
enum PostStatus {
  DRAFT
  PUBLISHED
  ARCHIVED
}

type Post {
  id: ID!
  title: String!
  status: PostStatus!
}

type Query {
  post(id: ID!): Post
}

type Mutation {
  updatePostStatus(id: ID!, status: PostStatus!): Post!
}
```

**query.graphql**

```graphql
mutation {
  updatePostStatus(id: "1", status: PUBLISHED) {
    id
    title
    status
  }
}
```

**expected.json**

```json
{
  "data": {
    "updatePostStatus": {
      "id": "1",
      "title": "Hola GraphQL",
      "status": "PUBLISHED"
    }
  }
}
```

</details>
