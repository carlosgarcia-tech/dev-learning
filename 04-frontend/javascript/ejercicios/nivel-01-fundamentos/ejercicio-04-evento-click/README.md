# Ejercicio 04 — Evento click

## Enunciado

Crea un `index.html` con un botón y un `script.js` que añada un listener de `click` que cambie el texto del botón al hacer clic.

## Requisitos

- Un `<button id="boton">` con texto inicial.
- `script.js` con `defer`.
- Uso de `addEventListener('click', ...)`.
- Dentro del callback, cambiar el `textContent` del botón.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `boton.addEventListener('click', () => { ... })` registra el evento.
- Dentro del callback, `boton.textContent = 'nuevo texto'` lo cambia.
- `defer` asegura que el botón exista cuando se ejecute el script.

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
  <title>Click</title>
  <script src="script.js" defer></script>
</head>
<body>
  <button id="boton">Clic aquí</button>
</body>
</html>
```

**script.js**:
```js
const boton = document.querySelector('#boton');

boton.addEventListener('click', () => {
  boton.textContent = '¡Clicado!';
});
```

</details>
