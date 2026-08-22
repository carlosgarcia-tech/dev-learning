# Ejercicio 03 — Listas ordenadas, no ordenadas y de definición

## Enunciado

Crea un `index.html` que contenga una lista no ordenada de frutas, una lista ordenada de pasos para hacer un café, y una lista de definición con tres términos de programación.

## Requisitos

- Una `<ul>` con al menos 3 `<li>`.
- Una `<ol>` con al menos 4 `<li>`.
- Un `<dl>` con al menos 3 pares `<dt>`/`<dd>`.
- Las listas deben estar dentro de un `<body>` con estructura HTML válida.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `<dl>` contiene pares `<dt>` (término) y `<dd>` (definición).
- Las listas se pueden anidar poniendo una `<ul>` dentro de un `<li>`.

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
  <title>Listas</title>
</head>
<body>
  <h1>Listas</h1>

  <h2>Frutas</h2>
  <ul>
    <li>Manzana</li>
    <li>Pera</li>
    <li>Plátano</li>
  </ul>

  <h2>Cómo hacer un café</h2>
  <ol>
    <li>Calentar agua</li>
    <li>Poner café en el filtro</li>
    <li>Verter el agua</li>
    <li>Servir y disfrutar</li>
  </ol>

  <h2>Glosario</h2>
  <dl>
    <dt>HTML</dt>
    <dd>Lenguaje de marcado de hipertexto.</dd>
    <dt>CSS</dt>
    <dd>Hojas de estilo en cascada.</dd>
    <dt>DOM</dt>
    <dd>Modelo de objetos del documento.</dd>
  </dl>
</body>
</html>
```

</details>
