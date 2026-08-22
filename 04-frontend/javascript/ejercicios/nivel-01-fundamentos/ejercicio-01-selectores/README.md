# Ejercicio 01 — Seleccionar elementos del DOM

## Enunciado

Crea un `index.html` con varios elementos y un `script.js` que use `querySelector` y `querySelectorAll` para seleccionarlos y mostrarlos por consola.

## Requisitos

- Un `index.html` con un `h1` (id="titulo"), dos `p` (class="texto") y un `button` (id="boton").
- Un `script.js` enlazado con `defer`.
- `querySelector('#titulo')` para seleccionar el h1.
- `querySelectorAll('.texto')` para seleccionar los párrafos.
- `console.log` de ambos.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Enlaza el script con `<script src="script.js" defer></script>`.
- `querySelectorAll` devuelve un NodeList que se puede recorrer con `forEach`.
- `defer` asegura que el DOM esté listo al ejecutar el script.

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
  <title>Selectores</title>
  <script src="script.js" defer></script>
</head>
<body>
  <h1 id="titulo">Hola</h1>
  <p class="texto">Párrafo 1</p>
  <p class="texto">Párrafo 2</p>
  <button id="boton">Clic</button>
</body>
</html>
```

**script.js**:
```js
const titulo = document.querySelector('#titulo');
const parrafos = document.querySelectorAll('.texto');

console.log(titulo);
parrafos.forEach(p => console.log(p));
```

</details>
