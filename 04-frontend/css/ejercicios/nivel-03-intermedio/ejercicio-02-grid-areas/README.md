# Ejercicio 02 — Grid con grid-template-areas

## Enunciado

Crea un `index.html` y un `style.css` con un layout completo usando `grid-template-areas`: header, nav, main, aside y footer.

## Requisitos

- Un contenedor grid con `grid-template-areas`.
- Áreas: `header`, `nav`, `main`, `aside`, `footer`.
- Cada área asignada a un elemento con `grid-area`.
- `min-height: 100vh` en el contenedor.
- `gap`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Define las áreas con strings, una fila por línea entre comillas.
- Asigna cada elemento con `grid-area: nombre;`.
- Un área puede ocupar varias celdas repitiendo el nombre.

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
  <title>Grid areas</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="layout">
    <header class="layout__header">Header</header>
    <nav class="layout__nav">Nav</nav>
    <main class="layout__main">Main</main>
    <aside class="layout__aside">Aside</aside>
    <footer class="layout__footer">Footer</footer>
  </div>
</body>
</html>
```

**style.css**:
```css
.layout {
  display: grid;
  grid-template-columns: 200px 1fr;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    "header header"
    "nav    main"
    "footer footer";
  min-height: 100vh;
  gap: 12px;
}

.layout__header { grid-area: header; background: #1a1a1a; color: white; }
.layout__nav { grid-area: nav; background: #f0f0f0; }
.layout__main { grid-area: main; background: #dbeafe; }
.layout__aside { grid-area: aside; background: #fef3c7; }
.layout__footer { grid-area: footer; background: #3b82f6; color: white; }
```

</details>
