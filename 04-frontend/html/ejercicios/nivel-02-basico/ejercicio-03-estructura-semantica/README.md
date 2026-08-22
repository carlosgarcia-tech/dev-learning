# Ejercicio 03 — Estructura semántica de una página

## Enunciado

Crea un `index.html` con la estructura semántica completa de una página de blog: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`, `<footer>`.

## Requisitos

- Un `<header>` con un `<h1>` y un `<nav>`.
- Un `<main>` que contenga un `<article>`.
- El `<article>` con un `<h2>` y al menos un `<section>` con `<h3>`.
- Un `<aside>` fuera del `<article>` con contenido relacionado.
- Un `<footer>` con copyright.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `<main>` debe ser único por página y contener el contenido principal.
- `<article>` es autónomo y reutilizable (un post, una noticia).
- `<aside>` es contenido relacionado pero no esencial (barra lateral).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mi Blog</title>
</head>
<body>
  <header>
    <h1>Mi Blog</h1>
    <nav>
      <a href="/">Inicio</a>
      <a href="/blog">Blog</a>
      <a href="/sobre-mi">Sobre mí</a>
    </nav>
  </header>

  <main>
    <article>
      <h2>Aprender HTML semántico</h2>
      <p>El HTML semántico describe el significado del contenido.</p>
      <section>
        <h3>Por qué importa</h3>
        <p>Mejora accesibilidad y SEO.</p>
      </section>
    </article>

    <aside>
      <h2>Relacionados</h2>
      <ul>
        <li><a href="/post2">CSS Grid</a></li>
        <li><a href="/post3">Flexbox</a></li>
      </ul>
    </aside>
  </main>

  <footer>
    <p>&copy; 2026 Mi Blog</p>
  </footer>
</body>
</html>
```

</details>
