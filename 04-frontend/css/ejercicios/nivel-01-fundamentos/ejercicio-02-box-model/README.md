# Ejercicio 02 — Box model y box-sizing

## Enunciado

Crea un `index.html` y un `style.css` con una caja que tenga width, padding, border y margin. Aplica `box-sizing: border-box` con un reset universal.

## Requisitos

- Un reset universal `*, *::before, *::after { box-sizing: border-box; }`.
- Una caja con `width`, `padding`, `border` y `margin`.
- Una segunda caja con `box-sizing: content-box` para comparar.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Con `border-box`, `width` incluye padding y border.
- Con `content-box` (default), `width` es solo el contenido.
- El reset universal afecta a todos los elementos.

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
  <title>Box model</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="caja-border-box">Border-box: 200px totales</div>
  <div class="caja-content-box">Content-box: 200px + padding + border</div>
</body>
</html>
```

**style.css**:
```css
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

.caja-border-box {
  width: 200px;
  padding: 20px;
  border: 2px solid #333;
  margin: 16px;
  background: #dbeafe;
}

.caja-content-box {
  box-sizing: content-box;
  width: 200px;
  padding: 20px;
  border: 2px solid #333;
  margin: 16px;
  background: #fee2e2;
}
```

</details>
