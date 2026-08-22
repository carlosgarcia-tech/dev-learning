const { test } = require('node:test');
const assert = require('node:assert/strict');
const { graphql, buildSchema } = require('graphql');
const { readFileSync } = require('fs');
const { rootValue } = require('./resolvers');

const sdl = readFileSync(require.resolve('./schema.graphql'), 'utf-8');
const schema = buildSchema(sdl);

// Helper: ejecuta una operación contra el schema in-memory (sin servidor HTTP)
async function run(source, variables = {}) {
  return graphql({ schema, source, rootValue, variableValues: variables });
}

// --- Test de tipos ---
test('Tipos: el schema define User, Post, Query y Mutation', () => {
  assert.ok(schema.getType('User'), 'User debe existir');
  assert.ok(schema.getType('Post'), 'Post debe existir');
  assert.ok(schema.getType('Query'), 'Query debe existir');
  assert.ok(schema.getType('Mutation'), 'Mutation debe existir');
});

// --- Test de queries ---
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

// --- Test de mutations ---
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

// --- Test de errores ---
test('Errores: una query a un campo inexistente produce errores', async () => {
  const result = await run('{ nonexistentField }');
  assert.ok(result.errors, 'debe haber errores');
  assert.ok(result.errors.length > 0);
});

test('Errores: una query sin argumento requerido produce errores', async () => {
  const result = await run('{ user { name } }');
  assert.ok(result.errors, 'debe haber errores por falta de argumento id');
});
