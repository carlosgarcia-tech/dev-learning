# 03 — Tarea compuesta

## Enunciado

Crea una tarea que depende de otras.

## Requisitos

1. En `solucion/.vscode/tasks.json`, crea una tarea `ci` que depende de `lint`, `test` y `build`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "version": "2.0.0",
  "tasks": [
    { "label": "ci", "dependsOn": ["lint", "test", "build"] },
    { "label": "lint", "type": "shell", "command": "pnpm run lint" },
    { "label": "test", "type": "shell", "command": "pnpm test" },
    { "label": "build", "type": "shell", "command": "pnpm run build" }
  ]
}
```

</details>
