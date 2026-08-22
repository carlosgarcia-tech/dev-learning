# Ejercicio 05 — Validación HTML5

## Enunciado

Crea un `index.html` con un formulario que use validación HTML5 nativa: campo obligatorio, email, rango numérico, longitud mínima y patrón de código postal.

## Requisitos

- Un input `text` con `required` y `minlength`.
- Un input `email` con `required`.
- Un input `number` con `min` y `max`.
- Un input `text` con `pattern` (código postal de 5 dígitos).
- Un `<button type="submit">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `pattern="[0-9]{5}"` valida exactamente 5 dígitos.
- `minlength` exige una longitud mínima de caracteres.
- `title` en el campo con `pattern` muestra una pista al usuario.

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
  <title>Validación</title>
</head>
<body>
  <h1>Formulario validado</h1>
  <form action="/datos" method="POST">
    <label for="usuario">Usuario (mínimo 3 caracteres)</label>
    <input type="text" id="usuario" name="usuario" required minlength="3">

    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>

    <label for="edad">Edad (18-99)</label>
    <input type="number" id="edad" name="edad" min="18" max="99">

    <label for="cp">Código postal</label>
    <input type="text" id="cp" name="cp" pattern="[0-9]{5}" title="5 dígitos" required>

    <button type="submit">Enviar</button>
  </form>
</body>
</html>
```

</details>
