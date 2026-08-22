# 05 — Producción y Seguridad

> Apollo Server, Apollo Client, subscriptions, autenticación JWT, autorización por campo, rate limiting, query complexity, persisted queries, federation, monitoreo y testing de schema.

## Objetivos

- [ ] Levantar un Apollo Server y conectar un Apollo Client.
- [ ] Implementar subscriptions sobre WebSocket.
- [ ] Autenticar con JWT vía context.
- [ ] Autorizar por campo con directives y guards.
- [ ] Aplicar rate limiting y query complexity (depth limiting, cost analysis).
- [ ] Usar persisted queries para reducir tráfico y mejorar caché.
- [ ] Entender federation y schema stitching.
- [ ] Resolver N+1 con DataLoader en producción.
- [ ] Monitorear con Apollo Studio / metrics.
- [ ] Testear el schema y migrar versiones.
- [ ] Configurar cache con persisted queries.

## 1. Apollo Server

Apollo Server es la implementación de servidor GraphQL más usada en Node.js. Expone el endpoint `/graphql` y ejecuta el schema.

```js
const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');

const typeDefs = `#graphql
  type Query { hello: String! }
`;

const resolvers = {
  Query: { hello: () => '¡Hola GraphQL!' },
};

const server = new ApolloServer({ typeDefs, resolvers });

const { url } = await startStandaloneServer(server, {
  listen: { port: 4000 },
  context: async ({ req }) => ({ user: getUserFromReq(req) }),
});

console.log(`🚀 Server en ${url}`);
```

### Integración con Express/Fastify

Para producción se integra con un framework web para tener middleware (CORS, rate limiting, logs):

```js
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const server = new ApolloServer({ typeDefs, resolvers });
await server.start();

app.use('/graphql', expressMiddleware(server, {
  context: async ({ req }) => ({ user: getUserFromReq(req) }),
}));

app.listen(4000);
```

## 2. Apollo Client

Apollo Client es el cliente GraphQL para frontend (React, Vue, vanilla). Maneja caché, queries reactivas, mutations y subscriptions.

```js
import { ApolloClient, InMemoryCache, gql } from '@apollo/client';

const client = new ApolloClient({
  uri: 'https://api.example.com/graphql',
  cache: new InMemoryCache(),
});

// Query
const { data } = await client.query({
  query: gql`
    query GetUser($id: ID!) {
      user(id: $id) { id name }
    }
  `,
  variables: { id: '1' },
});

// Mutation
await client.mutate({
  mutation: gql`
    mutation CreateUser($input: CreateUserInput!) {
      createUser(input: $input) { id name }
    }
  `,
  variables: { input: { name: 'Ana', email: 'ana@x.com' } },
});
```

### En React

```jsx
import { useQuery, useMutation, gql } from '@apollo/client';

const GET_USER = gql`
  query GetUser($id: ID!) {
    user(id: $id) { id name posts { title } }
  }
`;

function User({ id }) {
  const { loading, error, data } = useQuery(GET_USER, { variables: { id } });
  if (loading) return <p>Cargando…</p>;
  if (error) return <p>Error: {error.message}</p>;
  return <div>{data.user.name}</div>;
}
```

El cache de Apollo Client normaliza por `__typename` + `id`, así que actualizar un usuario propaga el cambio a todas las queries que lo usan.

## 3. Subscriptions (WebSocket)

Las subscriptions permiten recibir datos en tiempo real. Se usan sobre WebSocket (generalmente el protocolo `graphql-ws`).

### Schema

```graphql
type Subscription {
  postAdded: Post!
  commentAdded(postId: ID!): Comment!
}
```

### Servidor con `graphql-ws`

```js
const { makeExecutableSchema } = require('@graphql-tools/schema');
const { WebSocketServer } = require('ws');
const { useServer } = require('graphql-ws/lib/use/ws');
const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');

const schema = makeExecutableSchema({ typeDefs, resolvers });

// HTTP para queries/mutations
const httpServer = new ApolloServer({ schema });
await startStandaloneServer(httpServer, { listen: { port: 4000 } });

// WebSocket para subscriptions
const wsServer = new WebSocketServer({ port: 4001, path: '/graphql' });
useServer({ schema }, wsServer);
```

