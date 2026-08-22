# Ejercicio 04 — Media queries mobile-first

## Enunciado

Crea un `index.html` y un `style.css` con un grid que sea de 1 columna en móvil y de 2 columnas en tablet (`min-width: 768px`) y 3 en escritorio (`min-width: 1024px`).

## Requisitos

- Un grid con `grid-template-columns: 1fr` por defecto (móvil).
- Media query con `min-width: 768px` que cambie a 2 columnas.
- Media query con `min-width: 1024px` que cambie a 3 columnas.
- Al menos 6 items.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Mobile-first: estilos base para móvil, luego `min-width` para pantallas mayores.
- `@media (min-width: 768px) { ... }` aplica a partir de 768px.
- No uses `max-width` (es desktop-first).

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
  <title>Responsive</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="grid">
    <div class="item">1</div>
    <div class="item">2</div>
    <div class="item">3</div>
    <div class="item">4</div>
    <div class="item">5</div>
    <div class="item">6</div>
  </div>
</body>
</html>
```

**style.css**:
```css
.grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
  padding: 16px;
}

@media (min-width: 768px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

.item {
  padding: 24px;
  background: #3b82f6;
  color: white;
  text-align: center;
}
```

</details>
