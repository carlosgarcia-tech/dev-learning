# Ejercicio 04 — FormData

## Enunciado

Crea un `index.html` con un formulario y un `script.js` que use `FormData` para recoger los datos y convertirlos a objeto con `Object.fromEntries`.

## Requisitos

- Un form con al menos 3 campos (nombre, email, edad).
- `script.js` con `defer`.
- `preventDefault` en el submit.
- Uso de `new FormData(form)`.
- Uso de `Object.fromEntries(formData.entries())`.
- `console.log` del objeto resultante.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `new FormData(form)` recoge todos los campos con `name`.
- `formData.entries()` devuelve pares `[key, value]`.
- `Object.fromEntries()` convierte esos pares en un objeto.

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
  <title>FormData</title>
  <script src="script.js" defer></script>
</head>
<body>
  <form id="form">
    <input type="text" name="nombre" placeholder="Nombre">
    <input type="email" name="email" placeholder="Email">
    <input type="number" name="edad" placeholder="Edad">
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
  const formData = new FormData(form);
  const datos = Object.fromEntries(formData.entries());
  console.log(datos);
});
```

</details>