### Resolver de subscription

Un resolver de subscription tiene `subscribe` (devuelve un AsyncIterator) y opcionalmente `resolve`:

```js
const { PubSub } = require('graphql-subscriptions');
const pubsub = new PubSub();

const resolvers = {
  Subscription: {
    postAdded: {
      subscribe: () => pubsub.asyncIterator(['POST_ADDED']),
    },
  },
  Mutation: {
    createPost: async (parent, args, context) => {
      const post = await context.prisma.post.create({ data: args.input });
      pubsub.publish('POST_ADDED', { postAdded: post });
      return post;
    },
  },
};
```

### Cliente (Apollo)

```js
import { GraphQLWsLink } from '@apollo/client/link/subscriptions';
import { createClient as createWsClient } from 'graphql-ws';

const wsLink = new GraphQLWsLink(createWsClient({
  url: 'ws://localhost:4001/graphql',
}));

const client = new ApolloClient({
  link: split(
    ({ query }) => {
      const def = getMainDefinition(query);
      return def.kind === 'OperationDefinition' && def.operation === 'subscription';
    },
    wsLink,
    httpLink
  ),
  cache: new InMemoryCache(),
});
```

## 4. Autenticación con JWT

El patrón estándar: el cliente envía el JWT en el header `Authorization`, el servidor lo valida en el `context` y expone `context.user`.

### Servidor

```js
const jwt = require('jsonwebtoken');

const SECRET = process.env.JWT_SECRET;

const getUser = (token) => {
  try {
    if (token) return jwt.verify(token.replace('Bearer ', ''), SECRET);
    return null;
  } catch {
    return null;
  }
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

const { url } = await startStandaloneServer(server, {
  context: async ({ req }) => {
    const user = getUser(req.headers.authorization);
    return { user };
  },
});
```

### Mutation de login

```graphql
type Mutation {
  login(email: String!, password: String!): AuthPayload!
}

type AuthPayload {
  token: String!
  user: User!
}
```

```js
const resolvers = {
  Mutation: {
    login: async (parent, { email, password }, context) => {
      const user = await context.prisma.user.findUnique({ where: { email } });
      if (!user) throw new GraphQLError('Credenciales inválidas', {
        extensions: { code: 'UNAUTHENTICATED' },
      });
      const valid = await bcrypt.compare(password, user.passwordHash);
      if (!valid) throw new GraphQLError('Credenciales inválidas', {
        extensions: { code: 'UNAUTHENTICATED' },
      });
      const token = jwt.sign({ userId: user.id }, SECRET, { expiresIn: '1d' });
      return { token, user };
    },
  },
};
```

### Cliente

```js
const client = new ApolloClient({
  link: new HttpLink({
    uri: '/graphql',
    headers: { authorization: `Bearer ${localStorage.getItem('token')}` },
  }),
  cache: new InMemoryCache(),
});
```

## 5. Autorización por campo

La autenticación identifica al usuario; la autorización decide qué puede hacer. Hay dos estrategias:

### a) Guardas en resolvers

```js
const resolvers = {
  Query: {
    adminUsers: async (parent, args, context) => {
      if (!context.user) throw new GraphQLError('No autenticado', {
        extensions: { code: 'UNAUTHENTICATED' },
      });
      if (context.user.role !== 'ADMIN') throw new GraphQLError('Prohibido', {
        extensions: { code: 'FORBIDDEN' },
      });
      return context.prisma.user.findMany();
    },
  },
  User: {
    email: (parent, args, context) => {
      // Solo el propio usuario o un admin ven el email
      if (context.user?.id === parent.id || context.user?.role === 'ADMIN') {
        return parent.email;
      }
      throw new GraphQLError('No autorizado a ver el email', {
        extensions: { code: 'FORBIDDEN' },
      });
    },
  },
};
```

### b) Directives de autorización

