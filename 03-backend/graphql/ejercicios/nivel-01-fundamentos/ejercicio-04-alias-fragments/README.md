# Ejercicio 04 - Alias y fragments

- **Nivel:** 1/5
- **Tema:** Fundamentos de GraphQL
- **Tiempo estimado:** 20 minutos

## Enunciado

Escribe en `query.graphql` una consulta que pida dos usuarios distintos en la misma petición usando **aliases** (`admin` y `editor`), y reutiliza la selección de campos con un **fragment** llamado `UserFields`.

El schema ya está definido. Debes:

1. Definir un fragment `fragment UserFields on User` con `id`, `name` y `email`.
2. Usar aliases `admin: user(id: "1")` y `editor: user(id: "2")`.
3. Aplicar `...UserFields` en ambos.

## Requisitos

- [ ] Se define un fragment llamado `UserFields` sobre `User`.
- [ ] El fragment incluye `id`, `name` y `email`.
- [ ] La query usa el alias `admin` para `user(id: "1")`.
- [ ] La query usa el alias `editor` para `user(id: "2")`.
- [ ] Ambas selecciones usan `...UserFields`.
- [ ] `expected.json` contiene las dos claves `admin` y `editor`.
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un alias se pone antes del nombre del campo: `admin: user(id: "1")`.
- Un fragment se declara así: `fragment Nombre on Tipo { campos }`.
- Se aplica con `...NombreFragment`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**query.graphql**

```graphql
fragment UserFields on User {
  id
  name
  email
}

query {
  admin: user(id: "1") {
    ...UserFields
  }
  editor: user(id: "2") {
    ...UserFields
  }
}
```

**expected.json**

```json
{
  "data": {
    "admin": { "id": "1", "name": "Ana", "email": "ana@x.com" },
    "editor": { "id": "2", "name": "Luis", "email": "luis@x.com" }
  }
}
```

</details>
