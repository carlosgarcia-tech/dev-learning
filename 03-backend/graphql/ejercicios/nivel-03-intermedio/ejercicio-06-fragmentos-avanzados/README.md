# Ejercicio 06 - Fragmentos avanzados

- **Nivel:** 3/5
- **Tema:** Queries y Mutations
- **Tiempo estimado:** 30 minutos

## Enunciado

Escribe una query que use **directives** (`@include` y `@skip`) controladas por variables, y combine **fragments nombrados** con **inline fragments** sobre una interface. El schema define una interface `Entity` implementada por `User` y `Post`.

## Requisitos

- [ ] La query declara variables `$withEmail: Boolean!` y `$skipPosts: Boolean!`.
- [ ] Se usa `@include(if: $withEmail)` en el campo `email`.
- [ ] Se usa `@skip(if: $skipPosts)` en el campo `posts`.
- [ ] Se define un fragment `EntityFields on Entity` con `id` y `createdAt`.
- [ ] Se usan inline fragments `... on User` y `... on Post`.
- [ ] `variables.json` define los valores de las variables.
- [ ] `expected.json` tiene una respuesta de ejemplo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `@include(if: $var)` incluye el campo solo si la variable es true.
- `@skip(if: $var)` omite el campo si la variable es true.
- Un fragment sobre una interface se aplica a cualquier type que la implemente.
- Los fragments nombrados e inline se pueden combinar en la misma selección.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**query.graphql**

```graphql
fragment EntityFields on Entity {
  id
  createdAt
}

query GetEntity(
  $id: ID!
  $withEmail: Boolean!
  $skipPosts: Boolean!
) {
  entity(id: $id) {
    ...EntityFields
    ... on User {
      name
      email @include(if: $withEmail)
      posts @skip(if: $skipPosts) {
        title
      }
    }
    ... on Post {
      title
      body
    }
  }
}
```

**variables.json**

```json
{
  "id": "1",
  "withEmail": true,
  "skipPosts": false
}
```

**expected.json**

```json
{
  "data": {
    "entity": {
      "id": "1",
      "createdAt": "2024-01-01T00:00:00Z",
      "name": "Ana",
      "email": "ana@x.com",
      "posts": [
        { "title": "Hola" }
      ]
    }
  }
}
```

</details>
