# Ejercicio 02 — Tipos de input y datalist

## Enunciado

Crea un `index.html` con un formulario que use al menos 6 tipos distintos de `<input>`: text, email, number, date, color y range. Además incluye un `<input list>` con un `<datalist>` asociado.

## Requisitos

- 6 tipos distintos de `<input>`: text, email, number, date, color, range.
- Un `<input>` con `list="..."` y su `<datalist>` con al menos 3 `<option>`.
- Todos los inputs con `name`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `list` apunta al `id` del `<datalist>`.
- `range` admite `min`, `max` y `step`.
- `<datalist>` sugiere valores sin limitar (a diferencia de `<select>`).

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
  <title>Tipos de input</title>
</head>
<body>
  <h1>Encuesta</h1>
  <form action="/encuesta" method="POST">
    <label for="nombre">Nombre</label>
    <input type="text" id="nombre" name="nombre">

    <label for="email">Email</label>
    <input type="email" id="email" name="email">

    <label for="edad">Edad</label>
    <input type="number" id="edad" name="edad" min="0" max="120">

    <label for="fecha">Fecha</label>
    <input type="date" id="fecha" name="fecha">

    <label for="color">Color favorito</label>
    <input type="color" id="color" name="color">

    <label for="volumen">Volumen</label>
    <input type="range" id="volumen" name="volumen" min="0" max="100">

    <label for="navegador">Navegador</label>
    <input list="navegadores" id="navegador" name="navegador">
    <datalist id="navegadores">
      <option value="Chrome">
      <option value="Firefox">
      <option value="Safari">
    </datalist>
  </form>
</body>
</html>
```

</details>
