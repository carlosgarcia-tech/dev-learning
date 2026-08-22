# Ejercicio 03 — Grid responsivo con auto-fit y minmax

## Enunciado

Crea un `index.html` y un `style.css` con una galería de tarjetas responsiva usando `repeat(auto-fit, minmax(250px, 1fr))`.

## Requisitos

- Un contenedor con `display: grid`.
- `grid-template-columns: repeat(auto-fit, minmax(250px, 1fr))`.
- `gap`.
- Al menos 6 tarjetas.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `auto-fit` crea tantas columnas como quepan.
- `minmax(250px, 1fr)` asegura mínimo 250px y reparte el resto.
- No necesitas media queries: el grid se adapta solo.

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
  <title>Galería</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="galeria">
    <div class="card">1</div>
    <div class="card">2</div>
    <div class="card">3</div>
    <div class="card">4</div>
    <div class="card">5</div>
    <div class="card">6</div>
  </div>
</body>
</html>
```

**style.css**:
```css
.galeria {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
  padding: 16px;
}

.card {
  padding: 24px;
  background: #3b82f6;
  color: white;
  border-radius: 8px;
  text-align: center;
}
```

</details>
