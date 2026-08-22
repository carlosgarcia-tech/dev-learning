# Ejercicio 02 — Export default

## Enunciado

Crea un `index.html`, un `main.js` y un `logger.js` que tenga un `export default`. Importa el default en `main.js` y úsalo.

## Requisitos

- `index.html` con `<script type="module" src="main.js">`.
- `logger.js` con `export default function` o `export default const`.
- `main.js` con `import logger from './logger.js'` (sin llaves).
- Uso de `logger('mensaje')` en `main.js`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `export default` no lleva nombre (o lo lleva opcional).
- Al importar un default, **no se usan llaves**: `import logger from '...'`.
- Puedes renombrarlo al importar: `import miLogger from './logger.js'`.

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
  <title>Export default</title>
</head>
<body>
  <script type="module" src="main.js"></script>
</body>
</html>
```

**logger.js**:
```js
export default function logger(mensaje) {
  console.log(`[LOG]: ${mensaje}`);
}
```

**main.js**:
```js
import logger from './logger.js';
logger('Hola desde main');
```

</details>
