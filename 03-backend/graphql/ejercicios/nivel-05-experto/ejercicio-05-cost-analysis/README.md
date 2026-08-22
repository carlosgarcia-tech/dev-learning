# Ejercicio 05 - Query cost analysis

- **Nivel:** 5/5
- **Tema:** Producción y Seguridad
- **Tiempo estimado:** 40 minutos

## Enunciado

Implementa **query cost analysis** en un servidor Apollo para limitar el coste computacional de queries complejas. Asigna un coste a los campos del schema mediante una directiva `@cost` y rechaza las queries que superen un máximo (`maximumCost`). Esto protege al servidor de queries que, sin ser profundas, piden listas enormes o relaciones muy caras.

## Requisitos

- [ ] `schema.graphql` define la directiva `@cost(complexity, multipliers, useMultipliers)` sobre `FIELD_DEFINITION`.
- [ ] `schema.graphql` asigna `@cost` a campos de listas (por ejemplo `posts`, `feed`, `comments`) usando `multipliers`.
- [ ] `server.js` configura una regla `costAnalysis` en `validationRules`.
- [ ] `server.js` define `maximumCost: 1000` (constante `MAX_COST`).
- [ ] `server.js` crea un error `GraphQLError` cuando el coste supera el máximo.
- [ ] `query.graphql` contiene una query válida y barata (por debajo del máximo).
- [ ] `expensive-query.graphql` contiene una query cara que superaría el máximo.
- [ ] `expected.json` tiene la respuesta de la query válida.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El paquete `graphql-cost-analysis` exporta una regla que se pasa a `validationRules`.
- `multipliers` permite multiplicar la complejidad por un argumento (por ejemplo `limit`), así una query `feed(limit: 1000)` cuesta `complexity * 1000`.
- `validationRules` puede ser una función que recibe `{ variables, document, operationName }` para que la regla conozca las variables de la petición.
- El coste total es la suma del coste de cada campo seleccionado, ponderada por los multiplicadores.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
directive @cost(
  complexity: Int
  multipliers: [String!]
  useMultipliers: Boolean
) on FIELD_DEFINITION

type User {
  id: ID!
  name: String!
  posts(limit: Int! = 10): [Post!]! @cost(complexity: 2, multipliers: ["limit"], useMultipliers: true)
}

type Post {
  id: ID!
  title: String!
  author: User! @cost(complexity: 2)
  comments(limit: Int! = 10): [Comment!]! @cost(complexity: 3, multipliers: ["limit"], useMultipliers: true)
}

type Comment {
  id: ID!
  body: String!
  author: User! @cost(complexity: 2)
}

type Query {
  user(id: ID!): User @cost(complexity: 1)
  users(limit: Int! = 10): [User!]! @cost(complexity: 1, multipliers: ["limit"], useMultipliers: true)
  feed(limit: Int! = 20): [Post!]! @cost(complexity: 2, multipliers: ["limit"], useMultipliers: true)
}
```

**server.js**

```js
const express = require('express');
const cors = require('cors');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const { GraphQLError } = require('graphql');
const { readFileSync } = require('fs');
const costAnalysis = require('graphql-cost-analysis').default;

const typeDefs = readFileSync(require.resolve('./schema.graphql'), 'utf-8');

const users = [
  { id: '1', name: 'Ana' },
  { id: '2', name: 'Luis' },
];
const posts = [
  { id: '101', title: 'Hola mundo', authorId: '1' },
  { id: '102', title: 'Cost analysis', authorId: '1' },
];
const comments = [
  { id: '201', body: 'Genial!', authorId: '2', postId: '101' },
];

const resolvers = {
  Query: {
    user: (_p, { id }) => users.find((u) => u.id === id) || null,
    users: (_p, { limit }) => users.slice(0, limit),
    feed: (_p, { limit }) => posts.slice(0, limit),
  },
  User: {
    posts: (user, { limit }) => posts.filter((p) => p.authorId === user.id).slice(0, limit),
  },
  Post: {
    author: (post) => users.find((u) => u.id === post.authorId),
    comments: (post, { limit }) => comments.filter((c) => c.postId === post.id).slice(0, limit),
  },
  Comment: {
    author: (comment) => users.find((u) => u.id === comment.authorId),
  },
};

const MAX_COST = 1000;

function createCostRule(variables = {}) {
  return costAnalysis({
    maximumCost: MAX_COST,
    defaultCost: 1,
    variables,
    createError: (maxCost, cost) =>
      new GraphQLError(`Query rechazada: coste ${cost} supera el máximo ${maxCost}`),
  });
}

const app = express();
app.use(cors());
app.use(express.json());

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: ({ variables }) => [createCostRule(variables)],
});

async function start() {
  await server.start();
  app.use('/graphql', expressMiddleware(server));
  app.listen(4000, () => console.log('🚀 Server en http://localhost:4000/graphql'));
}

start();
```

**query.graphql**

```graphql
query {
  user(id: "1") {
    name
    posts(limit: 5) {
      title
    }
  }
}
```

**expensive-query.graphql**

```graphql
# Query cara: pide listas enormes anidadas. Supera el coste máximo.
query {
  feed(limit: 100) {
    title
    author {
      name
      posts(limit: 100) {
        title
        comments(limit: 100) {
          body
          author {
            name
          }
        }
      }
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "user": {
      "name": "Ana",
      "posts": [
        { "title": "Hola mundo" },
        { "title": "Cost analysis" }
      ]
    }
  }
}
```

</details>
