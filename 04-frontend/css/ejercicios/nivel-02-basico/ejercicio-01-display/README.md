# Ejercicio 01 — Display: block, inline, inline-block

## Enunciado

Crea un `index.html` y un `style.css` con tres elementos que demuestren los comportamientos de `display: block`, `inline` e `inline-block`.

## Requisitos

- Un elemento con `display: block` (ocupa todo el ancho).
- Un elemento con `display: inline` (solo su contenido).
- Un elemento con `display: inline-block` (admite width/height).
- El `inline-block` debe tener `width` y `height`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `block` siempre empieza en nueva línea y ocupa todo el ancho.
- `inline` no respeta width/height.
- `inline-block` es como inline pero admite dimensiones.

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
  <title>Display</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="block">Soy block</div>
  <span class="inline">Soy inline</span>
  <span class="inline-block">Soy inline-block</span>
</body>
</html>
```

**style.css**:
```css
.block { display: block; background: #dbeafe; }
.inline { display: inline; background: #fef3c7; }
.inline-block {
  display: inline-block;
  width: 150px;
  height: 80px;
  background: #dcfce7;
}
```

</details>
