# Ejercicio 06 - Introspection

- **Nivel:** 1/5
- **Tema:** Fundamentos de GraphQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Escribe en `query.graphql` una query de **introspection** que obtenga el nombre y el tipo (`kind`) de todos los tipos del schema usando `__schema`, y otra que obtenga los campos del tipo `User` usando `__type`.

## Requisitos

- [ ] La query usa `__schema` para listar tipos (`types { name kind }`).
- [ ] La query usa `__type(name: "User")` para ver los campos de `User`.
- [ ] En `__type` se pide `name` y `fields { name }`.
- [ ] `expected.json` contiene una estructura de respuesta de ejemplo.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `__schema` es el punto de entrada para introspection global.
- `__type(name: "User")` permite inspeccionar un tipo concreto.
- Los campos de introspection son campos normales: se seleccionan como cualquier otro.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**query.graphql**

```graphql
query {
  __schema {
    types {
      name
      kind
    }
  }
  userType: __type(name: "User") {
    name
    fields {
      name
    }
  }
}
```

**expected.json**

```json
{
  "data": {
    "__schema": {
      "types": [
        { "name": "User", "kind": "OBJECT" },
        { "name": "Query", "kind": "OBJECT" },
        { "name": "String", "kind": "SCALAR" },
        { "name": "ID", "kind": "SCALAR" }
      ]
    },
    "userType": {
      "name": "User",
      "fields": [
        { "name": "id" },
        { "name": "name" },
        { "name": "email" }
      ]
    }
  }
}
```

</details>
