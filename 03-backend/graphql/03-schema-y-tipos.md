# 03 — Schema y Tipos

> El sistema de tipos en profundidad: Object types, Scalar, Enum, Interface, Union, Input type, SDL, custom scalars, relaciones y esquemas modulares.

## Objetivos

- [ ] Dominar el type system completo de GraphQL.
- [ ] Escribir esquemas en SDL correctamente.
- [ ] Diferenciar Object type, Scalar, Enum, Interface, Union e Input type.
- [ ] Crear custom scalars con serialización y validación.
- [ ] Modelar relaciones one-to-one, one-to-many y many-to-many.
- [ ] Entender el data graph y el rol de los resolvers.
- [ ] Componer esquemas modulares con type extensions y merge schemas.
- [ ] Manejar listas y non-null en cualquier combinación.

## 1. El type system

El type system es el corazón de GraphQL. Define qué datos existen, cómo se relacionan y qué operaciones se permiten. Todo se declara en **SDL** (Schema Definition Language).

Un schema mínimo:

```graphql
schema {
  query: Query
  mutation: Mutation
  subscription: Subscription
}

type Query {
  hello: String!
}
```

Normalmente la definición `schema { ... }` se omite si los tipos raíz se llaman `Query`, `Mutation`, `Subscription` (es el default).

## 2. Object types

Un Object type describe una entidad con campos. Cada campo tiene un tipo de retorno y opcionalmente argumentos:

```graphql
type Post {
  id: ID!
  title: String!
  body: String!
  publishedAt: DateTime
  author: User!
  comments(limit: Int = 10): [Comment!]!
  tags: [Tag!]!
}
```

- Los campos pueden devolver escalares, objetos, listas o interfaces/unions.
- Los campos pueden tener argumentos (`comments(limit: Int = 10)`), igual que las funciones.
- Los argumentos pueden tener valores por defecto.

## 3. Scalar types

GraphQL incluye 5 escalares nativos: `Int`, `Float`, `String`, `Boolean`, `ID`.

| Escalar | Descripción |
|---|---|
| `Int` | Entero con signo de 32 bits |
| `Float` | Double IEEE 754 |
| `String` | Secuencia UTF-8 |
| `Boolean` | `true` o `false` |
| `ID` | Identificador; se serializa como string |

`ID` no es más que un string con intención semántica de identificador. Un `ID` puede venir de un entero en la base de datos pero siempre se serializa como string en JSON.

## 4. Custom scalars

GraphQL permite declarar escalares personalizados. En el schema:

```graphql
scalar DateTime
scalar URL
scalar Email
scalar UUID
```

Pero declarar el scalar en SDL no es suficiente: el servidor necesita proveer su lógica de **serialización**, **deserialización** y **validación**. En Apollo Server (Node.js):

```js
const { GraphQLScalarType, Kind } = require('graphql');

const DateTime = new GraphQLScalarType({
  name: 'DateTime',
  description: 'ISO 8601 date string',

  // Valor saliente: del servidor al cliente (objeto Date → string ISO)
  serialize(value) {
    if (value instanceof Date) return value.toISOString();
    return value; // ya es string
  },

  // Valor entrante como variable JSON: cliente → servidor
  parseValue(value) {
    const date = new Date(value);
    if (isNaN(date.getTime())) throw new Error('Invalid DateTime');
    return date;
  },

  // Valor entrante como literal en la query: query { x(date: "2024-01-01") }
  parseLiteral(ast) {
    if (ast.kind !== Kind.STRING) throw new Error('DateTime must be a string');
    const date = new Date(ast.value);
    if (isNaN(date.getTime())) throw new Error('Invalid DateTime literal');
    return date;
  },
});
```

Cuándo crear custom scalars:

- Fechas (`DateTime`): el caso más común, ya que GraphQL no trae tipo fecha.
- Emails, URLs, UUIDs: para validar formato y dar semántica.
- JSON dinámico: `scalar JSON` cuando el contenido es arbitrario (úsalo con cuidado, pierde tipado).

## 5. Enums

Un `enum` define un conjunto cerrado de valores:

```graphql
enum Role {
  USER
  ADMIN
  EDITOR
}

enum PostStatus {
  DRAFT
  PUBLISHED
  ARCHIVED
}

type User {
  id: ID!
  name: String!
  role: Role!
}

type Post {
  status: PostStatus!
}
```

Uso en query:

```graphql
mutation {
  updateUser(id: "1", role: ADMIN) {
    id
    role
  }
}
```

Reglas:

- Los valores de enum son **no acotados por comillas** en GraphQL (son símbolos, no strings).
- En JSON se serializan como strings: `"ADMIN"`.
- Útiles para estados, roles, categorías fijas.

## 6. Interfaces

Una **interface** define un conjunto de campos común que varios types pueden implementar. Es similar a una interfaz en TypeScript/Java.

