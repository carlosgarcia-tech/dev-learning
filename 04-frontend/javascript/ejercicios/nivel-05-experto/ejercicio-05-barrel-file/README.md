# Ejercicio 05 — Barrel file (re-export)

## Enunciado

Crea un `index.html`, un `main.js`, un `index.js` (barrel) que re-exporte desde `math.js` y `string.js`.

## Requisitos

- `math.js` con un export.
- `string.js` con un export.
- `index.js` que re-exporte de ambos con `export { ... } from './modulo.js'`.
- `main.js` que importe desde `./index.js`.
- `index.html` con `<script type="module" src="main.js">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un barrel file re-exporta desde varios módulos en uno solo.
- `export { sumar } from './math.js'` re-exporta sin importar localmente.
- `export { default as nombre } from './modulo.js'` re-exporta un default renombrado.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

**index.html**:
```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Barrel file</title>
</head>
<body>
  <script type="module" src="main.js"></script>
</body>
</html>
```

**math.js**:
```js
export function sumar(a, b) { return a + b; }
```

**string.js**:
```js
export function mayusculas(texto) { return texto.toUpperCase(); }
```

**index.js** (barrel):
```js
export { sumar } from './math.js';
export { mayusculas } from './string.js';
```

**main.js**:
```js
import { sumar, mayusculas } from './index.js';

console.log(sumar(2, 3));
console.log(mayusculas('hola'));
```

</details>
