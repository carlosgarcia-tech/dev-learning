# Ejercicio 01 — CSS Grid básico con fracciones

## Enunciado

Crea un `index.html` y un `style.css` con un grid de 3 columnas usando `1fr` y `gap`.

## Requisitos

- Un contenedor con `display: grid`.
- `grid-template-columns` con 3 fracciones (`1fr 1fr 1fr` o `repeat(3, 1fr)`).
- `gap` entre celdas.
- Al menos 6 items dentro del grid.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `1fr` es una fracción del espacio disponible.
- `repeat(3, 1fr)` es equivalente a `1fr 1fr 1fr`.
- `gap` separa filas y columnas.

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
  <title>Grid básico</title>
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
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.item {
  padding: 24px;
  background: #3b82f6;
  color: white;
  text-align: center;
}
```

</details>
