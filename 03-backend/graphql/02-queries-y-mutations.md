# 02 — Queries y Mutations

> Selección de campos, campos anidados, aliases, fragments, variables, directives, mutations, input types, paginación, errores y nullabilidad.

## Objetivos

- [ ] Seleccionar campos y recorrer campos anidados.
- [ ] Usar aliases para renombrar campos en la respuesta.
- [ ] Reutilizar selecciones de campos con fragments.
- [ ] Parametrizar queries con variables.
- [ ] Controlar la ejecución con directives (`@include`, `@skip`).
- [ ] Escribir mutations para crear, actualizar y borrar.
- [ ] Definir y usar input types.
- [ ] Entender el paso de argumentos y variables (`$variable`).
- [ ] Nombrar operaciones (`operationName`).
- [ ] Manejar listas y paginación.
- [ ] Interpretar el array `errors`.
- [ ] Dominar la nullabilidad (`String`, `String!`, `[String]`, `[String!]`).

## 1. Field selection

En GraphQL, cada query es un conjunto de campos seleccionados. La respuesta espeja exactamente esa selección:

```graphql
query {
  user(id: "1") {
    id
    name
    email
  }
}
```

```json
{ "data": { "user": { "id": "1", "name": "Ana", "email": "ana@x.com" } } }
```

No puedes pedir campos que no existan en el schema. Si lo haces, recibes un error de validación antes de ejecutarse nada.

### Selección de campos escalares

Solo escalares (hojas del grafo) producen valores finales. Si pides un campo de objeto, **debes** seleccionar subcampos:

```graphql
# ✅ correcto
query { user(id: "1") { name } }

# ❌ inválido: 'posts' es un tipo objeto, hay que seleccionar subcampos
query { user(id: "1") { posts } }
```

## 2. Nested fields

La potencia de GraphQL: recorrer relaciones en una sola petición:

```graphql
query {
  user(id: "1") {
    name
    posts {
      title
      createdAt
      tags {
        name
      }
      comments {
        text
        author {
          name
        }
      }
    }
  }
}
```

El cliente no necesita saber de dónde viene cada dato. Cada nivel puede resolverse desde una fuente distinta (SQL, REST, caché en memoria).

## 3. Aliases

GraphQL requiere que las claves del objeto raíz sean únicas. Si quieres pedir el mismo campo dos veces con distintos argumentos, necesitas aliases:

```graphql
query {
  ana: user(id: "1") {
    name
  }
  luis: user(id: "2") {
    name
  }
}
```

```json
{
  "data": {
    "ana": { "name": "Ana" },
    "luis": { "name": "Luis" }
  }
}
```

Los aliases también sirven para renombrar campos en la respuesta y hacerla más legible o compatible con el código cliente.

## 4. Fragments

Un **fragment** es una pieza reutilizable de selección de campos. Se define con `fragment Nombre on Tipo`:

```graphql
fragment UserFields on User {
  id
  name
  email
  avatarUrl
}

query {
  user(id: "1") { ...UserFields }
  users { ...UserFields }
}
```

### Fragments anidados

Los fragments pueden incluir otros fragments:

```graphql
fragment PostSummary on Post {
  id
  title
  createdAt
}

fragment UserWithPosts on User {
  ...UserFields
  posts(last: 3) {
    ...PostSummary
  }
}
```

### Fragments inline

Cuando no quieres definir un fragment con nombre, puedes usar un inline fragment (útil con interfaces y unions):

```graphql
query {
  search(term: "ana") {
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

## 5. Variables

Las variables permiten parametrizar queries sin reescribirlas. Se definen en la firma de la operación y se pasan en un objeto JSON aparte.

```graphql
query GetUser($id: ID!, $withPosts: Boolean!) {
  user(id: $id) {
    name
    posts @include(if: $withPosts) {
      title
    }
  }
}
```

Variables JSON:

```json
{ "id": "1", "withPosts": true }
```

Reglas de las variables:

- Se declaran en la operación: `$id: ID!`.
- Van en un objeto aparte `"variables": { ... }`.
- Pueden tener valor por defecto: `$limit: Int = 10`.
- Deben ser de un tipo de entrada (scalar, enum, input type). No se pueden pasar tipos de objeto como variable para construir datos; para eso existen los **input types**.
- Son nullables o non-null como cualquier campo: `$id: ID!` obliga a pasar valor.

### Valores por defecto

```graphql
query Posts($limit: Int = 10, $offset: Int = 0) {
  posts(limit: $limit, offset: $offset) { title }
}
```

Si no se pasa `limit`, se usa `10`.

## 6. Directives

Las directives empiezan con `@` y modifican la ejecución de una query. GraphQL incluye dos por defecto:

### `@include(if: Boolean)`

Incluye el campo **solo si** la condición es verdadera:

```graphql
query User($withEmail: Boolean!) {
  user(id: "1") {
    name
    email @include(if: $withEmail)
  }
}
```

### `@skip(if: Boolean)`

Omite el campo **si** la condición es verdadera:

```graphql
query User($hideEmail: Boolean!) {
  user(id: "1") {
    name
    email @skip(if: $hideEmail)
  }
}
```

> `@include(if: x)` y `@skip(if: !x)` son equivalentes.

### Directives personalizadas

El schema puede declarar sus propias directives (útiles en el servidor y en herramientas como codegen):

```graphql
directive @auth(requires: String!) on FIELD_DEFINITION

