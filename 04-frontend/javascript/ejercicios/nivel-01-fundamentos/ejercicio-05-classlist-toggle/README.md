# Ejercicio 05 — classList toggle

## Enunciado

Crea un `index.html` con un div y un botón. El `script.js` debe alternar una clase `activo` en el div al hacer clic en el botón usando `classList.toggle`.

## Requisitos

- Un `<div id="caja">` y un `<button id="boton">`.
- `script.js` con `defer`.
- Uso de `classList.toggle('activo')` en el callback del click.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `classList.toggle('clase')` añade la clase si no está y la quita si está.
- El listener va en el botón, pero `toggle` se aplica en el div.

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
  <title>Toggle</title>
  <script src="script.js" defer></script>
</head>
<body>
  <div id="caja">Caja</div>
  <button id="boton">Alternar</button>
</body>
</html>
```

**script.js**:
```js
const caja = document.querySelector('#caja');
const boton = document.querySelector('#boton');

boton.addEventListener('click', () => {
  caja.classList.toggle('activo');
});
```

</details>
