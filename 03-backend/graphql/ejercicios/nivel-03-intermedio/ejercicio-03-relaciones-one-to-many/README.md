# Ejercicio 03 - Relaciones one-to-many

- **Nivel:** 3/5
- **Tema:** Schema y Tipos
- **Tiempo estimado:** 30 minutos

## Enunciado

Modela una relación **one-to-many** entre `User` y `Post`: un usuario tiene muchos posts, y un post pertenece a un usuario. Escribe una query que recorra la relación en ambos sentidos: de usuario a posts y de post a autor.

## Requisitos

- [ ] `User` tiene `posts: [Post!]!`.
- [ ] `Post` tiene `author: User!`.
- [ ] `type Query` define `user(id: ID!): User` y `post(id: ID!): Post`.
- [ ] La query pide un usuario, sus posts, y de cada post su author (cierra el ciclo).
- [ ] La query también pide un post y su autor.
- [ ] `expected.json` tiene una respuesta de ejemplo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En one-to-many, el lado "many" tiene una lista: `posts: [Post!]!`.
- El lado "one" tiene una referencia: `author: User!`.
- GraphQL permite recorrer el grafo en cualquier dirección, incluso en ciclos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  name: String!
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  body: String!
  author: User!
}

type Query {
  user(id: ID!): User
  post(id: ID!): Post
}
```

**query.graphql**

```graphql
query {
  user(id: "1") {
    id
    name
    posts {
      id
      title
      author {
        name
      }
    }
  }
  post(id: "10") {
    id
    title
    author {
      id
      name
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "user": {
      "id": "1",
      "name": "Ana",
      "posts": [
        { "id": "10", "title": "Hola", "author": { "name": "Ana" } }
      ]
    },
    "post": {
      "id": "10",
      "title": "Hola",
      "author": { "id": "1", "name": "Ana" }
    }
  }
}
```

</details>
