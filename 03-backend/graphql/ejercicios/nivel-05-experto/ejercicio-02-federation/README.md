# Ejercicio 02 - Federation

- **Nivel:** 5/5
- **Tema:** Producción y Seguridad
- **Tiempo estimado:** 45 minutos

## Enunciado

Implementa **Apollo Federation**: define dos servicios (Users y Posts) donde el servicio Posts **extiende** el tipo `User` del servicio Users. Cada servicio define su parte del schema con `@key` y `@external`.

## Requisitos

- [ ] `users-service.graphql` define `type User @key(fields: "id")` con `id`, `name`, `email`.
- [ ] `posts-service.graphql` define `type Post` y **extiende** `User` con `posts: [Post!]!`.
- [ ] El servicio Posts usa `@extends` en `User` y `@external` en `id`.
- [ ] El servicio Posts define `@key(fields: "id")` en `User`.
- [ ] `gateway.js` configura un Apollo Gateway con los dos servicios.
- [ ] `query.graphql` pide un usuario con sus posts (cross-service).
- [ ] `expected.json` tiene la respuesta combinada.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Federation permite que un servicio extienda un tipo definido en otro.
- `@key(fields: "id")` marca la clave que identifica al tipo entre servicios.
- `@external` indica que un campo viene de otro servicio.
- El gateway combina todo y el cliente ve un solo schema.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**users-service.graphql**

```graphql
type User @key(fields: "id") {
  id: ID!
  name: String!
  email: String!
}

type Query {
  user(id: ID!): User
}
```

**posts-service.graphql**

```graphql
type Post @key(fields: "id") {
  id: ID!
  title: String!
  body: String!
  authorId: ID!
}

type User @key(fields: "id") {
  id: ID! @external
  posts: [Post!]!
}

type Query {
  post(id: ID!): Post
}
```

**gateway.js**

```js
const { ApolloGateway } = require('@apollo/gateway');
const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');

const gateway = new ApolloGateway({
  serviceList: [
    { name: 'users', url: 'http://localhost:4001/graphql' },
    { name: 'posts', url: 'http://localhost:4002/graphql' },
  ],
});

const server = new ApolloServer({ gateway });

async function start() {
  const { url } = await startStandaloneServer(server, {
    listen: { port: 4000 },
  });
  console.log(`🚀 Gateway en ${url}`);
}

start();
```

**query.graphql**

```graphql
query {
  user(id: "1") {
    id
    name
    email
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
    "user": {
      "id": "1",
      "name": "Ana",
      "email": "ana@x.com",
      "posts": [
        { "id": "1", "title": "Hola" }
      ]
    }
  }
}
```

</details>
