# 01 — Configurar workspaces

## Enunciado

Configura un monorepo con npm workspaces.

## Requisitos

1. En `solucion/package.json` (raíz), define `"private": true`.
2. Configura `"workspaces": ["packages/*"]`.
3. Crea dos paquetes vacíos: `packages/core/package.json` y `packages/ui/package.json` con su `name`.

## Pistas

- La raíz debe ser `private` para no publicarla por accidente.

## Solución

<details>
<summary>Mostrar solución</summary>

```json
// solucion/package.json
{
  "name": "mi-monorepo",
  "private": true,
  "workspaces": ["packages/*"]
}
```

```json
// solucion/packages/core/package.json
{ "name": "@miorg/core", "version": "1.0.0" }
```

```json
// solucion/packages/ui/package.json
{ "name": "@miorg/ui", "version": "1.0.0" }
```

</details>
