# Ejercicio 01 - Resolver básico

- **Nivel:** 4/5
- **Tema:** Resolvers y DataSources
- **Tiempo estimado:** 30 minutos

## Enunciado

Escribe un **resolver** en JavaScript que implemente la query `user(id: ID!): User` usando un data source simulado. El resolver debe usar la firma `(parent, args, context, info)` y obtener el usuario desde `context.db.users`.

Además, define un field resolver para `User.fullName` que concatene `firstName` y `lastName`.

## Requisitos

- [ ] `schema.graphql` define `User` con `firstName`, `lastName` y `fullName`.
- [ ] `resolvers.js` define `Query.user` usando `(parent, args, context)`.
- [ ] `Query.user` usa `context.db.users` para buscar por `args.id`.
- [ ] `User.fullName` es un field resolver que concatena `firstName` y `lastName`.
- [ ] El resolver de `Query.user` es asíncrono (`async`).
- [ ] `query.graphql` pide `fullName` del usuario.
- [ ] `expected.json` tiene la respuesta.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La firma del resolver es `(parent, args, context, info)`.
- Un field resolver se define dentro del tipo: `User: { fullName: (user) => ... }`.
- `async/await` funciona porque GraphQL espera las Promesas automáticamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  firstName: String!
  lastName: String!
  fullName: String!
  email: String
}

type Query {
  user(id: ID!): User
}
```

**resolvers.js**

```js
const resolvers = {
  Query: {
    user: async (parent, args, context, info) => {
      const user = await context.db.users.findById(args.id);
      return user;
    },
  },
  User: {
    fullName: (user, args, context) => {
      return `${user.firstName} ${user.lastName}`;
    },
  },
};

module.exports = { resolvers };
```

**query.graphql**

```graphql
query {
  user(id: "1") {
    id
    fullName
    email
  }
}
```

**expected.json**

```json
{
  "data": {
    "user": {
      "id": "1",
      "fullName": "Ana García",
      "email": "ana@x.com"
    }
  }
}
```

</details>
