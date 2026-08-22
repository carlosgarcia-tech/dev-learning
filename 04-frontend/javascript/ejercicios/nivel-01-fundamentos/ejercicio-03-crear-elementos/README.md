# Ejercicio 03 — Crear y eliminar elementos

## Enunciado

Crea un `index.html` con un `<ul id="lista">` y un `script.js` que cree 3 `<li>` con `createElement` y los añada con `appendChild`.

## Requisitos

- Un `<ul id="lista">` vacío.
- `script.js` con `defer`.
- Uso de `document.createElement('li')`.
- Uso de `textContent` para el texto de cada `li`.
- Uso de `appendChild` para añadirlos a la lista.
- Un bucle o 3 creaciones manuales.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `document.createElement('li')` crea un nuevo `<li>`.
- `elemento.textContent = 'texto'` le pone texto.
- `lista.appendChild(li)` lo añade al final.

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
  <title>Crear elementos</title>
  <script src="script.js" defer></script>
</head>
<body>
  <ul id="lista"></ul>
</body>
</html>
```

**script.js**:
```js
const lista = document.querySelector('#lista');
const items = ['Manzana', 'Pera', 'Plátano'];

items.forEach((fruta) => {
  const li = document.createElement('li');
  li.textContent = fruta;
  lista.appendChild(li);
});
```

</details>
