# Ejercicio 04 — Custom Element básico

## Enunciado

Crea un `index.html` que defina un custom element `<saludo-personalizado>` que muestre un saludo usando el atributo `nombre`.

## Requisitos

- Un `<script>` que defina una clase que extienda `HTMLElement`.
- `customElements.define('saludo-personalizado', ...)`.
- El componente lee el atributo `nombre` en `connectedCallback`.
- Usa el componente en el body: `<saludo-personalizado nombre="Ada">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El nombre del custom element debe llevar guion.
- `this.getAttribute('nombre')` lee el atributo.
- `connectedCallback` se ejecuta al insertarse en el DOM.

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
  <title>Custom Element</title>
</head>
<body>
  <h1>Custom Element</h1>
  <saludo-personalizado nombre="Ada"></saludo-personalizado>

  <script>
    class SaludoPersonalizado extends HTMLElement {
      connectedCallback() {
        const nombre = this.getAttribute('nombre') || 'mundo';
        this.innerHTML = `<p>Hola, ${nombre}!</p>`;
      }
    }
    customElements.define('saludo-personalizado', SaludoPersonalizado);
  </script>
</body>
</html>
```

</details>
