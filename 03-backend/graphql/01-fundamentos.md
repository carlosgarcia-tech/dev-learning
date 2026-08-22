# 01 — Fundamentos de GraphQL

> Qué es GraphQL, cómo se compara con REST, el sistema de tipos, las consultas básicas y el endpoint único.

## Objetivos

- [ ] Explicar qué es GraphQL y qué problema resuelve.
- [ ] Comparar REST y GraphQL (ventajas y desventajas).
- [ ] Identificar over-fetching y under-fetching.
- [ ] Entender el concepto de schema y type system.
- [ ] Escribir una query básica con fields y arguments.
- [ ] Usar introspection para explorar un schema.
- [ ] Entender el concepto de endpoint único `/graphql`.

## 1. Qué es GraphQL

GraphQL es un **lenguaje de consultas para APIs** y un runtime en el servidor que ejecuta esas consultas. Fue creado por Facebook en 2012 y liberado como open source en 2015.

La idea central: **el cliente describe exactamente qué datos necesita** y el servidor devuelve únicamente eso, ni más ni menos. Todo ocurre a través de un único endpoint.

Características clave:

- **Un solo endpoint**: todas las operaciones van a `/graphql`.
- **El cliente decide la forma de la respuesta**: la estructura de la query define la estructura del JSON devuelto.
- **Tipado fuerte**: el schema define qué datos existen y qué operaciones se permiten.
- **Introspectivo**: puedes preguntarle al propio servidor qué schema tiene.
- **Agnóstico de transporte**: aunque casi siempre se usa sobre HTTP/HTTPS, el protocolo no lo impone.

### Arquitectura de alto nivel

```
Cliente  --(query GraphQL sobre HTTP POST)-->  Servidor GraphQL  --(resolvers)-->  Bases de datos, APIs REST, etc.
Cliente  <--(JSON con la forma exacta pedida)--  Servidor GraphQL  <--(datos)--
```

El servidor GraphQL expone un **schema** que describe todos los tipos y operaciones disponibles. Cada campo del schema tiene asociado un **resolver**: una función que sabe cómo obtener ese dato.

## 2. REST vs GraphQL

### Enfoque de REST

En REST típicamente tienes múltiples endpoints, cada uno con una forma de respuesta fija:

```
GET    /api/users/1        → { "id": 1, "name": "Ana", "email": "ana@x.com", "bio": "...", "avatar": "...", "createdAt": "..." }
GET    /api/users/1/posts   → [ { "id": 10, "title": "...", "body": "...", "authorId": 1, ... } ]
GET    /api/posts/10/comments → [ ... ]
```

Problemas clásicos de REST:

- **Over-fetching**: `GET /api/users/1` devuelve `bio`, `avatar`, `createdAt` aunque solo necesites `name`.
- **Under-fetching**: para mostrar un usuario con sus posts y comentarios necesitas 3 peticiones.
- **Versionado**: `v1`, `v2`, breaking changes difíciles de gestionar.

### Enfoque de GraphQL

Una sola petición pide exactamente lo necesario:

```graphql
query {
  user(id: 1) {
    name
    posts {
      title
      comments {
        text
      }
    }
  }
}
```

Respuesta:

```json
{
  "data": {
    "user": {
      "name": "Ana",
      "posts": [
        { "title": "Hola mundo", "comments": [ { "text": "Genial" } ] }
      ]
    }
  }
}
```

### Tabla comparativa

| Aspecto | REST | GraphQL |
|---|---|---|
| Endpoints | Múltiples (`/users`, `/posts`) | Uno solo (`/graphql`) |
| Forma de la respuesta | La define el servidor | La define el cliente |
| Over-fetching | Frecuente | Se evita |
| Under-fetching | Frecuente (varias peticiones) | Se evita (una petición, datos anidados) |
| Versionado | `v1`, `v2` | Schema evolutivo (campos deprecated) |
| Tipado | Opcional (OpenAPI) | Obligatorio (schema) |
| Caching | HTTP (GET, ETag, Cache-Control) | Más complejo (persisted queries, Apollo) |
| Errores | HTTP status codes | Siempre HTTP 200 + array `errors` |
| Curva de aprendizaje | Baja | Media-alta |
| Operaciones | GET/POST/PUT/DELETE | query / mutation / subscription |
| Anidamiento de datos | Requiere múltiples llamadas o endpoints específicos | Nativo |
| Archivos/binarios | Directo | Complicado (URLs o multipart) |

