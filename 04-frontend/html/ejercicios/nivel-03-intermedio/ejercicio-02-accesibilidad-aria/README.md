# Ejercicio 02 — Accesibilidad con ARIA

## Enunciado

Crea un `index.html` con un acordeón accesible: botones con `aria-expanded`, `aria-controls`, y paneles con `role="region"` y `hidden`.

## Requisitos

- Al menos 2 botones con `aria-expanded="false"` y `aria-controls`.
- Al menos 2 paneles con `id`, `role="region"` y `aria-labelledby`.
- Los paneles con `hidden` por defecto.
- Un `<script>` que alterne `hidden` y `aria-expanded` al hacer clic.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `aria-controls` apunta al `id` del panel que controla el botón.
- `aria-expanded="true"` indica que el panel está abierto.
- `hidden` es un atributo HTML que oculta el elemento.

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
  <title>Acordeón</title>
</head>
<body>
  <h1>FAQ</h1>

  <button type="button" aria-expanded="false" aria-controls="p1">¿Qué es HTML?</button>
  <div id="p1" role="region" aria-labelledby="t1" hidden>
    <h3 id="t1">¿Qué es HTML?</h3>
    <p>Es un lenguaje de marcado para la web.</p>
  </div>

  <button type="button" aria-expanded="false" aria-controls="p2">¿Qué es CSS?</button>
  <div id="p2" role="region" aria-labelledby="t2" hidden>
    <h3 id="t2">¿Qué es CSS?</h3>
    <p>Es un lenguaje de estilos.</p>
  </div>

  <script>
    document.querySelectorAll('button[aria-expanded]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const panel = document.getElementById(btn.getAttribute('aria-controls'));
        const abierto = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', !abierto);
        panel.hidden = abierto;
      });
    });
  </script>
</body>
</html>
```

</details>
