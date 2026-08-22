# Ejercicio 05 — Accesibilidad WCAG completa

## Enunciado

Crea un `index.html` con una página accesible: landmarks, `aria-current`, `aria-label` en iconos, `skip link`, focus visible y `lang`.

## Requisitos

- Un "skip link" como primer elemento del body: `<a href="#contenido" class="skip">Saltar al contenido</a>`.
- `<main id="contenido">` como destino del skip link.
- `aria-current="page"` en el enlace de navegación activo.
- Un botón con solo icono que tenga `aria-label`.
- Un `aria-hidden="true"` en un icono decorativo SVG.
- `<html lang="es">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El skip link permite a usuarios de teclado saltar la navegación e ir al contenido.
- `aria-current="page"` indica la página actual en la navegación.
- Un icono SVG decorativo se marca con `aria-hidden="true"`.

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
  <title>Accesibilidad</title>
  <style>
    .skip {
      position: absolute;
      left: -9999px;
    }
    .skip:focus {
      left: 10px;
      top: 10px;
      background: #000;
      color: #fff;
      padding: 8px;
    }
  </style>
</head>
<body>
  <a href="#contenido" class="skip">Saltar al contenido</a>

  <header>
    <nav aria-label="Principal">
      <a href="/" aria-current="page">Inicio</a>
      <a href="/blog">Blog</a>
      <a href="/contacto">Contacto</a>
    </nav>
  </header>

  <main id="contenido">
    <h1>Bienvenido</h1>
    <p>Contenido principal de la página.</p>

    <button type="button" aria-label="Buscar">
      <svg aria-hidden="true" width="20" height="20" viewBox="0 0 20 20">
        <circle cx="9" cy="9" r="7" fill="none" stroke="currentColor" stroke-width="2"/>
        <line x1="14" y1="14" x2="18" y2="18" stroke="currentColor" stroke-width="2"/>
      </svg>
    </button>
  </main>
</body>
</html>
```

</details>
