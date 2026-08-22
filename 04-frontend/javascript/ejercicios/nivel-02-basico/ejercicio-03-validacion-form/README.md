# Ejercicio 03 — Validación de formulario

## Enunciado

Crea un `index.html` con un formulario y un `script.js` que valide que el nombre tenga al menos 3 caracteres y el email tenga formato válido antes de "enviar".

## Requisitos

- Un form con inputs `nombre` y `email`.
- `script.js` con `defer`.
- `preventDefault` en el submit.
- Validar `nombre.length >= 3`.
- Validar email con regex `/^[^\s@]+@[^\s@]+\.[^\s@]+$/`.
- Mostrar errores en un `div#error`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa `.trim()` para quitar espacios al inicio y final.
- Si hay errores, muéstralos en el div y no envíes.
- `regex.test(email)` devuelve true si cumple.

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
  <title>Validación</title>
  <script src="script.js" defer></script>
</head>
<body>
  <form id="form">
    <input type="text" name="nombre" placeholder="Nombre">
    <input type="email" name="email" placeholder="Email">
    <button type="submit">Enviar</button>
  </form>
  <div id="error"></div>
</body>
</html>
```

**script.js**:
```js
const form = document.querySelector('#form');
const errorDiv = document.querySelector('#error');

form.addEventListener('submit', (e) => {
  e.preventDefault();
  const nombre = form.nombre.value.trim();
  const email = form.email.value.trim();
  const errores = [];

  if (nombre.length < 3) {
    errores.push('El nombre debe tener al menos 3 caracteres');
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    errores.push('Email no válido');
  }

  if (errores.length > 0) {
    errorDiv.innerHTML = errores.map(e => `<p>${e}</p>`).join('');
    return;
  }

  errorDiv.innerHTML = '';
  console.log('Formulario válido');
});
```

</details>