```graphql
interface Node {
  id: ID!
}

interface Entity {
  id: ID!
  createdAt: DateTime!
  updatedAt: DateTime!
}

type User implements Node & Entity {
  id: ID!
  createdAt: DateTime!
  updatedAt: DateTime!
  name: String!
  email: String!
}

type Post implements Node {
  id: ID!
  title: String!
  body: String!
}
```

Al implementar una interface, el type **debe** incluir todos los campos de la interface.

### Consulta con interfaces

Cuando un campo devuelve una interface, el cliente puede pedir los campos comunes directamente y los específicos con **inline fragments**:

```graphql
query {
  node(id: "1") {
    id
    ... on User {
      name
      email
    }
    ... on Post {
      title
    }
  }
}
```

## 7. Unions

Una **union** permite que un campo devuelva uno de varios tipos sin un campo común obligatorio (a diferencia de la interface). Es como un OR de tipos.

```graphql
union SearchResult = User | Post | Comment

type Query {
  search(term: String!): [SearchResult!]!
}
```

Como los tipos de la union no comparten campos por definición, siempre necesitas inline fragments para acceder a sus campos:

```graphql
query {
  search(term: "ana") {
    ... on User {
      id
      name
    }
    ... on Post {
      id
      title
    }
    ... on Comment {
      id
      text
    }
  }
}
```

Diferencia interface vs union:

| Aspecto | Interface | Union |
|---|---|---|
| Campos comunes | Sí (obligatorios en implementadores) | No |
| Se consulta con | campos comunes + inline fragments | solo inline fragments |
| Cuándo usar | cuando hay un contrato común (`Node`) | cuando los tipos son heterogéneos |
| Implementación | `type X implements I` | `union U = A \| B` |

## 8. Input types

Los input types representan objetos pasados **como argumento**. Se definen con `input`:

```graphql
input PostFilter {
  status: PostStatus
  authorId: ID
  tags: [String!]
  createdAfter: DateTime
}

type Query {
  posts(filter: PostFilter, limit: Int = 20): [Post!]!
}
```

Uso:

```graphql
query ($filter: PostFilter!) {
  posts(filter: $filter, limit: 5) {
    title
  }
}
```

```json
{ "filter": { "status": "PUBLISHED", "tags": ["graphql", "backend"] } }
```

Reglas de input types:

- No pueden tener argumentos en sus campos (a diferencia de los object types).
- Pueden tener valores por defecto.
- Pueden referenciar otros inputs y enums.
- No pueden referenciar object types: el flujo es unidireccional (input = entrada, type = salida).

## 9. SDL (Schema Definition Language)

SDL es la sintaxis declarativa para escribir schemas. Resumen de palabras clave:

| Palabra clave | Para qué |
|---|---|
| `type` | Object type |
| `input` | Input type |
| `interface` | Interface |
| `union` | Union de tipos |
| `enum` | Enumeración |
| `scalar` | Escalar (nativo o custom) |
| `schema` | Definición de tipos raíz |
| `extend type` | Extender un tipo |
| `directive` | Declarar una directive |
| `fragment` | (en queries, no en schema) Fragment |

Ejemplo completo en SDL:

```graphql
scalar DateTime

enum PostStatus { DRAFT PUBLISHED ARCHIVED }

interface Node { id: ID! }

type User implements Node {
  id: ID!
  name: String!
  email: String!
  posts: [Post!]!
}

type Post implements Node {
  id: ID!
  title: String!
  body: String!
  status: PostStatus!
  author: User!
  createdAt: DateTime!
}

input CreatePostInput {
  title: String!
  body: String!
  status: PostStatus = DRAFT
}

type Query {
  user(id: ID!): User
  posts(limit: Int = 10): [Post!]!
  node(id: ID!): Node
}

type Mutation {
  createPost(input: CreatePostInput!): Post!
}
```

## 10. Relaciones entre tipos

El schema define un **data graph**: los tipos se relacionan entre sí y el cliente puede navegarlos.

### One-to-one

```graphql
type User {
  id: ID!
  profile: Profile
}

type Profile {
  id: ID!
  bio: String
  user: User!
}
```

### One-to-many

```graphql
type User {
  posts: [Post!]!       # un usuario tiene muchos posts
}

type Post {
  author: User!          # un post tiene un autor
}
```

### Many-to-many

```graphql
type Post {
  tags: [Tag!]!          # un post tiene muchos tags
}

type Tag {
  posts: [Post!]!        # un tag aparece en muchos posts
}
```

La relación many-to-many se modela con listas en ambos lados. En el resolver de cada lado decides cómo resolver (JOIN en SQL, llamada a API, etc.).

### Relaciones con argumentos

Los campos de relación pueden tener argumentos (paginación, filtrado):

```graphql
type User {
  posts(limit: Int = 10, status: PostStatus): [Post!]!
  postCount: Int!
}
```

## 11. Resolvers y el data graph

