# 05 — Debug Python

## Enunciado

Configura el debug para Python.

## Requisitos

1. Crea `solucion/.vscode/launch.json` con una configuración para debug Python del archivo actual.
2. Usa `type: "debugpy"` y `request: "launch"`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "debugpy",
      "request": "launch",
      "program": "${file}"
    }
  ]
}
```

</details>
