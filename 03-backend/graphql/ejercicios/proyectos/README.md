# Proyecto final — API GraphQL de red social

- **Nivel:** Integrador (5/5)
- **Tema:** Producción, Seguridad, Testing
- **Tiempo estimado:** 6–10 horas

## Contexto

Vas a construir el backend de una **red social** completo en GraphQL. El proyecto integra todo lo aprendido en los niveles anteriores: schema SDL, resolvers con DataLoader para evitar el problema N+1, autenticación JWT mediante el contexto, subscriptions en tiempo real para notificaciones, validación de inputs, paginación y testing del schema.

El objetivo es que el resultado sea un API funcional, segura y testeable, que sirva como pieza de portfolio.

## Requisitos

### Modelo de datos

- [ ] **Usuarios**: `id`, `username`, `email`, `bio`.
- [ ] **Posts**: `id`, `content`, `authorId`, `createdAt`.
- [ ] **Comentarios**: `id`, `body`, `postId`, `authorId`, `createdAt`.
- [ ] **Likes**: un usuario puede dar like a un post (relación usuario–post).
- [ ] **Follows**: un usuario puede seguir a otro (relación usuario–usuario).

### Queries

- [ ] `me`: usuario autenticado actual (vía `context.user`).
- [ ] `user(id)`: usuario por id con sus posts.
- [ ] `posts(limit, after)`: feed de posts con **paginación** (connexiones o simple cursor).
- [ ] `post(id)`: post con comentarios y autor.
- [ ] `notifications`: notificaciones del usuario autenticado.

### Mutations

- [ ] `register(username, email, password)`: crea usuario y devuelve `AuthPayload`.
- [ ] `login(email, password)`: valida credenciales y devuelve JWT.
- [ ] `createPost(content)`: crea post (requiere auth).
- [ ] `createComment(postId, body)`: crea comentario (requiere auth).
- [ ] `toggleLike(postId)`: alterna like (requiere auth).
- [ ] `follow(userId)`: sigue a un usuario (requiere auth).
- [ ] `unfollow(userId)`: deja de seguir a un usuario (requiere auth).

### Subscriptions

- [ ] `postCreated`: notifica cuando se crea un post.
- [ ] `commentAdded(postId)`: notifica cuando se añade un comentario a un post.

### Seguridad y rendimiento

- [ ] Autenticación JWT mediante el `context` (`context.js`).
- [ ] Las mutations que escriben requieren usuario autenticado; si no, lanzan `GraphQLError` con código `UNAUTHENTICATED`.
- [ ] Resolvers de relaciones (`author`, `comments`, `likes`) usan **DataLoader** para evitar N+1.
- [ ] Validación de inputs: contenido no vacío, email con formato, longitud máxima.
- [ ] Paginación en `posts`.

### Testing

- [ ] `test.sh` valida estructura de los archivos starter.
- [ ] Tests del schema: tipos definidos, queries y mutations cubren los requisitos.
- [ ] Tests de errores: mutations protegidas sin auth lanzan error.

## Archivos starter

Se incluyen los siguientes archivos en `starter/`:

| Archivo | Contenido |
|---|---|
| `starter/schema.graphql` | Schema SDL completo con tipos, queries, mutations, subscriptions y directiva de auth. |
| `starter/server.js` | Servidor Apollo con Express, subscriptions WebSocket y DataLoader en el contexto. |
| `starter/resolvers.js` | Resolvers de Query, Mutation, Subscription y relaciones (DataLoader). |
| `starter/context.js` | Context con autenticación JWT e inicialización de DataLoaders. |

Completa las partes marcadas con `TODO` y verifica con:

```bash
bash test.sh
```

## Fases

### Fase 1 — Schema (30%)

1. Define todos los tipos del modelo en `schema.graphql`.
2. Añade las queries y mutations.
3. Añade las subscriptions con `PubSub`.
4. Añade una directiva `@auth` (o protección vía contexto) para campos protegidos.

### Fase 2 — Autenticación (20%)

1. Implementa `register` y `login` (hash de contraseña con `bcryptjs`, JWT con `jsonwebtoken`).
2. `context.js` extrae el usuario del header `Authorization` y lo inyecta en `context.user`.
3. Lanza `GraphQLError` con código `UNAUTHENTICATED` si falta auth en mutations protegidas.

### Fase 3 — Resolvers y DataLoader (25%)

1. Implementa los resolvers de `Query` y `Mutation`.
2. Crea `DataLoader` para `usersByIds`, `postsByAuthorId` y `commentsByPostId`.
3. Inicializa los loaders en el `context` para que se reinicien por petición.
4. Implementa `toggleLike`, `follow` y `unfollow`.

### Fase 4 — Subscriptions (10%)

1. Configura `PubSub` en el contexto.
2. Publica eventos en `createPost` y `createComment`.
3. Configura el servidor WebSocket (`graphql-ws` o `subscriptions-transport-ws`).

### Fase 5 — Testing (15%)

1. Escribe tests del schema in-memory (tipos, queries, mutations).
2. Verifica que las mutations protegidas fallan sin auth.
3. Verifica la paginación de `posts`.
4. `bash test.sh` pasa.

## Criterios de aceptación

- [ ] `bash test.sh` imprime `OK Tests pasaron`.
- [ ] El schema define todos los tipos: `User`, `Post`, `Comment`, `Like`, `Follow`, `Notification`, `PageInfo`, `PostConnection`.
- [ ] Existen queries `me`, `user`, `posts`, `post`, `notifications`.
- [ ] Existen mutations `register`, `login`, `createPost`, `createComment`, `toggleLike`, `follow`, `unfollow`.
- [ ] Existen subscriptions `postCreated`, `commentAdded`.
- [ ] `context.js` extrae el usuario del header JWT.
- [ ] `resolvers.js` usa `DataLoader` en al menos una relación.
- [ ] `server.js` configura PubSub y WebSocket para subscriptions.
- [ ] `posts` implementa paginación.
- [ ] Las mutations protegidas lanzan `UNAUTHENTICATED` sin token.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para DataLoader: crea los loaders en el `context` por petición para no cachear entre usuarios:
  ```js
  const loaders = {
    user: new DataLoader(async (ids) => { ... }),
    postsByAuthor: new DataLoader(async (authorIds) => { ... }),
  };
  ```
- Para auth en mutations, crea un helper `requireAuth(context)` que lanza `GraphQLError` si `!context.user`.
- Para subscriptions, `pubsub.asyncIterator('POST_CREATED')` en el resolver de subscription.
- Para paginación tipo connexiones: `PostConnection { edges: [PostEdge!]! pageInfo: PageInfo! }` con `PageInfo { hasNextPage endCursor }`.
- Usa `graphql-ws` con Apollo Server v4 para subscriptions WebSocket.
- Para validación de email, una regex simple: `/^[^\s@]+@[^\s@]+\.[^\s@]+$/`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

Las soluciones completas están en los archivos `starter/schema.graphql`, `starter/server.js`, `starter/resolvers.js` y `starter/context.js`. Los puntos clave:

- **Schema**: define los 8 tipos requeridos, queries, mutations, subscriptions y la directiva `@auth`.
- **Context**: extrae JWT, inyecta `user`, `pubsub` y `loaders` (DataLoader por petición).
- **Resolvers**: las mutations protegidas llaman a `requireAuth(context)`; las relaciones usan `context.loaders.*`.
- **Server**: configura Apollo con Express, `PubSub` y WebSocket.

</details>
