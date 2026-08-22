# Ejercicio 04 - Input type con campos anidados

- **Nivel:** 2/5
- **Tema:** Queries y Mutations
- **Tiempo estimado:** 25 minutos

## Enunciado

Define un **input type** `CreatePostInput` que incluya un campo anidado `metadata` de tipo `PostMetadataInput` (con `tags` y `category`). Crea la mutation `createPost` que lo use.

## Requisitos

- [ ] Se define `input CreatePostInput` con `title`, `body` y `metadata: PostMetadataInput`.
- [ ] Se define `input PostMetadataInput` con `tags: [String!]!` y `category: String`.
- [ ] `type Mutation` define `createPost(input: CreatePostInput!): Post!`.
- [ ] La mutation en `query.graphql` pasa el input con metadata anidada.
- [ ] `expected.json` contiene la respuesta.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los input types pueden anidarse: un input puede tener campos de otro input.
- Los input types no pueden referenciar object types (`type`), solo otros `input`, escalares y enums.
- El campo `tags` es una lista: `tags: [String!]!`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
input PostMetadataInput {
  tags: [String!]!
  category: String
}

input CreatePostInput {
  title: String!
  body: String!
  metadata: PostMetadataInput
}

type Post {
  id: ID!
  title: String!
  body: String!
  tags: [String!]!
  category: String
}

type Query {
  post(id: ID!): Post
}

type Mutation {
  createPost(input: CreatePostInput!): Post!
}
```

**query.graphql**

```graphql
mutation {
  createPost(input: {
    title: "Intro a GraphQL"
    body: "GraphQL es un lenguaje de consultas..."
    metadata: {
      tags: ["graphql", "backend"]
      category: "tech"
    }
  }) {
    id
    title
    tags
    category
  }
}
```

**expected.json**

```json
{
  "data": {
    "createPost": {
      "id": "1",
      "title": "Intro a GraphQL",
      "tags": ["graphql", "backend"],
      "category": "tech"
    }
  }
}
```

</details>
