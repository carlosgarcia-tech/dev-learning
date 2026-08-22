# 01 — Configurar workspace

## Enunciado

Configura un monorepo con pnpm workspaces.

## Requisitos

1. Crea `solucion/pnpm-workspace.yaml` con `packages: ["packages/*"]`.
2. Crea `solucion/package.json` con `private: true`.
3. Crea `packages/core/package.json` y `packages/ui/package.json`.

## Solución

<details>
<summary>Mostrar solución</summary>

```yaml
# pnpm-workspace.yaml
packages:
  - "packages/*"
```

```json
// package.json
{ "name": "mi-monorepo", "private": true }
```

</details>
