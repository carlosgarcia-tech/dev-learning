# Ejercicio 06 — Tabla accesible

## Enunciado

Crea un `index.html` con una tabla que muestre un horario semanal. Debe incluir `<caption>`, `<thead>`, `<tbody>`, encabezados con `scope`, y al menos 3 filas de datos.

## Requisitos

- Una tabla con `<caption>` descriptivo.
- `<thead>` con fila de encabezados de columna.
- `<tbody>` con al menos 3 filas.
- `scope="col"` en los encabezados de columna.
- `scope="row"` en la primera celda de cada fila.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `scope` indica al lector de pantalla si el encabezado es de columna o de fila.
- `<caption>` va justo después de `<table>` y describe la tabla completa.

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
  <title>Horario</title>
</head>
<body>
  <h1>Horario semanal</h1>
  <table>
    <caption>Horario de clases de lunes a miércoles</caption>
    <thead>
      <tr>
        <th scope="col">Hora</th>
        <th scope="col">Lunes</th>
        <th scope="col">Martes</th>
        <th scope="col">Miércoles</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th scope="row">09:00</th>
        <td>Matemáticas</td>
        <td>Física</td>
        <td>Programación</td>
      </tr>
      <tr>
        <th scope="row">11:00</th>
        <td>Historia</td>
        <td>Inglés</td>
        <td>Matemáticas</td>
      </tr>
      <tr>
        <th scope="row">13:00</th>
        <td>Educación física</td>
        <td>Química</td>
        <td>Música</td>
      </tr>
    </tbody>
  </table>
</body>
</html>
```

</details>
