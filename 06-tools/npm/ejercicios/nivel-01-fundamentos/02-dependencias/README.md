# 02 — Dependencias y devDependencies

## Enunciado

Aprende a distinguir entre `dependencies` y `devDependencies`.

## Requisitos

1. En `solucion/`, instala `express` como `dependency`.
2. Instala `jest` como `devDependency`.
3. Verifica que en `package.json`:
   - `express` está en `dependencies`.
   - `jest` está en `devDependencies`.

## Pistas

- `npm install express` → dependencies.
- `npm install --save-dev jest` → devDependencies.

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd solucion
npm install express
npm install --save-dev jest
```

</details>