```graphql
directive @auth(requires: Role = ADMIN) on FIELD_DEFINITION

enum Role { USER ADMIN }

type Query {
  me: User! @auth(requires: USER)
  allUsers: [User!]! @auth(requires: ADMIN)
}
```

Implementación de la directive (con `@graphql-tools/schema`):

```js
const { SchemaDirectiveVisitor } = require('@graphql-tools/utils');

class AuthDirective extends SchemaDirectiveVisitor {
  visitFieldDefinition(field) {
    const requiredRole = this.args.requires;
    const originalResolver = field.resolve;
    field.resolve = async (parent, args, context, info) => {
      if (!context.user) throw new GraphQLError('No autenticado', {
        extensions: { code: 'UNAUTHENTICATED' },
      });
      if (!hasRole(context.user, requiredRole)) {
        throw new GraphQLError('Prohibido', { extensions: { code: 'FORBIDDEN' } });
      }
      return originalResolver ? originalResolver(parent, args, context, info) : parent[field.name];
    };
  }
}

const schema = makeExecutableSchema({
  typeDefs,
  resolvers,
  directiveResolvers: { auth: AuthDirective },
});
```

## 6. Rate limiting y query complexity

GraphQL tiene un endpoint único, lo que hace inválido el rate limiting por URL. Hay que proteger el servidor de queries maliciosas o costosas.

### a) Depth limiting

Limita la profundidad de anidamiento para evitar queries recursivas maliciosas:

```graphql
query Evil {
  user(id: "1") {
    friends { friends { friends { friends { ... } } } }
  }
}
```

```js
const { createDepthLimit } = require('graphql-depth-limit');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [createDepthLimit(7)], // máximo 7 niveles
});
```

### b) Query complexity (cost analysis)

Asigna un coste a cada campo y rechaza queries que superen un presupuesto:

```js
const { createComplexityRule, simpleEstimator, fieldExtensionsEstimator } =
  require('graphql-query-complexity');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [
    (requestContext) => createComplexityRule({
      maximumComplexity: 1000,
      variables: requestContext.request.variables,
      estimators: [
        fieldExtensionsEstimator(),
        simpleEstimator({ defaultComplexity: 1 }),
      ],
      onComplete: (complexity) => console.log('Complexity:', complexity),
    }),
  ],
});
```

Coste por campo en el schema:

```graphql
type Query {
  users: [User!]! @complexity(value: 5, multipliers: ["limit"])
}
```

### c) Rate limiting por usuario/IP

A nivel de middleware HTTP:

```js
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 60 * 1000,   // 1 minuto
  max: 100,              // 100 peticiones por minuto
});

app.use('/graphql', limiter, expressMiddleware(server, { context }));
```

| Protección | Qué evita |
|---|---|go|
| Depth limiting | Queries recursivas profundas |
| Query complexity | Queries costosas (muchos campos o listas grandes) |
| Rate limiting | Abuso por volumen de peticiones |
| Persisted queries | Queries arbitrarias desde el cliente |

## 7. Persisted queries

Las persisted queries consisten en que el cliente envía un **hash** de la query en vez de la query entera. El servidor tiene un mapa hash → query.

Ventajas:

- Reduce tamaño de la petición (solo se envía el hash).
- Mejora el cacheo HTTP (GET con hash es cacheable).
- Seguridad: el servidor solo ejecuta queries preaprobadas.

### Flujo

1. Cliente calcula el hash SHA256 de la query.
2. Envía `{"extensions": {"persistedQuery": {"sha256Hash": "abc..."}}}`.
3. Si el servidor no conoce el hash, responde con error `PersistedQueryNotFound`.
4. El cliente reenvía la query completa junto al hash para que el servidor la guarde.
5. En adelante, solo se envía el hash.

### Apollo Server

Apollo Server lo soporta de forma nativa activándolo en el enlace del cliente y un cache en el servidor:

```js
const { ApolloServer } = require('@apollo/server');
const { ApolloServerPluginCacheControl } = require('@apollo/server/plugin/cacheControl');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  // persisted queries se habilitan con el plugin de cache y el link del cliente
});
```

### Apollo Client