### Cuándo NO usar GraphQL

- Si tu app solo necesita recursos simples y planos con buen cache HTTP.
- Si el caching HTTP nativo de REST es crítico.
- Si tu equipo no quiere mantener un schema y resolvers.
- Si necesitas streaming de binarios o archivos grandes.

## 3. Over-fetching y Under-fetching

Son los dos problemas concretos que GraphQL resuelve.

### Over-fetching

El servidor devuelve más datos de los que el cliente necesita.

Ejemplo REST:

```
GET /api/users/1
→ { "id": 1, "name": "Ana", "email": "ana@x.com", "bio": "...", "phone": "...", "address": "...", "avatar": "...", "createdAt": "...", "updatedAt": "..." }
```

Si solo querías `name`, recibiste 7 campos de más. Eso es ancho de banda y procesamiento desperdiciados, especialmente en móvil.

En GraphQL:

```graphql
query { user(id: 1) { name } }
→ { "data": { "user": { "name": "Ana" } } }
```

### Under-fetching

El servidor no devuelve todo lo necesario en una petición, obligando a varias llamadas.

Ejemplo REST: para renderizar una pantalla necesitas el usuario, sus posts y los comentarios de cada post.

```
GET /api/users/1           → usuario
GET /api/users/1/posts      → posts
GET /api/posts/10/comments  → comentarios del post 10
GET /api/posts/11/comments  → comentarios del post 11
...
```

Esto genera latencia (cada petión es un round-trip) y complejidad en el cliente. En GraphQL se hace en una sola petición con datos anidados.

## 4. Schema y Type System

El **schema** es el contrato del API. Define:

- Qué tipos de objetos existen (`User`, `Post`, `Comment`).
- Qué campos tiene cada tipo.
- Qué operaciones se permiten (`Query`, `Mutation`, `Subscription`).

El schema se escribe en **SDL** (Schema Definition Language), un lenguaje declarativo.

### Scalar types

GraphQL incluye estos escalares por defecto:

| Escalar | Descripción | Ejemplo |
|---|---|---|
| `Int` | Entero de 32 bits | `42` |
| `Float` | Número de coma flotante de doble precisión | `3.14` |
| `String` | Cadena UTF-8 | `"hola"` |
| `Boolean` | Verdadero o falso | `true` |
| `ID` | Identificador único (se serializa como string) | `"123"` |

> Nota: GraphQL no tiene tipo `Date` nativo. Se usa un custom scalar (por ejemplo `DateTime`).

### Object types

Un tipo de objeto define un conjunto de campos:

```graphql
type User {
  id: ID!
  name: String!
  email: String
  age: Int
  isActive: Boolean!
  posts: [Post!]!
}
```

Símbolos clave:

- `!` → el campo es **non-null** (no puede ser `null`).
- `[Type]` → lista que admite valores `null` y elementos `null`.
- `[Type!]` → lista que admite ser `null`, pero sus elementos no.
- `[Type!]!` → lista non-null con elementos non-null.

### type Query, Mutation, Subscription

Los tipos especiales de punto de entrada:

```graphql
type Query {
  user(id: ID!): User
  users(limit: Int = 10): [User!]!
  post(id: ID!): Post
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
}

type Subscription {
  postAdded: Post!
  userUpdated(id: ID!): User!
}
```

- **Query**: lectura de datos (equivale a GET en REST). Debe ser idempotente y sin side effects.
- **Mutation**: escritura de datos (equivale a POST/PUT/DELETE). Debe tener side effects.
- **Subscription**: recepción de datos en tiempo real vía WebSocket. El cliente se suscribe y recibe actualizaciones cuando ocurre un evento.

## 5. Query básica: fields y arguments

### Fields

