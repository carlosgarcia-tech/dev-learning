# Ejercicio 03 - Persisted queries

- **Nivel:** 5/5
- **Tema:** Producción y Seguridad
- **Tiempo estimado:** 40 minutos

## Enunciado

Configura **persisted queries** en el cliente y servidor. El cliente envía un hash SHA256 en vez de la query entera; el servidor solo ejecuta queries preaprobadas. Escribe la configuración del enlace del cliente y el plugin del servidor.

## Requisitos

- [ ] `client.js` usa `createPersistedQueryLink` antes del `HttpLink`.
- [ ] `client.js` configura `useGETForHashedQueries: true`.
- [ ] `server.js` configura ApolloServer con el plugin de cache control.
- [ ] `schema.graphql` define `Query { posts: [Post!]! }`.
- [ ] `query.graphql` define una query de posts.
- [ ] `expected.json` tiene la respuesta esperada.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las persisted queries envían un hash en vez de la query entera, reduciendo tamaño.
- Con `useGETForHashedQueries: true`, las queries van por GET y son cacheables por CDN.
- Si el servidor no conoce el hash, responde `PersistedQueryNotFound` y el cliente reenvía la query completa.

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
  posts: [Post!]!
}
```

**client.js**

```js
import { ApolloClient, InMemoryCache, HttpLink, from } from '@apollo/client';
import { createPersistedQueryLink } from '@apollo/client/link/persisted-queries';

const persistedLink = createPersistedQueryLink({
  useGETForHashedQueries: true,
});

const httpLink = new HttpLink({ uri: '/graphql' });

const client = new ApolloClient({
  link: from([persistedLink, httpLink]),
  cache: new InMemoryCache(),
});

module.exports = { client };
```

**server.js**

```js
const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');
const { ApolloServerPluginCacheControl } = require('@apollo/server/plugin/cacheControl');

const typeDefs = require('./schema.graphql');
const resolvers = require('./resolvers.js');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  plugins: [ApolloServerPluginCacheControl({ defaultMaxAge: 0 })],
});

async function start() {
  const { url } = await startStandaloneServer(server, {
    listen: { port: 4000 },
  });
  console.log(`🚀 Server con persisted queries en ${url}`);
}

start();
```

**query.graphql**

```graphql
query GetPosts {
  posts {
    id
    title
  }
}
```

**expected.json**

```json
{
  "data": {
    "posts": [
      { "id": "1", "title": "Hola GraphQL" },
      { "id": "2", "title": "Persisted queries" }
    ]
  }
}
```

</details>
