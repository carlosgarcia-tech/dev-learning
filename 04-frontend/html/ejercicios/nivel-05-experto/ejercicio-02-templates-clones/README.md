# Ejercicio 02 — Templates y clones

## Enunciado

Crea un `index.html` con un `<template id="tpl-fila">` que contenga una fila de tabla. Un `<script>` debe clonar el template con `content.cloneNode(true)` y añadirlo al DOM al hacer clic en un botón.

## Requisitos

- Un `<template id="tpl-fila">` con contenido HTML (una fila `<tr>`).
- Un `<table>` con `<tbody id="cuerpo">`.
- Un `<button id="agregar">` que dispare la clonación.
- Un `<script>` que use `document.getElementById('tpl-fila').content.cloneNode(true)`.
- El script usa `addEventListener` en el botón y `appendChild` en el tbody.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El contenido de un `<template>` no se renderiza hasta que se clona.
- `template.content.cloneNode(true)` hace una copia profunda.
- `appendChild` inserta el clon en el DOM.

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
  <title>Templates</title>
</head>
<body>
  <h1>Lista dinámica</h1>

  <button id="agregar">Agregar fila</button>

  <table>
    <thead>
      <tr><th>Nombre</th><th>Edad</th></tr>
    </thead>
    <tbody id="cuerpo"></tbody>
  </table>

  <template id="tpl-fila">
    <tr>
      <td>Nuevo</td>
      <td>0</td>
    </tr>
  </template>

  <script>
    const tpl = document.getElementById('tpl-fila');
    const cuerpo = document.getElementById('cuerpo');
    document.getElementById('agregar').addEventListener('click', () => {
      const clon = tpl.content.cloneNode(true);
      cuerpo.appendChild(clon);
    });
  </script>
</body>
</html>
```

</details>
