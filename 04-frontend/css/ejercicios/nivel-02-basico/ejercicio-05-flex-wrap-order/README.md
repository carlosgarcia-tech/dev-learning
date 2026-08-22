# Ejercicio 05 — Flex-wrap y order

## Enunciado

Crea un `index.html` y un `style.css` con un contenedor flex que tenga `flex-wrap: wrap` y varios items con `order` distintos para reordenarlos visualmente.

## Requisitos

- Un contenedor con `display: flex` y `flex-wrap: wrap`.
- Al menos 4 items flex.
- Al menos 2 items con `order` distinto de 0.
- Uso de `gap`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `flex-wrap: wrap` permite que los items salten de línea si no caben.
- `order` negativo va primero, positivo va después.
- Por defecto todos tienen `order: 0`.

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
  <title>Flex-wrap y order</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="contenedor">
    <div class="item item-1">1 (order 2)</div>
    <div class="item item-2">2 (order -1)</div>
    <div class="item item-3">3 (order 0)</div>
    <div class="item item-4">4 (order 1)</div>
  </div>
</body>
</html>
```

**style.css**:
```css
.contenedor {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
}

.item {
  width: 150px;
  height: 100px;
  background: #3b82f6;
  color: white;
  display: flex;
  justify-content: center;
  align-items: center;
}

.item-1 { order: 2; }
.item-2 { order: -1; }
.item-3 { order: 0; }
.item-4 { order: 1; }
```

</details>
