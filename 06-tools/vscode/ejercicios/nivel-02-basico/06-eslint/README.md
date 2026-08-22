# 06 — ESLint config

## Enunciado

Configura ESLint junto con Prettier.

## Requisitos

1. Crea `solucion/.eslintrc.json` que extienda `eslint:recommended` y `prettier`.
2. Explica en `respuesta.txt` para qué sirve `eslint-config-prettier`.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "extends": ["eslint:recommended", "prettier"]
}
```

`respuesta.txt`:
```
eslint-config-prettier desactiva las reglas de ESLint que entrarían en conflicto con Prettier, para que ambos trabajen juntos sin pelearse.
```

</details>
