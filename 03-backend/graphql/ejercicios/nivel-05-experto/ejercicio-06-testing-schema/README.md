# Ejercicio 06 - Testing de schema GraphQL

- **Nivel:** 5/5
- **Tema:** Producción y Testing
- **Tiempo estimado:** 45 minutos

## Enunciado

Escribe **tests** para un schema GraphQL usando el ejecutor in-memory de la librería `graphql`. Crea una función `test` que ejecute queries y mutations directamente contra el schema (sin levantar un servidor HTTP) y valida: tipos del schema, queries, mutations y errores.

## Requisitos

- [ ] `schema.graphql` define `User`, `Post`, `Query` y `Mutation` con al menos una query y una mutation.
- [ ] `resolvers.js` implementa los resolvers de `Query` y `Mutation` con datos en memoria.
- [ ] `test.js` importa `graphql` y `buildSchema` (o `makeExecutableSchema`) para ejecutar queries in-memory.
- [ ] `test.js` define una función `test(name, fn)` que ejecuta y reporta cada caso.
- [ ] `test.js` incluye un test de **tipos** (verifica que el schema define los tipos esperados).
- [ ] `test.js` incluye un test de **queries** (ejecuta una query y valida el resultado).
- [ ] `test.js` incluye un test de **mutations** (ejecuta una mutation y valida el resultado).
- [ ] `test.js` incluye un test de **errores** (ejecuta una query inválida y valida que hay errores).
- [ ] `test.js` usa `node:test` o un runner propio con aserciones.
- [ ] `expected.json` tiene el resultado esperado de la query de ejemplo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La función `graphql({ schema, source, rootValue, variableValues })` del paquete `graphql` ejecuta una query contra un schema construido con `buildSchema`, sin necesidad de servidor HTTP.
- `rootValue` es el objeto de resolvers cuando usas `buildSchema` (resolvers sin contexto tipado).
- Para validar tipos, puedes usar `schema.getType('User')` y comprobar que no es `undefined`.
- Para el test de errores, ejecuta una query a un campo inexistente o con argumentos inválidos y comprueba que `result.errors` no es `undefined`.
- `node:test` (integrado en Node 18+) no requiere dependencias externas: `import { test } from 'node:test'` y `import assert from 'node:assert/strict'`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  name: String!
  email: String!
}

type Post {
  id: ID!
  title: String!
  author: User!
}

type Query {
  user(id: ID!): User
  users: [User!]!
  post(id: ID!): Post
}

type Mutation {
  createUser(name: String!, email: String!): User!
  deleteUser(id: ID!): Boolean!
}
```

**resolvers.js**

```js
// Resolvers con datos en memoria para testing
const users = [
  { id: '1', name: 'Ana', email: 'ana@x.com' },
  { id: '2', name: 'Luis', email: 'luis@x.com' },
];

const posts = [
  { id: '101', title: 'Hola mundo', authorId: '1' },
];

// rootValue para buildSchema: resolvers por tipo
const rootValue = {
  user: ({ id }) => users.find((u) => u.id === id) || null,
  users: () => users,
  post: ({ id }) => {
    const p = posts.find((p) => p.id === id);
    if (!p) return null;
    return {
      id: p.id,
      title: p.title,
      author: users.find((u) => u.id === p.authorId),
    };
  },
  createUser: ({ name, email }) => {
    const user = { id: String(users.length + 1), name, email };
    users.push(user);
    return user;
  },
  deleteUser: ({ id }) => {
    const idx = users.findIndex((u) => u.id === id);
    if (idx === -1) return false;
    users.splice(idx, 1);
    return true;
  },
};

module.exports = { rootValue, users, posts };
```

**test.js**

```js
const { test } = require('node:test');
const assert = require('node:assert/strict');
const { graphql, buildSchema } = require('graphql');
const { readFileSync } = require('fs');
const { rootValue } = require('./resolvers');

const sdl = readFileSync(require.resolve('./schema.graphql'), 'utf-8');
const schema = buildSchema(sdl);

// Helper: ejecuta una operación contra el schema in-memory
async function run(source, variables = {}) {
  return graphql({ schema, source, rootValue, variableValues: variables });
}

test('Tipos: el schema define User, Post, Query y Mutation', () => {
  assert.ok(schema.getType('User'), 'User debe existir');
  assert.ok(schema.getType('Post'), 'Post debe existir');
  assert.ok(schema.getType('Query'), 'Query debe existir');
  assert.ok(schema.getType('Mutation'), 'Mutation debe existir');
});

test('Query: users devuelve la lista de usuarios', async () => {
  const result = await run('{ users { id name } }');
  assert.equal(result.errors, undefined);
  assert.equal(result.data.users.length, 2);
  assert.equal(result.data.users[0].name, 'Ana');
});

test('Query: user(id) devuelve un usuario concreto', async () => {
  const result = await run('query($id: ID!) { user(id: $id) { name email } }', { id: '1' });
  assert.equal(result.errors, undefined);
  assert.equal(result.data.user.name, 'Ana');
  assert.equal(result.data.user.email, 'ana@x.com');
});

test('Mutation: createUser crea un nuevo usuario', async () => {
  const result = await run(
    'mutation($name: String!, $email: String!) { createUser(name: $name, email: $email) { id name email } }',
    { name: 'Eva', email: 'eva@x.com' }
  );
  assert.equal(result.errors, undefined);
  assert.equal(result.data.createUser.name, 'Eva');
  assert.equal(result.data.createUser.email, 'eva@x.com');
});

test('Mutation: deleteUser elimina un usuario', async () => {
  const result = await run('mutation($id: ID!) { deleteUser(id: $id) }', { id: '2' });
  assert.equal(result.errors, undefined);
  assert.equal(result.data.deleteUser, true);
});

test('Errores: una query a un campo inexistente produce errores', async () => {
  const result = await run('{ nonexistentField }');
  assert.ok(result.errors, 'debe haber errores');
  assert.ok(result.errors.length > 0);
});

test('Errores: una query sin argumento requerido produce errores', async () => {
  const result = await run('{ user { name } }');
  assert.ok(result.errors, 'debe haber errores por falta de argumento id');
});
```

**expected.json**

```json
{
  "data": {
    "users": [
      { "id": "1", "name": "Ana" },
      { "id": "2", "name": "Luis" }
    ]
  }
}
```

</details>
