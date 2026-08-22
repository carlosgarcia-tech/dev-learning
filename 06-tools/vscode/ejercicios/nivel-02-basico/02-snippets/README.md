# 02 — Custom snippets

## Enunciado

Crea un snippet personalizado.

## Requisitos

1. Crea `solucion/javascript.json` (archivo de snippets).
2. Define un snippet con prefix `clg` que inserte `console.log()`.
3. El cursor debe quedar dentro de los paréntesis.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "Console log": {
    "prefix": "clg",
    "body": ["console.log($1);"],
    "description": "Log rápido"
  }
}
```

</details>
