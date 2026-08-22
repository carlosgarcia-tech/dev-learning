# Ejercicio 01 - Definir un type básico

- **Nivel:** 1/5
- **Tema:** Fundamentos de GraphQL
- **Tiempo estimado:** 15 minutos

## Enunciado

Define en `schema.graphql` un tipo de objeto `User` con los campos básicos de un usuario y el tipo raíz `Query` con una operación `me` que devuelva el usuario actual.

El tipo `User` debe tener:

- `id` de tipo `ID!`
- `name` de tipo `String!`
- `email` de tipo `String`
- `age` de tipo `Int`

La `Query` debe exponer:

- `me` de tipo `User!`

## Requisitos

- [ ] El archivo `schema.graphql` existe y define `type User`.
- [ ] `User` tiene los campos `id`, `name`, `email`, `age` con los tipos correctos.
- [ ] `id` y `name` son non-null (`!`).
- [ ] `email` y `age` son nullable.
- [ ] Se define `type Query` con el campo `me: User!`.
- [ ] La query en `query.graphql` pide `id`, `name` y `email` de `me`.
- [ ] `expected.json` contiene la respuesta esperada.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La sintaxis de un object type es `type Nombre { campo: Tipo }`.
- `!` después del tipo significa non-null.
- El tipo raíz `Query` es obligatorio; sin él el schema no es válido.
- Un campo nullable simplemente no lleva `!`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**schema.graphql**

```graphql
type User {
  id: ID!
  name: String!
  email: String
  age: Int
}

type Query {
  me: User!
}
```

**query.graphql**

```graphql
query {
  me {
    id
    name
    email
  }
}
```

**expected.json**

```json
{
  "data": {
    "me": {
      "id": "1",
      "name": "Ana",
      "email": "ana@x.com"
    }
  }
}
```

</details>