El schema declara la forma; los **resolvers** deciden de dónde salen los datos. Cada campo puede tener su propio resolver:

```js
const resolvers = {
  Query: {
    user: (parent, args, context, info) => {
      return context.db.user.findById(args.id);
    },
  },
  User: {
    posts: (user, args, context) => {
      return context.db.post.findMany({ where: { authorId: user.id } });
    },
  },
  Post: {
    author: (post, args, context) => {
      return context.db.user.findById(post.authorId);
    },
  },
};
```

El data graph es **lazy**: si el cliente no pide `posts`, el resolver `User.posts` **no se ejecuta**. Esto es clave para el rendimiento.

## 12. Esquemas modulares: type extensions y merge schemas

En proyectos grandes, mantener todo el schema en un archivo no escala. Hay dos estrategias principales:

### Type extensions (`extend type`)

Divides el schema en módulos y extiendes tipos:

```graphql
# users.graphql
type User {
  id: ID!
  name: String!
  email: String!
}

type Query {
  user(id: ID!): User
}
```

```graphql
# posts.graphql
extend type User {
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
}

extend type Query {
  posts: [Post!]!
}
```

El tipo `User` se define una vez y se extiende en otros módulos. Herramientas como `@graphql-tools/schema` mergean esto automáticamente.

### Merge schemas (schema stitching)

Consiste en combinar múltiples schemas GraphQL en uno solo. Útil para microservicios o para añadir un gateway.

```js
const { mergeSchemas } = require('@graphql-tools/schema');

const schema = mergeSchemas({
  schemas: [usersSchema, postsSchema, commentsSchema],
});
```

Cada sub-schema define sus propios tipos y resolvers. El gateway los une y los clientes ven un solo schema coherente.

### Federation

Apollo Federation es un enfoque más avanzado para microservicios. Cada servicio define su parte del graph y puede extender tipos de otros servicios. Se ve en la guía 05.

## 13. Listas y non-null (combinaciones)

Recordatorio de las combinaciones de `[]` y `!`:

```graphql
type Examples {
  a: [String]      # lista nullable con elementos nullables
  b: [String!]     # lista nullable con elementos non-null
  c: [String]!     # lista non-null con elementos nullables
  d: [String!]!    # lista non-null con elementos non-null
}
```

| Tipo | ¿Lista null? | ¿Elemento null? |
|---|---|---|
| `[String]` | Sí | Sí |
| `[String!]` | Sí | No |
| `[String]!` | No | Sí |
| `[String!]!` | No | No |

Cuál usar:

- **Resultados de lista**: `[Type!]!` (la lista existe, aunque esté vacía; cada elemento es válido).
- **Campos opcionales dentro de objetos**: nullable sin `!`.
- **Ids y claves**: non-null (`ID!`).

## Conceptos clave

- **SDL**: lenguaje declarativo para escribir schemas (`type`, `input`, `interface`, `union`, `enum`, `scalar`).
- **Object types**: entidades con campos; los campos pueden tener argumentos.
- **Escalares**: 5 nativos + custom scalars con `serialize`/`parseValue`/`parseLiteral`.
- **Enums**: conjuntos cerrados de valores.
- **Interfaces**: contrato de campos común; implementado con `implements`.
- **Unions**: OR de tipos sin campos comunes obligatorios.
- **Input types**: objetos de entrada, sin argumentos en sus campos.
- **Custom scalars**: para fechas, emails, URLs, etc.; requieren lógica de validación.
- **Relaciones**: one-to-one, one-to-many, many-to-many; se resuelven con resolvers perezosos.
- **Data graph lazy**: los resolvers solo se ejecutan para los campos pedidos.
- **Esquemas modulares**: `extend type` y merge schemas para proyectos grandes.
- **Listas y non-null**: 4 combinaciones que afectan a la robustez del contrato.

## Errores comunes

- **Usar `type` como argumento**: solo `input` y escalares/enums pueden ser argumentos de objeto.
- **Olvidar implementar los campos de una interface**: el type que implementa una interface debe incluir todos sus campos.
- **Declarar un custom scalar sin su lógica**: `scalar DateTime` en SDL sin `serialize`/`parseValue` no valida ni transforma nada.
- **Modelar many-to-many sin listas en ambos lados**: si olvidas uno de los lados, el cliente no puede navegar en esa dirección.
- **Hacer todos los resolvers eager**: poner lógica pesada en resolvers que se ejecutan siempre, aunque el cliente no pida ese campo.
- **Confundir interface y union**: la interface exige campos comunes; la union no.
- **No poner `!` en elementos de listas de resultados**: `[Type]` permite `null` entre los elementos, lo que rompe iteraciones en el cliente.
- **Extender un tipo que no existe**: `extend type User` falla si `User` no está definido en algún módulo.
- **Sobrecargar el schema con custom scalars innecesarios**: si un `String` basta, no crees `scalar Email` salvo que realmente valides.
