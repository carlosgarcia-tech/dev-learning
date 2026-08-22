# Ejercicio 02 — Formulario con preventDefault

## Enunciado

Crea un `index.html` con un formulario y un `script.js` que intercepte el `submit` con `preventDefault` y muestre los datos por consola.

## Requisitos

- Un `<form id="form">` con al menos un input de texto y un submit.
- `script.js` con `defer`.
- `addEventListener('submit', ...)` en el form.
- Uso de `e.preventDefault()`.
- Leer el valor del input con `form.input.value` o `querySelector`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `e.preventDefault()` evita que el formulario recargue la página.
- Accede a los campos por `name`: `form.nombreCampo.value`.
- O con `FormData`: `new FormData(form)`.

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
  <title>Formulario</title>
  <script src="script.js" defer></script>
</head>
<body>
  <form id="form">
    <input type="text" name="nombre" placeholder="Nombre">
    <button type="submit">Enviar</button>
  </form>
</body>
</html>
```

**script.js**:
```js
const form = document.querySelector('#form');

form.addEventListener('submit', (e) => {
  e.preventDefault();
  const nombre = form.nombre.value;
  console.log('Nombre:', nombre);
});
```

</details>
