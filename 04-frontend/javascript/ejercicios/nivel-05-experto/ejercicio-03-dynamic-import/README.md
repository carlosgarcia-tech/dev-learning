# Ejercicio 03 — Dynamic import

## Enunciado

Crea un `index.html` y un `main.js` que use `await import()` para cargar un módulo bajo demanda al hacer clic en un botón.

## Requisitos

- `index.html` con `<script type="module" src="main.js">` y un `<button id="btn">`.
- Un `editor.js` con un `export default`.
- `main.js` con `await import('./editor.js')` dentro de un event listener.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `import('./modulo.js')` devuelve una promesa con el módulo.
- Se usa `await` para esperar a que cargue.
- El default se accede con `.default` del módulo devuelto.

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
  <title>Dynamic import</title>
</head>
<body>
  <button id="btn">Abrir editor</button>
  <script type="module" src="main.js"></script>
</body>
</html>
```

**editor.js**:
```js
export default function abrirEditor() {
  console.log('Editor abierto');
}
```

**main.js**:
```js
document.querySelector('#btn').addEventListener('click', async () => {
  const modulo = await import('./editor.js');
  modulo.default();
});
```

</details>
