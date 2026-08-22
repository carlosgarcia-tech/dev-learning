# Ejercicio 06 — Validación con API nativa

## Enunciado

Crea un `index.html` con un formulario y un `script.js` que use `checkValidity()` y `setCustomValidity()` para validación personalizada.

## Requisitos

- Un form con input `email` (required).
- `script.js` con `defer`.
- Uso de `input.checkValidity()`.
- Uso de `input.setCustomValidity('mensaje')`.
- Listener `input` que valide en tiempo real.
- Limpiar `setCustomValidity('')` cuando sea válido.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `setCustomValidity('')` limpia el mensaje de error.
- `validity.typeMismatch` indica que el tipo (email) no es correcto.
- `validity.valueMissing` indica que está vacío siendo required.

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
  <title>Validación nativa</title>
  <script src="script.js" defer></script>
</head>
<body>
  <form id="form">
    <input type="email" id="email" name="email" required>
    <button type="submit">Enviar</button>
  </form>
</body>
</html>
```

**script.js**:
```js
const email = document.querySelector('#email');

email.addEventListener('input', () => {
  email.setCustomValidity('');

  if (email.validity.valueMissing) {
    email.setCustomValidity('El email es obligatorio');
  } else if (email.validity.typeMismatch) {
    email.setCustomValidity('Introduce un email válido');
  }

  email.checkValidity();
});
```

</details>
