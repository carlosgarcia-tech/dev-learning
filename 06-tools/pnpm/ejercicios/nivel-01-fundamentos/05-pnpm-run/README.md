# 05 — pnpm run

## Enunciado

Ejecuta scripts con pnpm.

## Requisitos

1. Define un script `saludar` en `package.json` que imprima "Hola pnpm".
2. Ejecuta `pnpm saludar` y verifica que funciona.

## Pistas

- En pnpm no hace falta `run` para scripts personalizados.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "scripts": {
    "saludar": "echo Hola pnpm"
  }
}
```

```bash
pnpm saludar
```

</details>
