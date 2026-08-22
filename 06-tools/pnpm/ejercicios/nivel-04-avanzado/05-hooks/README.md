# 05 — Hooks pre/post

## Enunciado

Configura hooks pre y post en los scripts.

## Requisitos

1. Define `prebuild`, `build` y `postbuild` en `solucion/package.json`.
2. Cada uno debe imprimir un mensaje distinto.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "scripts": {
    "prebuild": "echo 'Limpiando...'",
    "build": "echo 'Compilando...'",
    "postbuild": "echo 'Listo!'"
  }
}
```

</details>
