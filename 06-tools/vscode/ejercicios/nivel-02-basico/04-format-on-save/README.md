# 04 — Format on save

## Enunciado

Configura el formateo automático al guardar.

## Requisitos

1. En `solucion/settings.json`, activa `editor.formatOnSave: true`.
2. Configura `esbenp.prettier-vscode` como formateador por defecto para JavaScript.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "editor.formatOnSave": true,
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

</details>
