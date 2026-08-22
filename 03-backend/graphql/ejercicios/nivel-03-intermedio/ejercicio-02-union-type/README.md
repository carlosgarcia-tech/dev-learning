# Ejercicio 02 - Union type

- **Nivel:** 3/5
- **Tema:** Schema y Tipos
- **Tiempo estimado:** 30 minutos

## Enunciado

Define una **union** `SearchResult` que pueda ser `User`, `Post` o `Comment`. Define una query `search(term: String!): [SearchResult!]!`. Escribe una query que busque y use inline fragments para cada tipo posible.

## Requisitos

- [ ] Se define `union SearchResult = User | Post | Comment`.
- [ ] `type User`, `type Post`, `type Comment` están definidos.
- [ ] `type Query` define `search(term: String!): [SearchResult!]!`.
- [ ] La query en `query.graphql` pide `search(term: "ana")`.
- [ ] La query usa inline fragments para `User`, `Post` y `Comment`.
- [ ] `expected.json` tiene una respuesta de ejemplo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una union se declara así: `union Nombre = A | B | C`.
- A diferencia de la interface, los tipos de la union no comparten campos obligatorios.
- Por eso siempre necesitas inline fragments para acceder a sus campos.

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

type Post {
  id: ID!
  title: String!
  body: String!
}

type Comment {
  id: ID!
  text: String!
}

union SearchResult = User | Post | Comment

type Query {
  search(term: String!): [SearchResult!]!
}
```

**query.graphql**

```graphql
query {
  search(term: "ana") {
    ... on User {
      id
      name
    }
    ... on Post {
      id
      title
    }
    ... on Comment {
      id
      text
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "search": [
      { "id": "1", "name": "Ana" },
      { "id": "1", "title": "Hola Ana" },
      { "id": "5", "text": "Buen post Ana" }
    ]
  }
}
```

</details>
