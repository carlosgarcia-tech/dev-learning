# Ejercicio 03 — MutationObserver

## Enunciado

Crea un `script.js` que use `MutationObserver` para detectar cuándo se añaden elementos a un contenedor.

## Requisitos

- `script.js` con `defer`.
- Uso de `new MutationObserver`.
- Observar `childList: true` y `subtree: true`.
- En el callback, iterar `mutations` y revisar `addedNodes`.
- Un botón que añade elementos al contenedor.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `MutationObserver((mutations) => { ... })` define el callback.
- `mutations.forEach((m) => m.addedNodes.forEach(...))` recorre los nodos añadidos.
- `observer.observe(contenedor, { childList: true, subtree: true })` inicia la observación.

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
  <title>MutationObserver</title>
  <script src="script.js" defer></script>
</head>
<body>
  <button id="agregar">Agregar item</button>
  <ul id="contenedor"></ul>
  <div id="log"></div>
</body>
</html>
```

**script.js**:
```js
const contenedor = document.querySelector('#contenedor');
const log = document.querySelector('#log');

const observer = new MutationObserver((mutations) => {
  mutations.forEach((m) => {
    m.addedNodes.forEach((n) => {
      log.textContent = `Añadido: ${n.textContent}`;
    });
  });
});

observer.observe(contenedor, { childList: true, subtree: true });

document.querySelector('#agregar').addEventListener('click', () => {
  const li = document.createElement('li');
  li.textContent = `Item ${contenedor.children.length + 1}`;
  contenedor.appendChild(li);
});
```

</details>
