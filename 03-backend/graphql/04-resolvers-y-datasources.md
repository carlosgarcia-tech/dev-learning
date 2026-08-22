# 04 — Resolvers y DataSources

> Resolvers, data sources, context y dependency injection, N+1 problem, DataLoader, batch loading, caching, resolver chaining, async resolvers, error handling y resolvers de union/interface.

## Objetivos

- [ ] Entender la firma de un resolver: `(parent, args, context, info)`.
- [ ] Diferenciar field resolvers y resolver functions.
- [ ] Usar data sources (REST API, database, RESTDataSource).
- [ ] Gestionar el context y la dependency injection.
- [ ] Diagnosticar y resolver el N+1 problem con DataLoader.
- [ ] Implementar batch loading y caching.
- [ ] Entender el resolver chaining y el orden de ejecución.
- [ ] Escribir resolvers asíncronos (`async`/`await`).
- [ ] Manejar errores en resolvers con `GraphQLError`.
- [ ] Resolver interfaces y unions con `__resolveType`.

## 1. Qué es un resolver

Un **resolver** es una función que produce el valor de un campo del schema. GraphQL recorre el árbol de la query y, para cada campo, llama a su resolver.

La firma canónica:

```js
const resolver = (parent, args, context, info) => { ... };
```

| Argumento | Qué contiene |
|---|---|
| `parent` (o `root`) | El objeto devuelto por el resolver del nivel anterior. En la raíz (`Query`) es `undefined` o `{}`. |
| `args` | Los argumentos pasados al campo en la query. |
| `context` | Objeto compartido entre todos los resolvers de una petición. Para auth, data sources, DB. |
| `info` | Información sobre la ejecución: selección AST, path, rootValue, schema. Avanzado. |

Ejemplo:

```js
const resolvers = {
  Query: {
    user: (parent, args, context, info) => {
      return context.dataSources.userApi.getById(args.id);
    },
  },
  User: {
    posts: (parent, args, context) => {
      return context.dataSources.postApi.getByAuthor(parent.id);
    },
  },
};
```

## 2. Field resolvers vs resolver functions

Cada campo puede tener su propio resolver (**field resolver**). Si no lo define, GraphQL usa un **default resolver** que hace `parent[fieldName]`.

```js
// Default resolver implícito (no se escribe):
// (parent) => parent[fieldName]
```

Por eso, si el objeto `parent` ya tiene el campo como propiedad, no necesitas escribir resolver:

```js
// Si parent = { id: "1", name: "Ana", email: "ana@x.com" }
// y el schema tiene campos id, name, email → no hace falta resolver
```

Solo escribes un resolver cuando necesitas transformar, calcular o buscar el dato:

```js
const resolvers = {
  User: {
    fullName: (parent) => `${parent.firstName} ${parent.lastName}`,
    posts: (parent, args, context) => context.db.post.findMany({ authorId: parent.id }),
  },
};
```

## 3. Data sources

Un **data source** es una abstracción sobre de dónde salen los datos: una base de datos SQL, una API REST, un servicio gRPC, Redis, etc. Se suelen inyectar vía `context`.

### Ejemplo: data source sobre base de datos (Prisma)

```js
const resolvers = {
  Query: {
    users: (parent, args, context) => {
      return context.prisma.user.findMany({ take: args.limit ?? 10 });
    },
    user: (parent, args, context) => {
      return context.prisma.user.findUnique({ where: { id: args.id } });
    },
  },
};
```

### RESTDataSource (Apollo)

`RESTDataSource` facilita llamadas a APIs REST con cacheo deduplicado:

```js
const { RESTDataSource } = require('@apollo/datasource-rest');

class UserAPI extends RESTDataSource {
  baseURL = 'https://api.example.com/';

  async getUser(id) {
    return this.get(`users/${id}`);
  }

  async getUsers() {
    return this.get('users');
  }

  async createUser(input) {
    return this.post('users', { body: input });
  }
}
```

Inyección en el context:

```js
const server = new ApolloServer({
  typeDefs,
  resolvers,
});

const { url } = await startStandaloneServer(server, {
  context: async () => ({
    dataSources: {
      userApi: new UserAPI(),
      postApi: new PostAPI(),
    },
  }),
});
```

