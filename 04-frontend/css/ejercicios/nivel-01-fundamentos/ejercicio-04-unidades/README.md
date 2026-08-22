# Ejercicio 04 — Unidades relativas (rem, em, %, vh)

## Enunciado

Crea un `index.html` y un `style.css` que usen `rem`, `em`, `%`, `vw` y `vh` en distintos elementos.

## Requisitos

- Un `font-size` en `rem`.
- Un `padding` o `margin` en `em`.
- Un `width` o `max-width` en `%`.
- Una sección con `height: 100vh`.
- Un elemento con `font-size` en `vw` o usando `clamp()`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `rem` es relativo al tamaño raíz (16px por defecto).
- `em` es relativo al font-size del elemento padre.
- `clamp(mín, preferido, máx)` crea valores fluidos.

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
  <title>Unidades</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <section class="hero">
    <h1 class="hero__titulo">Título</h1>
    <p class="hero__texto">Texto</p>
  </section>
  <div class="caja">Caja al 50%</div>
</body>
</html>
```

**style.css**:
```css
body { font-size: 1rem; }

.hero {
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.hero__titulo {
  font-size: clamp(2rem, 5vw, 4rem);
  padding: 0.5em;
}

.hero__texto { font-size: 1.2rem; }

.caja {
  width: 50%;
  padding: 1em;
  background: #dbeafe;
}
```

</details>
