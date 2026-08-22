# Ejercicio 06 — Custom Element con lifecycle y atributos observados

## Enunciado

Crea un custom element `<contador-elemento>` que observe el atributo `valor`, lo muestre y tenga un botón para incrementar. Debe implementar `connectedCallback`, `disconnectedCallback` y `attributeChangedCallback`.

## Requisitos

- Un `<script>` que defina `ContadorElemento extends HTMLElement`.
- `static get observedAttributes()` que retorne `['valor']`.
- `connectedCallback` que renderice el HTML y añada un listener al botón.
- `attributeChangedCallback` que actualice la vista.
- `disconnectedCallback` que limpie el listener (o timer).
- Uso: `<contador-elemento valor="0">`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `attributeChangedCallback` se dispara solo para atributos en `observedAttributes`.
- Guarda la referencia al listener para poder quitarlo en `disconnectedCallback`.
- Usa `this.getAttribute('valor')` y actualiza con `this.setAttribute('valor', nuevo)`.

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
  <title>Contador</title>
</head>
<body>
  <h1>Contador</h1>
  <contador-elemento valor="0"></contador-elemento>

  <script>
    class ContadorElemento extends HTMLElement {
      static get observedAttributes() {
        return ['valor'];
      }

      connectedCallback() {
        this.render();
        this._onClick = () => {
          const actual = parseInt(this.getAttribute('valor') || '0', 10);
          this.setAttribute('valor', actual + 1);
        };
        this.querySelector('button').addEventListener('click', this._onClick);
      }

      attributeChangedCallback(name, oldVal, newVal) {
        if (name === 'valor') {
          const span = this.querySelector('span');
          if (span) span.textContent = newVal;
        }
      }

      disconnectedCallback() {
        const btn = this.querySelector('button');
        if (btn && this._onClick) btn.removeEventListener('click', this._onClick);
      }

      render() {
        const valor = this.getAttribute('valor') || '0';
        this.innerHTML = `
          <p>Valor: <span>${valor}</span></p>
          <button type="button">Incrementar</button>
        `;
      }
    }
    customElements.define('contador-elemento', ContadorElemento);
  </script>
</body>
</html>
```

</details>
