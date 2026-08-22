# Ejercicio 04 - Depth limiting

- **Nivel:** 5/5
- **Tema:** Producción y Seguridad
- **Tiempo estimado:** 35 minutos

## Enunciado

Implementa **depth limiting** y **rate limiting** en un servidor Apollo. El depth limit evita queries recursivas maliciosas; el rate limit evita abuso por volumen de peticiones.

## Requisitos

- [ ] `schema.graphql` define `User` con `friends: [User!]!` (relación recursiva).
- [ ] `server.js` configura `depthLimit(10)`.
- [ ] `server.js` configura rate limiting con `express-rate-limit`.
- [ ] El rate limit permite 100 peticiones por minuto.
- [ ] `query.graphql` tiene una query válida de profundidad moderada.
- [ ] `evil-query.graphql` tiene una query maliciosa profunda (para documentar el ataque).
- [ ] `expected.json` tiene la respuesta de la query válida.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El depth limit cuenta niveles de anidamiento y rechaza si supera el máximo.
- Una query maliciosa anida `friends { friends { friends { ... } } }` muchas veces.
- Rate limiting se aplica a nivel de middleware HTTP, no de GraphQL.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  name: String!
  friends: [User!]!
}

type Query {
  user(id: ID!): User
}
```

**server.js**

```js
const express = require('express');
const cors = require('cors');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const depthLimit = require('graphql-depth-limit').default;
const rateLimit = require('express-rate-limit');

const typeDefs = require('./schema.graphql');
const resolvers = require('./resolvers.js');

const app = express();
app.use(cors());
app.use(express.json());

// Rate limiting: 100 peticiones por minuto por IP
const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 100,
  message: 'Demasiadas peticiones, intenta más tarde',
});

const server = new ApolloServer({
  typeDefs,
  resolvers,
  validationRules: [depthLimit(10)], // máximo 10 niveles
});

async function start() {
  await server.start();
  app.use('/graphql', limiter, expressMiddleware(server));
  app.listen(4000, () => console.log('🚀 Server en http://localhost:4000/graphql'));
}

start();
```

**query.graphql**

```graphql
query {
  user(id: "1") {
    name
    friends {
      name
    }
  }
}
```

**evil-query.graphql**

```graphql
# Query maliciosa: profundidad excesiva
query {
  user(id: "1") {
    friends {
      friends {
        friends {
          friends {
            friends {
              friends {
                friends {
                  friends {
                    friends {
                      friends {
                        friends {
                          name
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "user": {
      "name": "Ana",
      "friends": [
        { "name": "Luis" }
      ]
    }
  }
}
```

</details>
