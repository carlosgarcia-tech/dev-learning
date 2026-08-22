# Ejercicio 04 - Subscription con WebSocket

- **Nivel:** 4/5
- **Tema:** Producción y Seguridad
- **Tiempo estimado:** 40 minutos

## Enunciado

Define una **subscription** `postAdded` que notifique cuando se crea un post nuevo. Escribe en `resolvers.js` el resolver de subscription con `subscribe` (usando PubSub) y la mutation `createPost` que publica el evento.

## Requisitos

- [ ] `schema.graphql` define `type Subscription { postAdded: Post! }`.
- [ ] `schema.graphql` define `type Mutation { createPost(input: CreatePostInput!): Post! }`.
- [ ] `resolvers.js` define `Subscription.postAdded.subscribe` usando `pubsub.asyncIterator`.
- [ ] `resolvers.js` define `Mutation.createPost` que publica en PubSub.
- [ ] `query.graphql` define la subscription `postAdded`.
- [ ] `expected.json` tiene un ejemplo de evento recibido.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una subscription se define como `type Subscription { evento: Tipo }`.
- El resolver de subscription tiene `subscribe: () => pubsub.asyncIterator(['EVENTO'])`.
- La mutation que dispara el evento hace `pubsub.publish('EVENTO', { evento: payload })`.
- Las subscriptions se transmiten sobre WebSocket, no HTTP.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type Post {
  id: ID!
  title: String!
  body: String!
}

input CreatePostInput {
  title: String!
  body: String!
}

type Query {
  post(id: ID!): Post
}

type Mutation {
  createPost(input: CreatePostInput!): Post!
}

type Subscription {
  postAdded: Post!
}
```

**resolvers.js**

```js
const { PubSub } = require('graphql-subscriptions');
const pubsub = new PubSub();
const POST_ADDED = 'POST_ADDED';

const resolvers = {
  Subscription: {
    postAdded: {
      subscribe: () => pubsub.asyncIterator([POST_ADDED]),
    },
  },
  Mutation: {
    createPost: async (parent, args, context) => {
      const post = await context.db.posts.create({ data: args.input });
      pubsub.publish(POST_ADDED, { postAdded: post });
      return post;
    },
  },
};

module.exports = { resolvers, pubsub, POST_ADDED };
```

**query.graphql**

```graphql
subscription {
  postAdded {
    id
    title
    body
  }
}
```

**expected.json**

```json
{
  "data": {
    "postAdded": {
      "id": "1",
      "title": "Nuevo post",
      "body": "Contenido del post"
    }
  }
}
```

</details>
