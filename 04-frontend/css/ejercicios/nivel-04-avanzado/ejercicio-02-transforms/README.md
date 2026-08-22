# Ejercicio 02 — Transformaciones: rotate, scale, translate

## Enunciado

Crea un `index.html` y un `style.css` con tres elementos que demuestren `rotate`, `scale` y `translate` al hacer hover.

## Requisitos

- Un elemento con `transform: rotate()` en hover.
- Un elemento con `transform: scale()` en hover.
- Un elemento con `transform: translate()` en hover.
- Todos con `transition`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `rotate(45deg)` rota 45 grados.
- `scale(1.2)` agranda un 20%.
- `translate(10px, 10px)` desplaza.
- Combina con `transition` para que sea suave.

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
  <title>Transforms</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="caja rotar">Rotar</div>
  <div class="caja escalar">Escalar</div>
  <div class="caja mover">Mover</div>
</body>
</html>
```

**style.css**:
```css
.caja {
  width: 100px;
  height: 100px;
  margin: 20px;
  background: #3b82f6;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.3s ease;
}

.rotar:hover { transform: rotate(45deg); }
.escalar:hover { transform: scale(1.3); }
.mover:hover { transform: translate(20px, 20px); }
```

</details>
