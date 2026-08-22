# 04 — Pre y post hooks

## Enunciado

Usa hooks `pre` y `post` para automatizar tareas.

## Requisitos

1. Define un script `build` que imprima "Building...".
2. Define `prebuild` que imprima "Cleaning...".
3. Define `postbuild` que imprima "Done!".
4. Al ejecutar `npm run build` deben aparecer los tres mensajes en orden.

## Pistas

- `prebuild` se ejecuta antes de `build`.
- `postbuild` se ejecuta después.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "scripts": {
    "prebuild": "echo 'Cleaning...'",
    "build": "echo 'Building...'",
    "postbuild": "echo 'Done!'"
  }
}
```

</details>
