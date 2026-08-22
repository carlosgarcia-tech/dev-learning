# 02 — keybindings.json

## Enunciado

Personaliza los atajos de teclado.

## Requisitos

1. Crea `solucion/keybindings.json` con un atajo personalizado que comente la línea con `Ctrl+Shift+A`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
[
  {
    "key": "ctrl+shift+a",
    "command": "editor.action.commentLine",
    "when": "editorTextFocus"
  }
]
```

</details>
