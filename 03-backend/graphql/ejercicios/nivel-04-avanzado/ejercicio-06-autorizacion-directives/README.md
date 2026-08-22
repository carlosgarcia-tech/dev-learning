# Ejercicio 06 - Autorización por campo con directives

- **Nivel:** 4/5
- **Tema:** Resolvers y DataSources
- **Tiempo estimado:** 35 minutos

## Enunciado

Implementa **autorización por campo** usando una directive `@auth(requires: Role)`. La directive envuelve el resolver del campo y lanza `FORBIDDEN` si el usuario del context no tiene el rol requerido. Esto evita repetir guardas en cada resolver.

## Requisitos

- [ ] `schema.graphql` declara `directive @auth(requires: Role!) on FIELD_DEFINITION`.
- [ ] Se define `enum Role { USER ADMIN }`.
- [ ] `Query.me` tiene `@auth(requires: USER)`.
- [ ] `Query.allUsers` tiene `@auth(requires: ADMIN)`.
- [ ] `User.email` tiene `@auth(requires: USER)` (autorización a nivel campo).
- [ ] `directives.js` exporta la implementación de la directive `AuthDirective`.
- [ ] La implementación comprueba `context.user` y su rol.
- [ ] `query.graphql` pide `allUsers { id name email }`.
- [ ] `expected.json` tiene un ejemplo de error `FORBIDDEN`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una directive se declara en SDL con `directive @name(args) on LOCATION`.
- `FIELD_DEFINITION` significa que se aplica a campos del schema.
- La implementación envuelve el resolver original: si no hay permiso, lanza error; si lo hay, llama al original.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
directive @auth(requires: Role!) on FIELD_DEFINITION

enum Role {
  USER
  ADMIN
}

type User {
  id: ID!
  name: String!
  email: String @auth(requires: USER)
}

type Query {
  me: User! @auth(requires: USER)
  allUsers: [User!]! @auth(requires: ADMIN)
}
```

**directives.js**

```js
const { SchemaDirectiveVisitor } = require('@graphql-tools/utils');
const { GraphQLError } = require('graphql');

function hasRole(user, role) {
  if (!user) return false;
  if (role === 'USER') return true;
  return user.role === 'ADMIN';
}

class AuthDirective extends SchemaDirectiveVisitor {
  visitFieldDefinition(field) {
    const requiredRole = this.args.requires;
    const originalResolver = field.resolve;

    field.resolve = async (parent, args, context, info) => {
      if (!context.user) {
        throw new GraphQLError('No autenticado', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      if (!hasRole(context.user, requiredRole)) {
        throw new GraphQLError('No autorizado', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      return originalResolver
        ? originalResolver(parent, args, context, info)
        : parent[field.name];
    };
  }
}

module.exports = { AuthDirective, hasRole };
```

**query.graphql**

```graphql
query {
  allUsers {
    id
    name
    email
  }
}
```

**expected.json**

```json
{
  "data": null,
  "errors": [
    {
      "message": "No autorizado",
      "extensions": { "code": "FORBIDDEN" }
    }
  ]
}
```

</details>
