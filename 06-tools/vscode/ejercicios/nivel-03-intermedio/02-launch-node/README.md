# 02 — launch.json para Node

## Enunciado

Crea una configuración de debug para Node.js.

## Requisitos

1. Crea `solucion/.vscode/launch.json` con una configuración `launch` para Node.js.
2. El programa debe ser `${workspaceFolder}/app.js`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug app",
      "program": "${workspaceFolder}/app.js"
    }
  ]
}
```

</details>
