# Ejercicio 02 — Manipular texto y HTML

## Enunciado

Crea un `index.html` con un `div` vacío (id="caja") y un `script.js` que cambie su `textContent`, luego su `innerHTML`, y añada una clase.

## Requisitos

- Un `<div id="caja">` vacío en el HTML.
- `script.js` con `defer`.
- Uso de `textContent` para cambiar el texto.
- Uso de `innerHTML` para insertar HTML.
- Uso de `classList.add` para añadir una clase.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `textContent` cambia solo el texto (sin HTML).
- `innerHTML` inserta HTML interpretado.
- `classList.add('clase')` añade una clase.

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
  <title>Manipular DOM</title>
  <script src="script.js" defer></script>
</head>
<body>
  <div id="caja"></div>
</body>
</html>
```

**script.js**:
```js
const caja = document.querySelector('#caja');

caja.textContent = 'Hola mundo';
caja.innerHTML = '<p>Texto con <strong>HTML</strong></p>';
caja.classList.add('resaltado');
```

</details>