type Query {
  me: User! @auth(requires: "user")
}
```

## 7. Mutations

Las mutations modifican datos. Tienen side effects (crear, actualizar, borrar). Se definen en `type Mutation`:

```graphql
type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
  addComment(input: AddCommentInput!): Comment!
}
```

### Crear

```graphql
mutation {
  createUser(input: { name: "Ana", email: "ana@x.com" }) {
    id
    name
    createdAt
  }
}
```

### Actualizar

```graphql
mutation {
  updateUser(id: "1", input: { name: "Ana García" }) {
    id
    name
    updatedAt
  }
}
```

### Borrar

```graphql
mutation {
  deleteUser(id: "1")
}
```

### Retornar el objeto mutado

Buena práctica: tras mutar, devolver el objeto afectado para que el cliente actualice su caché:

```graphql
mutation {
  updateUser(id: "1", input: { name: "Ana García" }) {
    id
    name
    updatedAt
  }
}
```

## 8. Input types

Los input types permiten pasar objetos estructurados como argumentos. Se definen con `input` (no `type`):

```graphql
input CreateUserInput {
  name: String!
  email: String!
  age: Int
  role: Role = USER
}

input UpdateUserInput {
  name: String
  email: String
  age: Int
}

enum Role {
  USER
  ADMIN
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
}
```

Uso:

```graphql
mutation {
  createUser(input: {
    name: "Ana"
    email: "ana@x.com"
    age: 30
    role: ADMIN
  }) {
    id
    name
  }
}
```

Diferencias clave entre `type` y `input`:

- `type` define tipos de salida (lo que se devuelve).
- `input` define tipos de entrada (lo que se recibe como argumento).
- Los inputs no pueden tener argumentos en sus campos, los types sí.
- Los inputs pueden anidarse: un input puede tener campos de otro input type.

## 9. Argumentos y variables (`$variable`)

Los argumentos se pasan a los campos; las variables se pasan a la operación. Se conectan así:

```graphql
query ($id: ID!) {            # declara variable
  user(id: $id) {             # usa variable como argumento
    name
  }
}
```

JSON:

```json
{ "id": "1" }
```

Se pueden mezclar literales y variables:

```graphql
query ($id: ID!) {
  user(id: $id) {
    name
    posts(limit: 5) {          # literal
      title
    }
  }
}
```

## 10. Operation names

Nombrar operaciones mejora legibilidad, debugging y trazabilidad (logs, métricas):

```graphql
query GetUserWithPosts($id: ID!) {
  user(id: $id) {
    name
    posts { title }
  }
}
```

- `GetUserWithPosts` es el `operationName`.
- Si el documento tiene una sola operación, el nombre es opcional.
- Si tiene varias, es obligatorio indicar cuál ejecutar enviando `"operationName"` en la petición HTTP.

Petición completa:

```json
{
  "query": "query GetUserWithPosts($id: ID!) { user(id: $id) { name posts { title } } }",
  "variables": { "id": "1" },
  "operationName": "GetUserWithPosts"
}
```

## 11. Listas y paginación

### Listas simples

```graphql
type Query {
  users: [User!]!
  posts(limit: Int, offset: Int): [Post!]!
}
```

```graphql
query { posts(limit: 10, offset: 0) { title } }
```

### Paginación por offset/limit

Simple pero ineficiente con grandes volúmenes y problemática si se insertan datos entre peticiones:

```graphql
query {
  posts(limit: 10, offset: 20) {
    id
    title
  }
}
```

### Paginación por cursor (Relay)

Relay define un patrón de paginación basado en cursores más robusto:

```graphql
type PostConnection {
  edges: [PostEdge!]!
  pageInfo: PageInfo!
}