### Base de datos directa vs data source

No siempre necesitas un data source formal. Un cliente de BD (Prisma, Mongoose, Knex, un pool de pg) inyectado en `context` es suficiente. La ventaja de las clases tipo `RESTDataSource` es el cacheo y la deduplicación de peticiones dentro de una misma operación.

## 4. Context y dependency injection

El **context** es un objeto que se construye una vez por petición y se pasa a todos los resolvers. Es el lugar para:

- El usuario autenticado (`context.user`).
- Conexiones a base de datos (`context.db`, `context.prisma`).
- Data sources (`context.dataSources`).
- Loaders (`context.loaders`).
- Correlación de logs (`context.requestId`).

```js
context: async ({ req }) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  const user = token ? verifyJwt(token) : null;

  return {
    user,
    prisma: prismaClient,
    requestId: crypto.randomUUID(),
    loaders: createLoaders(),
  };
},
```

Los resolvers acceden:

```js
User: {
  posts: (parent, args, context) => {
    context.logger?.debug({ requestId: context.requestId, userId: parent.id });
    return context.prisma.post.findMany({ where: { authorId: parent.id } });
  },
},
```

> El context es por petición, no global. Cada request tiene su propio context, así que puedes meter estado mutable seguro.

## 5. El N+1 problem

El N+1 problem es el problema clásico de GraphQL. Ocurre cuando resolver una lista dispara una consulta por cada elemento.

### El problema

Schema:

```graphql
type Query { users: [User!]! }
type User { id: ID! posts: [Post!]! }
```

Query del cliente:

```graphql
query { users { id posts { title } } }
```

Si el resolver de `User.posts` hace una consulta por usuario:

```js
User: {
  posts: (user, args, context) => {
    return context.prisma.post.findMany({ where: { authorId: user.id } });
    // 1 query por usuario → si hay 100 users, 100 queries + 1 inicial = N+1
  },
}
```

Con 100 usuarios: 1 query para obtener usuarios + 100 queries para sus posts = **101 queries**. Eso es N+1 y destruye el rendimiento.

### Solución: batch loading con DataLoader

DataLoader agrupa las llamadas de un mismo tick del event loop y las despacha en un solo batch.

```js
const DataLoader = require('dataloader');

function createLoaders() {
  const postLoader = new DataLoader(async (userIds) => {
    // userIds = [1, 2, 3, ..., 100] → UNA sola consulta
    const posts = await prisma.post.findMany({
      where: { authorId: { in: userIds } },
    });
    // Agrupar por authorId en el orden de userIds
    return userIds.map((id) => posts.filter((p) => p.authorId === id));
  });

  return { postLoader };
}
```

Uso en el resolver:

```js
User: {
  posts: (user, args, context) => {
    return context.loaders.postLoader.load(user.id); // batched
  },
}
```

Ahora 100 usuarios → 1 query para usuarios + 1 query batcheada para todos los posts = **2 queries**.

### Cómo funciona el batching

1. GraphQL empieza a resolver `users`.
2. Para cada `user`, llama al resolver `User.posts`.
3. Cada llamada hace `loader.load(id)`, que en lugar de ejecutarse, encola el id.
4. En el siguiente tick del event loop, DataLoader recoge todos los ids y hace **una sola** consulta.
5. Reparte los resultados a cada llamada `load`.

### Caching de DataLoader

DataLoader también cachea por clave dentro de la petición. Si dos campos piden `user.id` para el mismo usuario en la misma operación, solo se carga una vez.

> Importante: el caché de DataLoader es **por petición**, no global. Se crea en el context de cada request. Para caché entre peticiones hay que usar Redis u otras capas.

## 6. Caching

Hay varias capas de caché en GraphQL:

