# Ejercicio 01 — ES modules: import y export

## Enunciado

Crea un `index.html`, un `main.js` (módulo) y un `math.js` que exporte una función. Importa y usa la función en `main.js`.

## Requisitos

- `index.html` con `<script type="module" src="main.js">`.
- `math.js` con `export function sumar(a, b)`.
- `main.js` con `import { sumar } from './math.js'`.
- Uso de `console.log(sumar(2, 3))` en `main.js`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `type="module"` es obligatorio para que los `import` funcionen en el navegador.
- Las rutas relativas en ESM del navegador llevan extensión (`./math.js`).
- `export function nombre()` exporta la función nombrada.

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
  <title>ES Modules</title>
</head>
<body>
  <h1>Revisa la consola</h1>
  <script type="module" src="main.js"></script>
</body>
</html>
```

**math.js**:
```js
export function sumar(a, b) {
  return a + b;
}
```

**main.js**:
```js
import { sumar } from './math.js';
console.log(sumar(2, 3));
```

</details>
