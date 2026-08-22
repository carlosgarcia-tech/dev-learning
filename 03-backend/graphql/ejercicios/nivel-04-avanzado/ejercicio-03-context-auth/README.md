# Ejercicio 03 - Context y autenticación

- **Nivel:** 4/5
- **Tema:** Resolvers y DataSources
- **Tiempo estimado:** 35 minutos

## Enunciado

Implementa autenticación JWT en GraphQL. El cliente envía el token en el header `Authorization`, el servidor lo valida en el `context` y expone `context.user`. Si no hay token o es inválido, `context.user` es `null`.

Escribe en `context.js` la función que crea el context extrayendo el usuario del JWT, y en `resolvers.js` una mutation `deletePost` que lance un error `UNAUTHENTICATED` si no hay usuario.

## Requisitos

- [ ] `schema.graphql` define `type Mutation { deletePost(id: ID!): Boolean! }`.
- [ ] `context.js` exporta una función que recibe `{ req }` y devuelve `{ user }`.
- [ ] El context extrae el token del header `Authorization` (formato `Bearer <token>`).
- [ ] El context valida el JWT y expone `context.user` (o `null` si no hay token).
- [ ] `resolvers.js` define `Mutation.deletePost` que lanza `GraphQLError` con code `UNAUTHENTICATED` si `context.user` es null.
- [ ] `resolvers.js` lanza `FORBIDDEN` si el usuario no es admin.
- [ ] `query.graphql` define la mutation `deletePost`.
- [ ] `expected.json` tiene un ejemplo de error de autenticación.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El context se construye una vez por petición: `context: async ({ req }) => ({ user: ... })`.
- El JWT va en `req.headers.authorization` con formato `Bearer <token>`.
- Lanza `GraphQLError` con `extensions: { code: 'UNAUTHENTICATED' }` para errores de auth.

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

type Query {
  post(id: ID!): Post
}

type Mutation {
  deletePost(id: ID!): Boolean!
}
```

**context.js**

```js
const jwt = require('jsonwebtoken');

const SECRET = process.env.JWT_SECRET || 'dev-secret';

function getUserFromToken(token) {
  try {
    if (!token) return null;
    const clean = token.replace('Bearer ', '');
    return jwt.verify(clean, SECRET);
  } catch {
    return null;
  }
}

const context = async ({ req }) => {
  const authHeader = req.headers.authorization || '';
  const user = getUserFromToken(authHeader);
  return { user };
};

module.exports = { context, getUserFromToken };
```

**resolvers.js**

```js
const { GraphQLError } = require('graphql');

const resolvers = {
  Mutation: {
    deletePost: async (parent, args, context) => {
      if (!context.user) {
        throw new GraphQLError('Debes iniciar sesión', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      if (!context.user.isAdmin) {
        throw new GraphQLError('No autorizado para borrar posts', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      await context.db.posts.delete({ id: args.id });
      return true;
    },
  },
};

module.exports = { resolvers };
```

**query.graphql**

```graphql
mutation {
  deletePost(id: "1")
}
```

**expected.json**

```json
{
  "data": null,
  "errors": [
    {
      "message": "Debes iniciar sesión",
      "extensions": { "code": "UNAUTHENTICATED" }
    }
  ]
}
```

</details>
