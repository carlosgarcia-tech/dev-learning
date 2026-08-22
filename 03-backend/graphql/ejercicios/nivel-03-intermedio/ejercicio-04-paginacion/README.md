# Ejercicio 04 - Paginación (Relay)

- **Nivel:** 3/5
- **Tema:** Queries y Mutations
- **Tiempo estimado:** 35 minutos

## Enunciado

Implementa el patrón de paginación **Relay** (cursor-based) para los posts. Define los tipos `PostConnection`, `PostEdge` y `PageInfo`, y una query `posts(first: Int, after: String): PostConnection!`.

## Requisitos

- [ ] Se define `type PostConnection` con `edges: [PostEdge!]!` y `pageInfo: PageInfo!`.
- [ ] Se define `type PostEdge` con `cursor: String!` y `node: Post!`.
- [ ] Se define `type PageInfo` con `hasNextPage`, `hasPreviousPage`, `startCursor`, `endCursor`.
- [ ] `type Query` define `posts(first: Int, after: String): PostConnection!`.
- [ ] La query pide `posts(first: 2)` con `edges { cursor node { id title } }` y `pageInfo`.
- [ ] `expected.json` tiene una respuesta con edges y pageInfo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Relay pagination usa `edges` (lista de nodos con cursor) y `pageInfo` (metadatos de paginación).
- `first: N` pide los primeros N elementos desde un cursor (`after`).
- Cada edge tiene un `cursor` (string opaco) y un `node` (el dato).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type Post {
  id: ID!
  title: String!
}

type PostEdge {
  cursor: String!
  node: Post!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type PostConnection {
  edges: [PostEdge!]!
  pageInfo: PageInfo!
}

type Query {
  posts(first: Int, after: String): PostConnection!
}
```

**query.graphql**

```graphql
query {
  posts(first: 2) {
    edges {
      cursor
      node {
        id
        title
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "posts": {
      "edges": [
        { "cursor": "cursor1", "node": { "id": "1", "title": "Post 1" } },
        { "cursor": "cursor2", "node": { "id": "2", "title": "Post 2" } }
      ],
      "pageInfo": {
        "hasNextPage": true,
        "endCursor": "cursor2"
      }
    }
  }
}
```

</details>