```js
import { createPersistedQueryLink } from '@apollo/client/link/persisted-queries';
import { HttpLink } from '@apollo/client';

const httpLink = new HttpLink({ uri: '/graphql' });
const persistedLink = createPersistedQueryLink({ useGETForHashedQueries: true });

const client = new ApolloClient({
  link: from([persistedLink, httpLink]),
  cache: new InMemoryCache(),
});
```

Con `useGETForHashedQueries: true`, las queries se envían por GET y son cacheables por CDN.

## 8. Federation y schema stitching

En microservicios, cada servicio expone parte del graph. Hay dos enfoques principales:

### Apollo Federation

Cada servicio define su parte del schema y puede **extender** tipos de otros servicios. Un **gateway** une todo en un solo endpoint.

```graphql
# Servicio Users
type User @key(fields: "id") {
  id: ID!
  name: String!
}
```

```graphql
# Servicio Posts — extiende User
type User @key(fields: "id") {
  id: ID! @external
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  authorId: ID!
}
```

El gateway resuelve referencias entre servicios. El cliente ve un solo schema.

### Schema stitching

Es el enfoque clásico (pre-federation). Usa `@graphql-tools/stitch` para combinar schemas:

```js
const { stitchSchemas } = require('@graphql-tools/stitch');

const gatewaySchema = stitchSchemas({
  subschemas: [
    { schema: usersSchema, executor: usersExecutor },
    { schema: postsSchema, executor: postsExecutor },
  ],
});
```

Federation es más moderno y escalable; stitching sigue siendo útil para integrar APIs GraphQL legacy.

## 9. N+1 y DataLoader en producción

En producción el N+1 problem es crítico por el volumen de tráfico. Reglas:

- Crear los loaders en el `context` de cada petición (nunca globales).
- Usar `load(id)` en los field resolvers de relaciones.
- Para listas de IDs, usar `loadMany(ids)`.
- Si hay muchas relaciones, tener un loader por tipo (`userLoader`, `postLoader`).

```js
function createLoaders(prisma) {
  return {
    userLoader: new DataLoader(async (ids) => {
      const users = await prisma.user.findMany({ where: { id: { in: ids } } });
      return ids.map((id) => users.find((u) => u.id === id));
    }),
    postLoader: new DataLoader(async (userIds) => {
      const posts = await prisma.post.findMany({ where: { authorId: { in: userIds } } });
      return userIds.map((id) => posts.filter((p) => p.authorId === id));
    }),
  };
}

// En el context:
context: async ({ req }) => ({
  user: getUser(req),
  prisma,
  loaders: createLoaders(prisma),
}),
```

## 10. Monitoreo (Apollo Studio / metrics)

### Apollo Studio

Apollo Studio es la plataforma de observabilidad para GraphQL. Con un plugin se reportan métricas:

```js
const { ApolloServerPluginUsageReporting } = require('@apollo/server/plugin/usageReporting');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  plugins: [
    ApolloServerPluginUsageReporting({
      // Configure what to send to Studio
    }),
  ],
});
```

Métricas que aporta:

- Latencia por campo y por operación.
- Errores con trazas.
- Query complexity promedio.
- Clientes y operaciones más frecuentes.
- Field usage (qué campos se piden más).

### Logging estructurado

```js
const winston = require('winston');
const logger = winston.createLogger({ /* ... */ });

context: async ({ req }) => {
  const requestId = req.headers['x-request-id'] || crypto.randomUUID();
  logger.info({ msg: 'request', operationName: req.body.operationName, requestId });
  return { logger, requestId, user: getUser(req) };
},
```

## 11. Testing de schema

### Tests unitarios de resolvers

```js
describe('Query.user', () => {
  it('devuelve el usuario por id', async () => {
    const context = { prisma: mockPrisma };
    const result = await resolvers.Query.user(
      null,
      { id: '1' },
      context
    );
    expect(result.id).toBe('1');
  });
});
```

### Tests de integración con `execute`

```js
const { execute } = require('@graphql-tools/executor');

const query = `#graphql
  query { user(id: "1") { name } }
`;

const result = await execute({ schema, document: parse(query), contextValue: mockContext });
expect(result.data.user.name).toBe('Ana');
```

