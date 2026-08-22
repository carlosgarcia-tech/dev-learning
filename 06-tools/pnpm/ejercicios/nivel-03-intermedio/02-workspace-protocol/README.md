# 02 — workspace:*

## Enunciado

Referencia un paquete interno con el protocolo `workspace:*`.

## Requisitos

1. En `solucion/packages/ui/package.json`, añade `@miorg/core` como dependency con `workspace:*`.
2. Ejecuta `pnpm install` y verifica que se crea el symlink.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
{
  "name": "@miorg/ui",
  "dependencies": {
    "@miorg/core": "workspace:*"
  }
}
```

```bash
pnpm install
ls packages/ui/node_modules/@miorg/core  # symlink
```

</details>
