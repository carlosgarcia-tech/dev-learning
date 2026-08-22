# Ejercicio 05 - Variables

- **Nivel:** 1/5
- **Tema:** Fundamentos de GraphQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Escribe en `query.graphql` una operación nombrada `GetUser` que reciba una variable `$userId` de tipo `ID!` y la use como argumento de `user(id: $userId)`. Selecciona `id`, `name` y `email`.

Además, escribe en `variables.json` el valor de la variable (`"userId": "1"`).

## Requisitos

- [ ] La operación se declara como `query GetUser($userId: ID!)`.
- [ ] Se usa `$userId` como argumento del campo `user`.
- [ ] Se seleccionan `id`, `name` y `email`.
- [ ] `variables.json` contiene `{" "userId": "1" }`.
- [ ] `expected.json` tiene la respuesta esperada.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Las variables se declaran en la cabecera de la operación: `query Nombre($var: Tipo!)`.
- Se usan con `$` dentro de la query: `user(id: $userId)`.
- Las variables se envían en un objeto JSON aparte, no interpoladas en el string.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**query.graphql**

```graphql
query GetUser($userId: ID!) {
  user(id: $userId) {
    id
    name
    email
  }
}
```

**variables.json**

```json
{ "userId": "1" }
```

**expected.json**

```json
{
  "data": {
    "user": { "id": "1", "name": "Ana", "email": "ana@x.com" }
  }
}
```

</details>
