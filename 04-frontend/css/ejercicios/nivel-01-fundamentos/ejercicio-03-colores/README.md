# Ejercicio 03 — Colores en distintos formatos

## Enunciado

Crea un `index.html` y un `style.css` que usen al menos 5 formatos de color distintos: hex, hex con alpha, rgb, rgba, hsl.

## Requisitos

- Al menos un color en formato hex (`#3b82f6`).
- Al menos un color en formato hex con alpha (`#3b82f680`).
- Al menos un color en `rgb()`.
- Al menos un color en `rgba()`.
- Al menos un color en `hsl()`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Hex con alpha añade 2 dígitos al final: `#RRGGBBAA`.
- `hsl(matiz, saturación%, luz%)`: matiz va de 0 a 360.
- `rgba()` admite un cuarto valor de 0 a 1 para la transparencia.

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
  <title>Colores</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="hex">Hex</div>
  <div class="hex-alpha">Hex con alpha</div>
  <div class="rgb">RGB</div>
  <div class="rgba">RGBA</div>
  <div class="hsl">HSL</div>
</body>
</html>
```

**style.css**:
```css
div { padding: 16px; margin: 8px; }
.hex { background: #3b82f6; }
.hex-alpha { background: #3b82f680; }
.rgb { background: rgb(59, 130, 246); }
.rgba { background: rgba(239, 68, 68, 0.5); }
.hsl { background: hsl(140, 70%, 40%); }
```

</details>