| Capa | Qué cachea | Duración | Dónde |
|---|---|---|---|
| DataLoader | Resultados de `load` por clave en una petición | Una petición | `context.loaders` |
| RESTDataSource | Respuestas HTTP deduplicadas | Una petición | data source |
| Apollo Server response cache | Respuesta completa por query | TTL configurable | CDN / servidor |
| CDN / HTTP cache | Respuestas `GET` cacheables | TTL | CDN |
| Apollo Client cache | Resultados en el navegador | Hasta invalidación | Cliente |
| Redis / app cache | Datos críficos | TTL | Servidor |

### Apollo Server `cacheControl`

```js
const resolvers = {
  Query: {
    posts: () => posts,
  },
  Post: {
    __resolveType: () => 'Post',
  },
};

// En el schema con directives
type Post @cacheControl(maxAge: 60) {
  id: ID!
  title: String!
}
```

## 7. Resolver chaining

GraphQL ejecuta los resolvers nivel a nivel. El orden es:

1. Resolver del campo raíz (`Query.users`).
2. Para cada elemento, resolvers de sus campos (`User.id`, `User.name`, `User.posts`).
3. Para cada subcampo, sus resolvers, recursivamente.

```
query { users { id name posts { title } } }

→ Query.users           (1 vez)
  → User.id             (N veces)
  → User.name           (N veces)
  → User.posts          (N veces)
    → Post.title        (M veces por usuario)
```

Campos del **mismo nivel** se ejecutan en paralelo (con `Promise.all` implícito). Los niveles se ejecutan secuencialmente: primero todos los de un nivel, luego los del siguiente.

### Ejemplo de orden

```js
const resolvers = {
  Query: {
    user: async () => {
      console.log('1. Query.user');
      return { id: '1', firstName: 'Ana', lastName: 'García' };
    },
  },
  User: {
    fullName: (user) => {
      console.log('2. User.fullName');
      return `${user.firstName} ${user.lastName}`;
    },
    posts: async (user, args, context) => {
      console.log('3. User.posts');
      return context.prisma.post.findMany({ where: { authorId: user.id } });
    },
  },
};
```

`fullName` y `posts` se ejecutan en paralelo porque están al mismo nivel.

## 8. Async resolvers

Los resolvers pueden devolver Promesas. GraphQL las espera automáticamente:

```js
const resolvers = {
  Query: {
    user: async (parent, args, context) => {
      const user = await context.prisma.user.findUnique({ where: { id: args.id } });
      if (!user) throw new GraphQLError('User not found', {
        extensions: { code: 'NOT_FOUND' },
      });
      return user;
    },
  },
  User: {
    posts: async (user, args, context) => {
      const posts = await context.loaders.postLoader.load(user.id);
      return posts.slice(0, args.limit ?? 10);
    },
  },
};
```

Reglas:

- Un resolver puede ser síncrono (devolver valor directo) o asíncrono (devolver Promise).
- GraphQL no diferencia: si devuelve una Promise, la espera.
- Si un resolver devuelve una Promise que rechaza, el campo se trata como error.

## 9. Error handling en resolvers

### Lanzar GraphQLError

La forma correcta de lanzar errores en GraphQL es con `GraphQLError` (o una subclase), con `extensions.code`:

```js
const { GraphQLError } = require('graphql');

const resolvers = {
  Mutation: {
    updateUser: async (parent, args, context) => {
      if (!context.user) {
        throw new GraphQLError('Debes iniciar sesión', {
          extensions: { code: 'UNAUTHENTICATED', http: { status: 401 } },
        });
      }
      if (context.user.id !== args.id && !context.user.isAdmin) {
        throw new GraphQLError('No autorizado', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      return context.prisma.user.update({ where: { id: args.id }, data: args.input });
    },
  },
};
```

### Códigos de error recomendados

| Código | Cuándo |
|---|---|
| `UNAUTHENTICATED` | No hay usuario logueado |
| `FORBIDDEN` | Hay usuario pero no tiene permiso |
| `BAD_USER_INPUT` | Argumentos inválidos |
| `NOT_FOUND` | Recurso no existe |
| `INTERNAL_SERVER_ERROR` | Error inesperado del servidor |

### No filtrar `data` entera

Si solo falla un campo nullable, GraphQL sigue devolviendo el resto. Si el campo es non-null, el null propaga hacia arriba. Diseña la nullabilidad para que errores aislados no tumben toda la respuesta.

