# Proyecto final — CSS

## Landing page responsive (solo CSS)

Construye una landing page completa y responsive usando únicamente HTML y CSS. El objetivo es demostrar dominio de selectores, box model, flexbox, grid, responsive y animaciones.

### Requisitos

- Reset CSS universal con `box-sizing: border-box`.
- Variables CSS para colores, tipografía y espaciados.
- Layout completo con CSS Grid (`grid-template-areas`): header, nav, main, aside, footer.
- Navbar con flexbox, alineado con `justify-content: space-between`.
- Sección hero a pantalla completa (`100vh`) con centrado perfecto (flexbox).
- Galería de tarjetas responsive con `repeat(auto-fit, minmax(...))`.
- Tipografía fluida con `clamp()`.
- Media queries mobile-first (mínimo 2 breakpoints).
- Tema oscuro con `prefers-color-scheme`.
- Animaciones: transiciones en hover de botones y cards, animación de entrada con `@keyframes`.
- Respeto a `prefers-reduced-motion`.
- Nomenclatura BEM en las clases.
- Los tests pasan: `bash test.sh`

### Pistas

<details>
<summary>Mostrar pistas</summary>

- Empieza por las variables CSS en `:root` y el reset.
- Usa `grid-template-areas` para el layout principal y media queries para reorganizarlo en móvil.
- Para el tema oscuro, solo cambia las variables dentro de `@media (prefers-color-scheme: dark)`.
- Las animaciones de entrada usan `@keyframes` con `opacity` y `transform: translateY`.

</details>

### Solución

<details>
<summary>Mostrar solución</summary>

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Landing</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="layout">
    <header class="layout__header">
      <div class="navbar">
        <div class="navbar__logo">MiMarca</div>
        <nav class="navbar__nav">
          <a href="#" class="navbar__link">Inicio</a>
          <a href="#" class="navbar__link">Productos</a>
          <a href="#" class="navbar__link">Contacto</a>
        </nav>
      </div>
    </header>
    <main class="layout__main">
      <section class="hero">
        <h1 class="hero__titulo">Bienvenido</h1>
        <p class="hero__texto">La mejor solución para ti.</p>
        <button class="hero__boton">Empezar</button>
      </section>
      <section class="galeria">
        <div class="tarjeta">Card 1</div>
        <div class="tarjeta">Card 2</div>
        <div class="tarjeta">Card 3</div>
      </section>
    </main>
    <footer class="layout__footer">
      <p>&copy; 2026 MiMarca</p>
    </footer>
  </div>
</body>
</html>
```

```css
:root {
  --color-primario: #3b82f6;
  --color-fondo: #ffffff;
  --color-texto: #1a1a1a;
  --espaciado: 16px;
  --fuente: system-ui, sans-serif;
}

@media (prefers-color-scheme: dark) {
  :root {
    --color-fondo: #1a1a1a;
    --color-texto: #ffffff;
  }
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: var(--fuente);
  background: var(--color-fondo);
  color: var(--color-texto);
}

.layout {
  display: grid;
  grid-template-areas:
    "header"
    "main"
    "footer";
  min-height: 100vh;
}
.layout__header { grid-area: header; }
.layout__main { grid-area: main; }
.layout__footer { grid-area: footer; }

.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--espaciado);
}

.hero {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  text-align: center;
  animation: aparecer 0.6s ease;
}
.hero__titulo { font-size: clamp(2rem, 5vw, 3.5rem); }
.hero__boton {
  background: var(--color-primario);
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  cursor: pointer;
  transition: transform 0.2s ease;
}
.hero__boton:hover { transform: translateY(-2px); }

.galeria {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: var(--espaciado);
  padding: var(--espaciado);
}
.tarjeta {
  padding: var(--espaciado);
  border: 1px solid #ddd;
  border-radius: 8px;
  transition: transform 0.2s ease;
}
.tarjeta:hover { transform: translateY(-4px); }

@keyframes aparecer {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

</details>
