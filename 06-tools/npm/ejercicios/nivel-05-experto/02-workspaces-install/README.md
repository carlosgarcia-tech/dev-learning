# 02 — Instalar en monorepo

## Enunciado

Instala dependencias en un monorepo con workspaces.

## Requisitos

1. En `solucion/`, ejecuta `npm install` en la raíz.
2. Verifica que se crea `node_modules/`.
3. Añade `express` solo al paquete `core` con `npm install express -w packages/core`.

## Pistas

- `-w` selecciona el workspace donde instalar.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm install
npm install express -w packages/core
```

</details>
