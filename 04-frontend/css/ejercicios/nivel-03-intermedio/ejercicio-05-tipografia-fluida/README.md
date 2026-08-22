# Ejercicio 05 — Tipografía fluida con clamp

## Enunciado

Crea un `index.html` y un `style.css` con títulos y párrafos que usen `clamp()` para tener tipografía fluida.

## Requisitos

- Un `h1` con `font-size: clamp(mín, preferido, máx)`.
- Un `h2` con `clamp()`.
- Un `p` con `clamp()`.
- El valor preferido debe usar `vw` (ej: `5vw`).
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `clamp(1.5rem, 5vw, 3rem)` escala entre 1.5rem y 3rem según el ancho.
- El valor medio (`5vw`) es el que se aplica en la mayoría de pantallas.
- No necesitas media queries: clamp es fluido.

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
  <title>Tipografía fluida</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Título fluido</h1>
  <h2>Subtítulo fluido</h2>
  <p>Párrafo con tamaño fluido que se adapta al ancho de pantalla.</p>
</body>
</html>
```

**style.css**:
```css
h1 { font-size: clamp(2rem, 5vw, 3.5rem); }
h2 { font-size: clamp(1.5rem, 4vw, 2.5rem); }
p { font-size: clamp(1rem, 2.5vw, 1.25rem); }
```

</details>
