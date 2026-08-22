# Ejercicio 01 — Formulario completo con fieldsets anidados

## Enunciado

Crea un `index.html` con un formulario de compra que tenga dos `<fieldset>` anidados, autocompletar correcto, y validación variada (pattern, min, max, required).

## Requisitos

- Un `<form>` con `method="POST"`.
- Dos `<fieldset>` cada uno con su `<legend>`.
- Inputs con `autocomplete` (`name`, `email`, `postal-code`).
- Un input con `pattern`.
- Un input `number` con `min` y `max`.
- Al menos un `required`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `autocomplete` estandarizado ayuda al navegador a sugerir valores correctos.
- Puedes anidar `<fieldset>` dentro de otro `<fieldset>`.

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
  <title>Compra</title>
</head>
<body>
  <h1>Finalizar compra</h1>
  <form action="/comprar" method="POST">
    <fieldset>
      <legend>Datos de contacto</legend>
      <label for="nombre">Nombre completo</label>
      <input type="text" id="nombre" name="nombre" autocomplete="name" required>

      <label for="email">Email</label>
      <input type="email" id="email" name="email" autocomplete="email" required>
    </fieldset>

    <fieldset>
      <legend>Envío</legend>
      <label for="cp">Código postal</label>
      <input type="text" id="cp" name="cp" autocomplete="postal-code" pattern="[0-9]{5}" required>

      <label for="cantidad">Cantidad</label>
      <input type="number" id="cantidad" name="cantidad" min="1" max="99" value="1">
    </fieldset>

    <button type="submit">Comprar</button>
  </form>
</body>
</html>
```

</details>
