# 06 — Configuración por lenguaje

## Enunciado

Configura VS Code de forma distinta según el lenguaje.

## Requisitos

1. En `solucion/settings.json`, define configuración específica para Python (tabSize 4) y JavaScript (tabSize 2).

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "[python]": {
    "editor.tabSize": 4
  },
  "[javascript]": {
    "editor.tabSize": 2
  }
}
```

</details>
