# Ejercicio 05 - Query complexity y depth limiting

- **Nivel:** 4/5
- **Tema:** Producción y Seguridad
- **Tiempo estimado:** 40 minutos

## Enunciado

Protege tu servidor GraphQL contra queries maliciosas. Implementa **depth limiting** (máximo 7 niveles) y **query complexity** (presupuesto de 1000) en la configuración de Apollo Server.

Además, define una directive `@complexity(value: Int!, multipliers: [String!])` en el schema para campos costosos.

## Requisitos

- [ ] `schema.graphql` declara `directive @complexity`.
- [ ] `Query.users` tiene `@complexity(value: 5, multipliers: ["limit"])`.
- [ ] `server.js` importa y configura `depthLimit`.
- [ ] `server.js` configura `createComplexityRule` con `maximumComplexity: 1000`.
- [ ] El depth limit está en 7.
- [ ] `query.graphql` tiene una query de ejemplo que pide `users(limit: 10)`.
- [ ] `expected.json` tiene una respuesta de ejemplo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Depth limiting evita queries recursivas profundas: `friends { friends { friends { ... } } }`.
- Query complexity asigna un coste a cada campo; si la suma supera el máximo, se rechaza.
- Ambos se configuran en `validationRules` del ApolloServer.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
directive @complexity(value: Int!, multipliers: [String!]) on FIELD_DEFINITION

type User {
  id: ID!
  name: String!
  friends: [User!]! @complexity(value: 2, multipliers: ["limit"])
}

type Query {
  users(limit: Int = 10): [User!]! @complexity(value: 5, multipliers: ["limit"])
}
```

**server.js**

```js
const { ApolloServer } = require('@apollo/server');
const depthLimit = require('graphql-depth-limit').default;
const {
  createComplexityRule,
  simpleEstimator,
  fieldExtensionsEstimator,
} = require('graphql-query-complexity');

const typeDefs = require('./schema.graphql');
const resolvers = require('./resolvers.js');

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [
    depthLimit(7), // máximo 7 niveles de profundidad
    (requestContext) =>
      createComplexityRule({
        maximumComplexity: 1000,
        variables: requestContext.request.variables,
        estimators: [
          fieldExtensionsEstimator(),
          simpleEstimator({ defaultComplexity: 1 }),
        ],
        onComplete: (complexity) => {
          console.log('Query complexity:', complexity);
        },
      }),
  ],
});

module.exports = { server };
```

**query.graphql**

```graphql
query {
  users(limit: 10) {
    id
    name
  }
}
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
