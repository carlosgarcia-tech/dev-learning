# Ejercicio 02 — Position: relative, absolute, fixed, sticky

## Enunciado

Crea un `index.html` y un `style.css` que demuestren los cuatro valores de `position`: relative, absolute, fixed y sticky.

## Requisitos

- Un elemento con `position: relative` y `top`/`left`.
- Un contenedor con `position: relative` que contenga un hijo con `position: absolute`.
- Un elemento con `position: fixed` (ej: un botón flotante).
- Un elemento con `position: sticky` con `top: 0`.
- Al menos un `z-index`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `absolute` se posiciona respecto al ancestro posicionado más cercano.
- `sticky` necesita un `top`/`bottom` para saber cuándo pegarse.
- `z-index` solo funciona con `position` no static.

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
  <title>Position</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="relativo">Relative</div>

  <div class="contenedor">
    <div class="absoluto">Absolute</div>
  </div>

  <div class="flotante">Fixed</div>

  <div class="pegajoso">Sticky</div>
  <div style="height: 2000px;">Scroll para ver el sticky</div>
</body>
</html>
```

**style.css**:
```css
.relativo {
  position: relative;
  top: 20px;
  left: 20px;
  background: #dbeafe;
}

.contenedor {
  position: relative;
  height: 200px;
  background: #f0f0f0;
}

.absoluto {
  position: absolute;
  top: 10px;
  right: 10px;
  background: #fecaca;
}

.flotante {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 100;
  background: #3b82f6;
  color: white;
  padding: 12px;
}

.pegajoso {
  position: sticky;
  top: 0;
  background: #fbbf24;
  padding: 12px;
  z-index: 10;
}
```

</details>
