# Ejercicio 04 — Enlaces absolutos, relativos y anclas

## Enunciado

Crea un `index.html` con varios tipos de enlaces: uno absoluto externo (a example.com), uno relativo a `contacto.html`, uno con `target="_blank"`, y un enlace ancla a una sección `#seccion`.

## Requisitos

- Al menos 4 etiquetas `<a>`.
- Un enlace absoluto que empiece por `https://`.
- Un enlace relativo a `contacto.html`.
- Un enlace con `target="_blank"` y `rel="noopener noreferrer"`.
- Un enlace ancla con `href="#seccion"`.
- Un elemento con `id="seccion"` que sea destino del ancla.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Enlace absoluto: URL completa con protocolo.
- Enlace relativo: ruta sin dominio.
- `rel="noopener noreferrer"` previene que la página nueva acceda a `window.opener`.

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
  <title>Enlaces</title>
</head>
<body>
  <h1>Enlaces</h1>
  <nav>
    <a href="https://example.com">Example (absoluto)</a>
    <a href="contacto.html">Contacto (relativo)</a>
    <a href="https://example.com" target="_blank" rel="noopener noreferrer">Abrir en pestaña nueva</a>
    <a href="#seccion">Ir a la sección</a>
  </nav>

  <section id="seccion">
    <h2>Sección destino</h2>
    <p>Este es el destino del ancla.</p>
  </section>
</body>
</html>
```

</details>