### Formateador de errores personalizado

Apollo Server permite personalizar cómo se serializan los errores:

```js
const server = new ApolloServer({
  typeDefs,
  resolvers,
  formatError: (formattedError, error) => {
    // Ocultar stack traces en producción
    if (process.env.NODE_ENV === 'production') {
      delete formattedError.extensions.stacktrace;
    }
    return formattedError;
  },
});
```

## 10. Resolvers de union e interface (`__resolveType`)

Cuando un campo devuelve una interface o union, GraphQL necesita saber qué tipo concreto es cada objeto. Para eso se usa `__resolveType`.

### Interface

```graphql
interface Node { id: ID! }

type Query {
  node(id: ID!): Node
}

type User implements Node { id: ID! name: String! }
type Post implements Node { id: ID! title: String! }
```

```js
const resolvers = {
  Node: {
    __resolveType: (obj, context, info) => {
      if (obj.name) return 'User';
      if (obj.title) return 'Post';
      return null;
    },
  },
};
```

### Union

```graphql
union SearchResult = User | Post | Comment

type Query {
  search(term: String!): [SearchResult!]!
}
```

```js
const resolvers = {
  SearchResult: {
    __resolveType: (obj) => {
      if (obj.email) return 'User';
      if (obj.body) return 'Post';
      if (obj.text) return 'Comment';
      return null;
    },
  },
};
```

Alternativa: si el objeto ya trae una propiedad `__typename` o puedes inferir el tipo de forma fiable, no necesitas `__resolveType`.

### Detección por `__typename`

Si los data sources devuelven objetos con `__typename`, GraphQL lo usa automáticamente:

```js
const user = { __typename: 'User', id: '1', name: 'Ana' };
// GraphQL sabe que es un User sin __resolveType
```

## Conceptos clave

- **Resolver**: función `(parent, args, context, info)` que produce el valor de un campo.
- **Default resolver**: si no defines resolver, se hace `parent[fieldName]`.
- **Context**: objeto por petición para auth, DB, loaders, data sources.
- **Data sources**: abstracción sobre la fuente de datos (REST, SQL, etc.).
- **N+1 problem**: resolver una lista dispara N consultas; se soluciona con DataLoader.
- **DataLoader**: batching + caching por petición; agrupa llamadas del mismo tick.
- **Caching multicapa**: DataLoader (petición), HTTP/CDN (TTL), Apollo Client (cliente).
- **Resolver chaining**: nivel a nivel; campos del mismo nivel en paralelo.
- **Async**: los resolvers pueden devolver Promesas; GraphQL las espera.
- **GraphQLError**: errores con `extensions.code`; no usar status HTTP para errores de negocio.
- **`__resolveType`**: resuelve el tipo concreto de interfaces y unions.

## Errores comunes

- **Olvidar el context**: los resolvers no pueden acceder al usuario, DB o loaders si no se inyectan en `context`.
- **Sufrir N+1 sin darse cuenta**: si al pedir una lista con relaciones el número de queries explota, casi siempre es N+1.
- **Crear DataLoader global**: DataLoader cachea por petición; si lo creas fuera del context, cachea entre usuarios (bug de seguridad y datos cruzados).
- **Lanzar `Error` plano en vez de `GraphQLError`**: pierdes `extensions.code` y el control fino de errores.
- **No filtrar stack traces en producción**: expone detalles internos del servidor.
- **Hacer resolvers síncronos bloqueantes**: si el dato es asíncrono, devuelve una Promise; nunca bloquees el event loop.
- **Olvidar `__resolveType`**: si un campo devuelve interface/union y no se puede inferir el tipo, GraphQL falla en runtime.
- **Resolver campos que no se piden**: aunque el default resolver evita esto, un resolver personalizado mal puesto puede ejecutarse de más.
- **Meter estado mutable global**: el context es por petición; si guardas estado en una variable de módulo, se comparte entre requests y hay fugas.
- **No deduplicar peticiones REST**: sin `RESTDataSource` o cache, varias llamadas a la misma URL en una petición se repiten.