type PostEdge {
  cursor: String!
  node: Post!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type Query {
  posts(first: Int, after: String, last: Int, before: String): PostConnection!
}
```

Uso:

```graphql
query {
  posts(first: 10, after: "cursorXyz") {
    edges {
      cursor
      node { id title }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

## 12. Errores en GraphQL (`errors` array)

GraphQL no usa status codes HTTP para errores de negocio. La respuesta siempre lleva una clave `data` (puede ser `null`) y, si hubo errores, un array `errors`:

### Error parcial

```json
{
  "data": { "user": null },
  "errors": [
    {
      "message": "User not found",
      "path": ["user"],
      "locations": [{ "line": 2, "column": 3 }],
      "extensions": { "code": "NOT_FOUND" }
    }
  ]
}
```

### Error total

```json
{
  "data": null,
  "errors": [
    { "message": "Unauthorized", "extensions": { "code": "UNAUTHENTICATED" } }
  ]
}
```

### Estructura de un error

| Campo | Descripción |
|---|---|
| `message` | Mensaje legible para el humano |
| `locations` | Línea y columna del documento GraphQL donde ocurrió |
| `path` | Ruta del campo que falló |
| `extensions` | Metadatos opcionales (código de error, timestamp, etc.) |

### Buenas prácticas

- Usar `extensions.code` con códigos estables (`UNAUTHENTICATED`, `FORBIDDEN`, `BAD_USER_INPUT`, `NOT_FOUND`).
- No filtrar `data` entera si solo falló un campo: permite respuestas parciales.
- Capturar errores en resolvers y lanzar `GraphQLError` con código en `extensions`.

## 13. Nullabilidad

La nullabilidad se controla con `!` y `[]`. Es uno de los conceptos más importantes porque afecta a la robustez del contrato.

### Variantes de un campo String

| Tipo | ¿Campo puede ser null? | ¿Lista puede ser null? | ¿Elementos pueden ser null? |
|---|---|---|---|
| `String` | Sí | — | — |
| `String!` | No | — | — |
| `[String]` | Sí | Sí | Sí |
| `[String!]` | Sí | Sí | No |
| `[String!]!` | No | No | No |
| `[String]!` | No | No | Sí |

### Regla de propagación de null

Si un campo non-null devuelve `null` o lanza un error, el null "sube" al padre: este también se convierte en `null`. Si el padre es non-null, sube otro nivel más.

Ejemplo: si `user(id: "1"): User!` (non-null) y el resolver de `user.name: String!` lanza un error, `name` no puede ser null, así que `user` entero se vuelve null y, como era non-null, la query entera falla con `data: null`.

Por eso:

- Usa `!` en campos que realmente son obligatorios (ids, campos invariantes).
- Usa tipos nullable en campos que pueden no aplicarse (`email`, `avatarUrl`, `bio`).
- Listas de resultados de búsqueda suelen ser `[Type!]!`: la lista existe (vacía si no hay), pero cada elemento es non-null.

### Errores parciales con nullabilidad

Gracias a la nullabilidad, GraphQL puede devolver partes de la respuesta aunque un campo falle:

```json
{
  "data": { "user": { "name": "Ana", "email": null } },
  "errors": [
    { "message": "Email unavailable", "path": ["user", "email"] }
  ]
}
```

Si `email: String` (nullable), el resto de `user` se sigue devolviendo.

## Conceptos clave

- **Field selection**: la respuesta espeja los campos pedidos; los escalares son las hojas.
- **Nested fields**: una petición recorre relaciones enteras.
- **Aliases**: renombran campos o permiten pedir el mismo campo con distintos argumentos.
- **Fragments**: selección de campos reutilizable (`fragment X on Type`), también inline (`... on Type`).
- **Variables**: parametrizan la operación; van en un objeto JSON aparte.
- **Directives**: `@include`/`@skip` controlan ejecución; se pueden crear personalizadas.
- **Mutations**: escrituras con side effects; buena práctica devolver el objeto mutado.
- **Input types**: objetos estructurados de entrada (`input` vs `type`).
- **Operation names**: mejoran trazabilidad y son obligatorios con múltiples operaciones.
- **Paginación**: offset/limit (simple) o cursor/Relay (robusto).
- **Errors**: array `errors` con `message`, `path`, `extensions.code`; HTTP suele ser 200.
- **Nullabilidad**: `!` y `[]` combinados; el null se propaga hacia arriba.

## Errores comunes

- **Pedir un objeto sin subcampos**: `user { posts }` es inválido; hay que hacer `user { posts { title } }`.
- **Olvidar aliases al pedir el mismo campo con distintos argumentos**: dos `user(id: ...)` sin alias colisionan.
- **Pasar objetos como variables sin input type**: las variables de objetos complejos requieren un `input` definido en el schema.
- **Tratar mutations como queries**: las mutations tienen side effects y no son idempotentes; no se cachean.
- **Esperar status HTTP 4xx/5xx en errores de negocio**: GraphQL devuelve 200 con array `errors`.
- **Usar `!` en todo**: non-null excesivo hace que un error en un campo tumbe toda la respuesta.
- **No usar `extensions.code`**: el cliente no puede distinguir tipos de error programáticamente.
- **Mezclar `type` y `input`**: no se puede usar un `type` como tipo de argumento de objeto; hay que definir un `input`.
- **Olvidar `operationName` con varias operaciones**: el servidor no sabe cuál ejecutar.
- **No devolver el objeto mutado**: obliga al cliente a hacer otra query para refrescar el dato.
