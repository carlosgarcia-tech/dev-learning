# Ejercicio 02 - DataLoader y N+1

- **Nivel:** 4/5
- **Tema:** Resolvers y DataSources
- **Tiempo estimado:** 40 minutos

## Enunciado

El N+1 problem ocurre cuando resolver una lista de usuarios dispara una query por cada uno para obtener sus posts. Implementa un **DataLoader** que batchee las consultas: en vez de N queries, una sola.

Escribe en `resolvers.js` el código que crea un DataLoader en el context y úsalo en el resolver `User.posts`.

## Requisitos

- [ ] `schema.graphql` define `User` con `posts: [Post!]!` y `Post` con `author: User!`.
- [ ] `Query.users: [User!]!` devuelve una lista de usuarios.
- [ ] `resolvers.js` define un DataLoader `postLoader` que batchea por `authorId`.
- [ ] El resolver `User.posts` usa `context.loaders.postLoader.load(user.id)`.
- [ ] Los loaders se crean en el context (no globales).
- [ ] El DataLoader usa `async` y agrupa los ids con `Promise.all`.
- [ ] `query.graphql` pide `users { id posts { title } }`.
- [ ] `expected.json` tiene una respuesta con usuarios y posts.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- DataLoader agrupa las llamadas `load(id)` del mismo tick en un solo batch.
- El batch function recibe un array de ids y devuelve un array de resultados en el mismo orden.
- Los loaders se crean por petición en el context para evitar caché cruzada entre usuarios.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  name: String!
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  authorId: ID!
}

type Query {
  users: [User!]!
}
```

**resolvers.js**

```js
const DataLoader = require('dataloader');

function createLoaders(db) {
  const postLoader = new DataLoader(async (userIds) => {
    // UNA sola consulta para todos los userIds
    const posts = await db.posts.findMany({
      where: { authorId: { in: [...userIds] } },
    });
    // Repartir en el mismo orden que userIds
    return userIds.map((id) => posts.filter((p) => p.authorId === id));
  });

  return { postLoader };
}

const resolvers = {
  Query: {
    users: async (parent, args, context) => {
      return context.db.users.findAll();
    },
  },
  User: {
    posts: (user, args, context) => {
      return context.loaders.postLoader.load(user.id);
    },
  },
};

module.exports = { resolvers, createLoaders };
```

**query.graphql**

```graphql
query {
  users {
    id
    name
    posts {
      id
      title
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "users": [
      {
        "id": "1",
        "name": "Ana",
        "posts": [
          { "id": "1", "title": "Hola" }
        ]
      },
      {
        "id": "2",
        "name": "Luis",
        "posts": [
          { "id": "2", "title": "Mundo" }
        ]
      }
    ]
  }
}
```

</details>
