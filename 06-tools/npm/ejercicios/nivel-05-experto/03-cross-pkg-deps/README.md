# 03 — Dependencias entre paquetes

## Enunciado

Configura una dependencia entre paquetes del monorepo.

## Requisitos

1. En `solucion/packages/ui/package.json`, añade `@miorg/core` como dependency (versión `1.0.0`).
2. Tras `npm install`, verifica que se crea el symlink.

## Pistas

- npm detecta que `@miorg/core` es un workspace y crea un symlink.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
// packages/ui/package.json
{
  "name": "@miorg/ui",
  "version": "1.0.0",
  "dependencies": {
    "@miorg/core": "1.0.0"
  }
}
```

```bash
npm install
ls -la packages/ui/node_modules/@miorg/core   # es un symlink
```

</details>
