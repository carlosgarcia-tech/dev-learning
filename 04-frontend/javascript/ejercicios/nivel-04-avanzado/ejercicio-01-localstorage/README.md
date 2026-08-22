# Ejercicio 01 — localStorage guardar y leer

## Enunciado

Crea un `script.js` que guarde un objeto en `localStorage` y lo lea al recargar.

## Requisitos

- `script.js` con `defer`.
- Uso de `localStorage.setItem` con `JSON.stringify`.
- Uso de `localStorage.getItem` con `JSON.parse`.
- Un input y un botón para guardar el nombre.
- Mostrar el nombre guardado al cargar.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- localStorage solo guarda strings: usa `JSON.stringify` para objetos.
- Al leer, usa `JSON.parse` para convertir de vuelta a objeto.
- Comprueba si el valor existe antes de hacer `JSON.parse` (puede ser `null`).

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
  <title>localStorage</title>
  <script src="script.js" defer></script>
</head>
<body>
  <input type="text" id="nombre" placeholder="Tu nombre">
  <button id="guardar">Guardar</button>
  <div id="saludo"></div>
</body>
</html>
```

**script.js**:
```js
const input = document.querySelector('#nombre');
const boton = document.querySelector('#guardar');
const saludo = document.querySelector('#saludo');

function mostrarSaludo() {
  const guardado = localStorage.getItem('usuario');
  if (guardado) {
    const usuario = JSON.parse(guardado);
    saludo.textContent = `Hola, ${usuario.nombre}`;
  }
}

boton.addEventListener('click', () => {
  const usuario = { nombre: input.value };
  localStorage.setItem('usuario', JSON.stringify(usuario));
  mostrarSaludo();
});

mostrarSaludo();
```

</details>
