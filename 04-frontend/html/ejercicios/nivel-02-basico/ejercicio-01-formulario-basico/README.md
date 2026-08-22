# Ejercicio 01 — Formulario básico de registro

## Enunciado

Crea un `index.html` con un formulario de registro que pida nombre, email y contraseña. Todos los campos obligatorios, con labels asociados y un botón de envío.

## Requisitos

- Un `<form>` con `action` y `method="POST"`.
- Tres inputs: `text`, `email` y `password`.
- Cada `<input>` con su `<label for>` asociado.
- Todos los campos `required`.
- Un `<button type="submit">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La asociación `for`/`id` es clave: `<label for="x">` y `<input id="x">`.
- `method="POST"` para datos sensibles (no aparecen en la URL).
- Todos los campos con `required` para validación nativa.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Registro</title>
</head>
<body>
  <h1>Registro</h1>
  <form action="/registro" method="POST">
    <div>
      <label for="nombre">Nombre</label>
      <input type="text" id="nombre" name="nombre" required>
    </div>
    <div>
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required>
    </div>
    <div>
      <label for="clave">Contraseña</label>
      <input type="password" id="clave" name="clave" required>
    </div>
    <button type="submit">Registrarse</button>
  </form>
</body>
</html>
```

</details>
