# Ejercicio 02 - Query simple con selección de campos

- **Nivel:** 1/5
- **Tema:** Fundamentos de GraphQL
- **Tiempo estimado:** 15 minutos

## Enunciado

Escribe en `query.graphql` una query que obtenga el `id` y el `title` de un post concreto y el `name` de su autor. El campo raíz es `post(id: ID!): Post`, y `Post` tiene una relación `author: User`.

El schema ya está definido en `schema.graphql`. Solo debes escribir la query en `query.graphql` y la respuesta esperada en `expected.json`.

## Requisitos

- [ ] La query usa el campo raíz `post` con el argumento `id`.
- [ ] La query selecciona `id` y `title` del post.
- [ ] La query selecciona `name` del autor anidado (`author { name }`).
- [ ] `expected.json` contiene la estructura de respuesta esperada.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La selección de campos anidados es la esencia de GraphQL: `author { name }`.
- El argumento del post se pasa entre paréntesis: `post(id: "1")`.
- La respuesta tiene la misma forma que la query.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**query.graphql**

```graphql
query {
  post(id: "1") {
    id
    title
    author {
      name
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "post": {
      "id": "1",
      "title": "Hola GraphQL",
      "author": {
        "name": "Ana"
      }
    }
  }
}
```

</details>
