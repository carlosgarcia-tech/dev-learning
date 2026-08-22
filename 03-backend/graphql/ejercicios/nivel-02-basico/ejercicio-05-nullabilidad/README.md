# Ejercicio 05 - Nullabilidad

- **Nivel:** 2/5
- **Tema:** Queries y Mutations
- **Tiempo estimado:** 25 minutos

## Enunciado

Define en `schema.graphql` un tipo `Article` que use las cuatro combinaciones de listas y nullabilidad para el campo `tags`:

- `optionalTags: [String]` — lista nullable con elementos nullables.
- `strictTags: [String!]!` — lista non-null con elementos non-null.
- `listNotNull: [String]!` — lista non-null con elementos nullables.
- `elementsNotNull: [String!]` — lista nullable con elementos non-null.

El objetivo es practicar las cuatro variantes de `[]` + `!`.

## Requisitos

- [ ] Se define `type Article` con `id: ID!` y `title: String!`.
- [ ] `optionalTags: [String]` está definido.
- [ ] `strictTags: [String!]!` está definido.
- [ ] `listNotNull: [String]!` está definido.
- [ ] `elementsNotNull: [String!]` está definido.
- [ ] `type Query` expone `article(id: ID!): Article`.
- [ ] La query pide los cuatro campos de tags.
- [ ] `expected.json` tiene ejemplos de respuesta.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `[String]` admite lista null y elementos null.
- `[String!]` admite lista null pero elementos no-null.
- `[String]!` admite lista no-null pero elementos null.
- `[String!]!` ni lista ni elementos pueden ser null.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type Article {
  id: ID!
  title: String!
  optionalTags: [String]
  strictTags: [String!]!
  listNotNull: [String]!
  elementsNotNull: [String!]
}

type Query {
  article(id: ID!): Article
}
```

**query.graphql**

```graphql
query {
  article(id: "1") {
    id
    title
    optionalTags
    strictTags
    listNotNull
    elementsNotNull
  }
}
```

**expected.json**

```json
{
  "data": {
    "article": {
      "id": "1",
      "title": "Nullabilidad en GraphQL",
      "optionalTags": ["a", null, "b"],
      "strictTags": ["a", "b", "c"],
      "listNotNull": ["a", null],
      "elementsNotNull": ["a", "b"]
    }
  }
}
```

</details>
