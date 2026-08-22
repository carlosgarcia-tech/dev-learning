# Ejercicio 03 - Query con argumentos y listas

- **Nivel:** 1/5
- **Tema:** Fundamentos de GraphQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Define en `schema.graphql` un campo `users(limit: Int, offset: Int): [User!]!` en `Query` y escribe en `query.graphql` una consulta que pida los primeros 5 usuarios seleccionando `id` y `name`.

Además, define un campo `posts(limit: Int): [Post!]!` que devuelva los posts con un límite.

## Requisitos

- [ ] `type Query` define `users(limit: Int, offset: Int): [User!]!`.
- [ ] `type Query` define `posts(limit: Int): [Post!]!`.
- [ ] La query pide `users(limit: 5)` seleccionando `id` y `name`.
- [ ] La query pide `posts(limit: 3)` seleccionando `id` y `title`.
- [ ] `expected.json` tiene la estructura de respuesta esperada.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los argumentos se declaran entre paréntesis en el schema: `users(limit: Int, offset: Int): [User!]!`.
- En la query se pasan como literales: `users(limit: 5) { id name }`.
- Una lista non-null de elementos non-null es `[User!]!`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  name: String!
}

type Post {
  id: ID!
  title: String!
}

type Query {
  users(limit: Int, offset: Int): [User!]!
  posts(limit: Int): [Post!]!
}
```

**query.graphql**

```graphql
query {
  users(limit: 5) {
    id
    name
  }
  posts(limit: 3) {
    id
    title
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
    ],
    "posts": [
      { "id": "1", "title": "Hola" },
      { "id": "2", "title": "Mundo" }
    ]
  }
}
```

</details>
