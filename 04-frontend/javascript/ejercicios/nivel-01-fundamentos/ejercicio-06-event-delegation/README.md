# Ejercicio 06 — Event delegation

## Enunciado

Crea un `index.html` con una lista (`<ul id="lista">`) con varios `<li>` que tienen un botón eliminar cada uno. Usa event delegation: un solo listener en el `<ul>` que detecte clics en los botones.

## Requisitos

- Un `<ul id="lista">` con al menos 3 `<li>`, cada uno con un `<button class="eliminar">`.
- `script.js` con `defer`.
- Un solo `addEventListener` en el `<ul>` (no en cada botón).
- Uso de `e.target.matches('.eliminar')` o `e.target.closest`.
- Al hacer clic en eliminar, se quita el `<li>` correspondiente.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Con delegation, un listener en el `<ul>` detecta clics en cualquier hijo.
- `e.target.matches('.eliminar')` comprueba si el elemento clicado es el botón.
- `e.target.closest('li')` encuentra el `<li>` padre para eliminarlo.

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
  <title>Delegation</title>
  <script src="script.js" defer></script>
</head>
<body>
  <ul id="lista">
    <li>Item 1 <button class="eliminar">X</button></li>
    <li>Item 2 <button class="eliminar">X</button></li>
    <li>Item 3 <button class="eliminar">X</button></li>
  </ul>
</body>
</html>
```

**script.js**:
```js
const lista = document.querySelector('#lista');

lista.addEventListener('click', (e) => {
  if (e.target.matches('.eliminar')) {
    const li = e.target.closest('li');
    li.remove();
  }
});
```

</details>
