# Ejercicio 01 - Apollo Server completo

- **Nivel:** 5/5
- **Tema:** Producción y Seguridad
- **Tiempo estimado:** 45 minutos

## Enunciado

Levanta un **Apollo Server** completo con: schema SDL, resolvers, context con autenticación JWT, y endpoint `/graphql`. El servidor debe tener una query `hello` y una mutation `login` que devuelva un JWT.

## Requisitos

- [ ] `schema.graphql` define `Query { hello: String! me: User }` y `Mutation { login(email: String!, password: String!): AuthPayload! }`.
- [ ] `resolvers.js` implementa `hello`, `me` (usa `context.user`) y `login` (genera JWT).
- [ ] `context.js` extrae el usuario del header `Authorization`.
- [ ] `server.js` configura ApolloServer con typeDefs, resolvers y context.
- [ ] `server.js` escucha en el puerto 4000.
- [ ] `query.graphql` define la mutation `login`.
- [ ] `expected.json` tiene la respuesta de login con token.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa `@apollo/server` y `@apollo/server/standalone` para levantar el servidor.
- El context se pasa como función async que recibe `{ req }`.
- `jwt.sign` genera el token; `jwt.verify` lo valida.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  email: String!
  name: String!
}

type AuthPayload {
  token: String!
  user: User!
}

type Query {
  hello: String!
  me: User
}

type Mutation {
  login(email: String!, password: String!): AuthPayload!
}
```

**resolvers.js**

```js
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const SECRET = process.env.JWT_SECRET || 'dev-secret';

const users = [
  { id: '1', email: 'ana@x.com', name: 'Ana', passwordHash: '$2a$10$...' },
];

const resolvers = {
  Query: {
    hello: () => '¡Hola desde Apollo Server!',
    me: (parent, args, context) => context.user,
  },
  Mutation: {
    login: async (parent, { email, password }) => {
      const user = users.find((u) => u.email === email);
      if (!user) throw new Error('Usuario no encontrado');
      const valid = await bcrypt.compare(password, user.passwordHash);
      if (!valid) throw new Error('Contraseña incorrecta');
      const token = jwt.sign({ userId: user.id }, SECRET, { expiresIn: '1d' });
      return { token, user: { id: user.id, email: user.email, name: user.name } };
    },
  },
};

module.exports = { resolvers };
```

**context.js**

```js
const jwt = require('jsonwebtoken');
const SECRET = process.env.JWT_SECRET || 'dev-secret';

const context = async ({ req }) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  let user = null;
  try {
    if (token) user = jwt.verify(token, SECRET);
  } catch { user = null; }
  return { user };
};

module.exports = { context };
```

**server.js**

```js
const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');
const { readFileSync } = require('fs');
const { resolvers } = require('./resolvers');
const { context } = require('./context');

const typeDefs = readFileSync(require.resolve('./schema.graphql'), 'utf-8');

async function start() {
  const server = new ApolloServer({ typeDefs, resolvers });
  const { url } = await startStandaloneServer(server, {
    listen: { port: 4000 },
    context,
  });
  console.log(`🚀 Server en ${url}`);
}

start();
```

**query.graphql**

```graphql
mutation {
  login(email: "ana@x.com", password: "1234") {
    token
    user {
      id
      name
      email
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "login": {
      "token": "eyJhbGciOiJIUzI1NiIs...",
      "user": { "id": "1", "name": "Ana", "email": "ana@x.com" }
    }
  }
}
```

</details>