### Tests E2E con Apollo Server

```js
const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');

it('responde a hello', async () => {
  const server = new ApolloServer({ typeDefs, resolvers });
  const { url } = await startStandaloneServer(server, { listen: { port: 0 } });
  const res = await fetch(`${url}/graphql`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ query: '{ hello }' }),
  });
  const { data } = await res.json();
  expect(data.hello).toBe('¡Hola GraphQL!');
  await server.stop();
});
```

## 12. Migración de schema

GraphQL no se versiona como REST. Se evoluciona:

- **Añadir campos**: nunca rompe clientes (cambios aditivos).
- **Deprecar campos**: se marca con `@deprecated(reason: "...")`.
- **Eliminar campos**: solo cuando ningún cliente los usa (ver metrics de Apollo Studio).
- **Renombrar**: añadir el nuevo, deprecar el viejo, migrar clientes, eliminar el viejo.

```graphql
type User {
  name: String! @deprecated(reason: "Usar 'fullName'. Se eliminará en v2.")
  fullName: String!
}
```

Los clientes pueden ver los campos deprecated en introspection y ajustar.

## 13. Cache con persisted queries

Las persisted queries, combinadas con `GET`, permiten:

- **CDN caching**: el hash en la URL hace la query cacheable por el CDN.
- **HTTP cache**: `Cache-Control` headers en respuestas GET.
- **Apollo Server response cache**: cachea resultados por query + variables.

```js
const server = new ApolloServer({
  typeDefs,
  resolvers,
  plugins: [ApolloServerPluginCacheControl({ defaultMaxAge: 0 })],
});
```

En el schema:

```graphql
type Post @cacheControl(maxAge: 60) {
  id: ID!
  title: String!
}
```

Un `maxAge: 60` en `Post` indica que la respuesta se puede cachear 60 segundos. El plugin calcula el `maxAge` mínimo de todos los campos de la query.

## Conceptos clave

- **Apollo Server**: servidor GraphQL para Node.js; integra middleware con Express/Fastify.
- **Apollo Client**: cliente con caché normalizada por `__typename` + `id`.
- **Subscriptions**: tiempo real sobre WebSocket (`graphql-ws`); usan AsyncIterators.
- **JWT**: se valida en el `context`; `context.user` disponible en todos los resolvers.
- **Autorización por campo**: guardas en resolvers o directives `@auth`.
- **Rate limiting**: por volumen (HTTP) + depth limiting + query complexity.
- **Persisted queries**: hash en vez de query entera; reduce tráfico y mejora caché/seguridad.
- **Federation**: microservicios que extienden tipos de otros servicios; gateway unifica.
- **Schema stitching**: combinación clásica de schemas (pre-federation).
- **DataLoader en producción**: loaders por petición en el `context`.
- **Apollo Studio**: observabilidad de latencia, errores y field usage.
- **Migración de schema**: aditiva, con `@deprecated`; sin versiones rotadoras.
- **Cache multicapa**: CDN, HTTP, response cache, Apollo Client cache.

## Errores comunes

- **No proteger el endpoint**: sin depth limit ni complexity, una query maliciosa puede tumbar el servidor.
- **Crear DataLoader global**: cachea entre peticiones y entre usuarios; debe ser por request.
- **Validar JWT tarde**: si lo haces dentro del resolver en vez del context, lo repites en cada campo.
- **Olvidar rate limiting**: el endpoint único recibe todo el tráfico; sin límites, es vulnerable.
- **Habilitar introspection en producción**: expone todo el schema a atacantes.
- **No usar persisted queries en producción**: se pierde cacheo CDN y se permite cualquier query.
- **Versionar el schema como REST**: GraphQL se evoluciona aditivamente, no con `v2`.
- **No monitorizar field usage**: sin métricas no sabes qué campos puedes deprecar o eliminar.
- **Subscriptions sin backpressure**: si publicas muchos eventos, el WebSocket puede saturarse.
- **No cerrar conexiones WebSocket**: si no gestionas desconexiones, se acumulan conexiones fantasma.
