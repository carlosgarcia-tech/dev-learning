# Ejercicio 01 — Web Component con Shadow DOM y slots

## Enunciado

Crea un `index.html` que defina un custom element `<tarjeta-producto>` con Shadow DOM que use `<slot>` para el título y el precio.

## Requisitos

- Un `<script>` que defina una clase `TarjetaProducto` que extienda `HTMLElement`.
- Uso de `this.attachShadow({ mode: 'open' })`.
- Estilos encapsulados dentro del shadow DOM (una etiqueta `<style>`).
- Un `<slot name="titulo">` y un `<slot name="precio">`.
- Uso del componente: `<tarjeta-producto>` con contenido en los slots.
- `customElements.define('tarjeta-producto', TarjetaProducto)`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `attachShadow({ mode: 'open' })` crea la raíz del shadow DOM.
- Los estilos dentro del shadow DOM no afectan al resto de la página.
- `<slot name="titulo">` se rellena con `<span slot="titulo">...</span>`.

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
  <title>Web Component</title>
</head>
<body>
  <h1>Productos</h1>

  <tarjeta-producto>
    <span slot="titulo">Café premium</span>
    <span slot="precio">12,99 €</span>
  </tarjeta-producto>

  <script>
    class TarjetaProducto extends HTMLElement {
      constructor() {
        super();
        const shadow = this.attachShadow({ mode: 'open' });
        shadow.innerHTML = `
          <style>
            :host { display: block; }
            .tarjeta {
              border: 1px solid #ddd;
              border-radius: 8px;
              padding: 16px;
              max-width: 250px;
              font-family: sans-serif;
            }
            .titulo { font-size: 1.2rem; font-weight: bold; }
            .precio { color: #16a34a; font-size: 1.4rem; }
          </style>
          <div class="tarjeta">
            <div class="titulo"><slot name="titulo">Producto</slot></div>
            <div class="precio"><slot name="precio">0 €</slot></div>
          </div>
        `;
      }
    }
    customElements.define('tarjeta-producto', TarjetaProducto);
  </script>
</body>
</html>
```

</details>
