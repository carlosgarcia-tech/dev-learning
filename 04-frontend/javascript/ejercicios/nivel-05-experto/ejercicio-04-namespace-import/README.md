# Ejercicio 04 — Namespace import

## Enunciado

Crea un `index.html`, un `main.js` y un `utils.js` que exporte varias funciones. Importa todo como namespace con `import * as` en `main.js`.

## Requisitos

- `utils.js` con al menos 2 funciones exportadas.
- `main.js` con `import * as utils from './utils.js'`.
- Uso de `utils.funcion()`.
- `index.html` con `<script type="module" src="main.js">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `import * as nombre from './modulo.js'` importa todo bajo un namespace.
- Se accede a cada export con `nombre.funcion`.
- Útil cuando un módulo tiene muchas funciones.

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
  <title>Namespace import</title>
</head>
<body>
  <script type="module" src="main.js"></script>
</body>
</html>
```

**utils.js**:
```js
export function sumar(a, b) { return a + b; }
export function restar(a, b) { return a - b; }
```

**main.js**:
```js
import * as utils from './utils.js';

console.log(utils.sumar(2, 3));
console.log(utils.restar(5, 2));
```

</details>
