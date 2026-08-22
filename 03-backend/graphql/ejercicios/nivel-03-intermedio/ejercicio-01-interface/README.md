# Ejercicio 01 - Interface

- **Nivel:** 3/5
- **Tema:** Schema y Tipos
- **Tiempo estimado:** 30 minutos

## Enunciado

Define una **interface** `Node` con un campo `id: ID!`. Haz que `User` y `Post` implementen `Node`. Define una query `node(id: ID!): Node` que devuelva cualquier entidad. Escribe una query que use **inline fragments** para pedir campos específicos de cada tipo.

## Requisitos

- [ ] Se define `interface Node { id: ID! }`.
- [ ] `User implements Node` con `id`, `name`, `email`.
- [ ] `Post implements Node` con `id`, `title`, `body`.
- [ ] `type Query` define `node(id: ID!): Node`.
- [ ] La query en `query.graphql` pide `id` (común) y usa inline fragments para `name` y `title`.
- [ ] `expected.json` tiene una respuesta de ejemplo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una interface se define con `interface Nombre { campos }`.
- Un type implementa con `type X implements Interface { ... }` e incluye los campos de la interface.
- Para consultar campos específicos se usan inline fragments: `... on User { name }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
interface Node {
  id: ID!
}

type User implements Node {
  id: ID!
  name: String!
  email: String
}

type Post implements Node {
  id: ID!
  title: String!
  body: String!
}

type Query {
  node(id: ID!): Node
}
```

**query.graphql**

```graphql
query {
  node(id: "1") {
    id
    ... on User {
      name
      email
    }
    ... on Post {
      title
      body
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "node": {
      "id": "1",
      "name": "Ana",
      "email": "ana@x.com"
    }
  }
}
```

</details>
