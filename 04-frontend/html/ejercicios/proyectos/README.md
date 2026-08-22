# Proyecto final — HTML

## Portafolio web estático (solo HTML)

Construye un portafolio personal completo usando únicamente HTML (puedes incluir un `<style>` mínimo interno). El objetivo es demostrar dominio de estructura, semántica, accesibilidad, SEO y multimedia.

### Requisitos

- Estructura completa: `<!DOCTYPE html>`, `<html lang="es">`, `<head>` con charset, viewport, title y description.
- Encabezado con `<header>`, `<nav>` con enlaces internos (anclas a secciones).
- Sección "Sobre mí" con `<main>`, `<article>` y un encabezado `h1` único.
- Sección "Proyectos" con una galería de imágenes (`<figure>` + `<figcaption>`).
- Sección "Experiencia" con una tabla accesible (`<caption>`, `<thead>`, `scope`).
- Formulario de contacto con `<fieldset>`, `<legend>`, labels asociados y validación HTML5.
- Multimedia: un `<video>` o `<audio>` con `<track>` de subtítulos.
- SEO: meta tags Open Graph y datos estructurados JSON-LD (`Person`).
- Accesibilidad: `aria-current` en el enlace activo, `alt` en todas las imágenes, `aria-label` en iconos.
- Un Web Component nativo (`<mi-reloj>`) con Shadow DOM.
- Los tests pasan: `bash test.sh`

### Pistas

<details>
<summary>Mostrar pistas</summary>

- Empieza por la estructura del `<head>` y los landmarks (`header`, `main`, `footer`).
- Para el JSON-LD usa `@type: "Person"` con `name`, `jobTitle`, `url`.
- El custom element `mi-reloj` puede mostrar la hora con `setInterval`.
- Recuerda `rel="noopener"` en los enlaces externos con `target="_blank"`.

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
  <title>Ada Lovelace — Portafolio</title>
  <meta name="description" content="Portafolio de Ada Lovelace, matemática y primera programadora.">
  <meta property="og:title" content="Ada Lovelace — Portafolio">
  <meta property="og:description" content="Matemática y primera programadora.">
  <meta property="og:image" content="https://ada.dev/og.jpg">
  <meta property="og:type" content="website">
  <link rel="manifest" href="manifest.json">
</head>
<body>
  <header>
    <h1>Ada Lovelace</h1>
    <nav aria-label="Principal">
      <a href="#sobre-mi" aria-current="page">Sobre mí</a>
      <a href="#proyectos">Proyectos</a>
      <a href="#experiencia">Experiencia</a>
      <a href="#contacto">Contacto</a>
    </nav>
  </header>
  <main>
    <article id="sobre-mi">
      <h2>Sobre mí</h2>
      <p>Soy matemática y trabajo en el primer algoritmo para una máquina calculadora.</p>
      <mi-reloj></mi-reloj>
    </article>
    <section id="proyectos">
      <h2>Proyectos</h2>
      <figure>
        <img src="proyecto1.jpg" alt="Diagrama del algoritmo de Bernoulli" width="400" height="300">
        <figcaption>Algoritmo de Bernoulli, 1843</figcaption>
      </figure>
    </section>
    <section id="experiencia">
      <h2>Experiencia</h2>
      <table>
        <caption>Trayectoria profesional</caption>
        <thead>
          <tr><th scope="col">Año</th><th scope="col">Puesto</th></tr>
        </thead>
        <tbody>
          <tr><th scope="row">1843</th><td>Analista matemática</td></tr>
        </tbody>
      </table>
    </section>
    <section id="contacto">
      <h2>Contacto</h2>
      <form action="/contacto" method="POST">
        <fieldset>
          <legend>Escríbeme</legend>
          <label for="nombre">Nombre</label>
          <input type="text" id="nombre" name="nombre" required>
          <label for="email">Email</label>
          <input type="email" id="email" name="email" required>
          <button type="submit">Enviar</button>
        </fieldset>
      </form>
    </section>
  </main>
  <footer><p>&copy; 2026 Ada Lovelace</p></footer>
  <script type="application/ld+json">
  { "@context": "https://schema.org", "@type": "Person",
    "name": "Ada Lovelace", "jobTitle": "Matemática", "url": "https://ada.dev" }
  </script>
  <script>
    class MiReloj extends HTMLElement {
      connectedCallback() {
        const s = this.attachShadow({mode:'open'});
        const tick = () => { s.textContent = new Date().toLocaleTimeString('es-ES'); };
        tick(); setInterval(tick, 1000);
      }
    }
    customElements.define('mi-reloj', MiReloj);
  </script>
</body>
</html>
```

</details>
