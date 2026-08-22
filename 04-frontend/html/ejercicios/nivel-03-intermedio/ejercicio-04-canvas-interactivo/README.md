# Ejercicio 04 — Canvas interactivo

## Enunciado

Crea un `index.html` con un `<canvas>` y un `<script>` que dibuje tres figuras: un rectángulo, un círculo y texto.

## Requisitos

- Un `<canvas>` con `id`, `width` y `height`.
- Un `<script>` que use `getContext('2d')`.
- Dibujar un rectángulo con `fillRect`.
- Dibujar un círculo con `arc` y `fill`.
- Dibujar texto con `fillText`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Un círculo se dibuja con `beginPath()`, `arc(x, y, radio, 0, Math.PI*2)`, `fill()`.
- `fillText(texto, x, y)` dibuja texto en el canvas.
- Define `fillStyle` antes de cada figura para cambiar el color.

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
  <title>Canvas</title>
</head>
<body>
  <h1>Canvas</h1>
  <canvas id="lienzo" width="400" height="300"></canvas>

  <script>
    const canvas = document.getElementById('lienzo');
    const ctx = canvas.getContext('2d');

    // Rectángulo
    ctx.fillStyle = '#3b82f6';
    ctx.fillRect(50, 50, 100, 80);

    // Círculo
    ctx.beginPath();
    ctx.arc(250, 100, 40, 0, Math.PI * 2);
    ctx.fillStyle = '#ef4444';
    ctx.fill();

    // Texto
    ctx.fillStyle = '#000';
    ctx.font = '24px sans-serif';
    ctx.fillText('Hola canvas', 100, 250);
  </script>
</body>
</html>
```

</details>