Una query pide campos. La respuesta tiene la misma forma:

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
{
  "data": {
    "user": {
      "id": "1",
      "name": "Ana",
      "email": "ana@x.com"
    }
  }
}
```

### Arguments

Los campos pueden aceptar argumentos. Se definen en el schema y se pasan en la query:

```graphql
# Schema
type Query {
  user(id: ID!): User
  posts(limit: Int, offset: Int): [Post!]!
}
```

```graphql
# Query
query {
  user(id: "42") {
    name
  }
  posts(limit: 5, offset: 10) {
    title
  }
}
```

### Campos anidados (nested fields)

La potencia de GraphQL está en recorrer relaciones:

```graphql
query {
  user(id: "1") {
    name
    posts {
      title
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

El servidor resuelve cada nivel con sus resolvers. El cliente no sabe (ni necesita saber) de dónde vienen los datos: SQL, REST, memoria, etc.

## 6. Introspection

GraphQL puede describirse a sí mismo. La introspection permite al cliente preguntar al servidor qué tipos, campos y operaciones existen. Es lo que usan herramientas como GraphiQL o Apollo Studio para ofrecer autocompletado.

### Listar todos los tipos

```graphql
query {
  __schema {
    types {
      name
      kind
    }
  }
}
```

### Ver campos de un tipo

```graphql
query {
  __type(name: "User") {
    name
    fields {
      name
      type {
        name
        kind
      }
    }
  }
}
```

### Ver las queries disponibles

```graphql
query {
  __schema {
    queryType {
      fields {
        name
      }
    }
  }
}
```

> En producción, la introspection se suele deshabilitar por seguridad (para no exponer el schema a atacantes).

## 7. El endpoint único `/graphql`

A diferencia de REST, GraphQL expone **un solo endpoint** (normalmente `POST /graphql`). La operación (query, mutation o subscription) va en el cuerpo de la petición.

### Petición HTTP típica

```http
POST /graphql HTTP/1.1
Content-Type: application/json

{
  "query": "query GetUser($id: ID!) { user(id: $id) { id name email } }",
  "variables": { "id": "1" },
  "operationName": "GetUser"
}
```

- `query`: la operación GraphQL como string.
- `variables`: objeto JSON con las variables usadas en la query.
- `operationName`: nombre de la operación (necesario si hay varias en el documento).

### Respuesta

```json
{
  "data": {
    "user": { "id": "1", "name": "Ana", "email": "ana@x.com" }
  }
}
```

Si hay errores, el HTTP status suele seguir siendo 200 (por convención GraphQL) y se añade un array `errors`:

```json
{
  "data": null,
  "errors": [
    {
      "message": "User not found",
      "path": ["user"],
      "extensions": { "code": "NOT_FOUND" }
    }
  ]
}
```

> Convención importante: GraphQL usa POST para casi todo, incluso para queries de lectura. Algunas implementaciones permiten GET para queries cacheables.

## Conceptos clave

- **GraphQL** es un lenguaje de consultas y un runtime del lado del servidor.
- **Endpoint único**: todo va a `/graphql`, normalmente con `POST`.
- **El cliente define la forma de la respuesta** seleccionando campos.
- **Schema en SDL**: el contrato tipado entre cliente y servidor.
- **Escalares nativos**: `Int`, `Float`, `String`, `Boolean`, `ID`.
- **Tipos de entrada**: `Query` (lectura), `Mutation` (escritura), `Subscription` (tiempo real).
- **`!` = non-null**, `[]` = lista; se pueden combinar.
- **Introspection**: el schema puede consultarse a sí mismo (`__schema`, `__type`).
- **Over-fetching y under-fetching**: los dos problemas que GraphQL resuelve frente a REST.
- **Resolvers**: funciones que obtienen el valor de cada campo.

## Errores comunes

- **Confundir query con endpoint**: en GraphQL no hay `/users` ni `/posts`. Hay un solo endpoint y la query define qué datos quieres.
- **Olvidar el `!`**: omitir non-null hace que campos obligatorios puedan ser `null` en tiempo de ejecución, causando bugs difíciles.
- **Pensar que GraphQL reemplaza la base de datos**: GraphQL no accede a la BD directamente; los resolvers deciden de dónde sacar los datos.
- **No pasar variables correctamente**: las variables van en un objeto JSON aparte, no interpoladas en el string de la query.
- **Esperar status codes HTTP distintos**: GraphQL casi siempre devuelve 200, incluso con errores. Los errores van en el array `errors`.
- **Habilitar introspection en producción**: expone todo el schema. Se debe desactivar salvo en entornos internos.
- **Tratar GraphQL como REST anidado**: no tiene sentido versionar `/graphql/v2`. Se deprecán campos y se añaden nuevos.
- **Olvidar el operationName cuando hay múltiples operaciones**: si envías varias operaciones en un documento, debes indicar cuál ejecutar con `operationName`.
