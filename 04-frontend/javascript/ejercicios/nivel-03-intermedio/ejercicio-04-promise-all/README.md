# Ejercicio 04 — Promise.all (peticiones paralelas)

## Enunciado

Crea un `script.js` que use `Promise.all` para hacer dos fetch en paralelo y mostrar ambos resultados.

## Requisitos

- `script.js` con `defer`.
- Uso de `Promise.all` con dos `fetch`.
- Uso de `async/await`.
- Destructuring del resultado: `const [a, b] = await Promise.all([...])`.
- Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Promise.all([p1, p2])` ejecuta ambas promesas en paralelo.
- Devuelve un array con los resultados en el mismo orden.
- Es más rápido que hacerlas secuencialmente con `await`.

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
  <title>Promise.all</title>
  <script src="script.js" defer></script>
</head>
<body>
  <div id="resultado"></div>
</body>
</html>
```

**script.js**:
```js
async function cargarDatos() {
  const [res1, res2] = await Promise.all([
    fetch('https://jsonplaceholder.typicode.com/users/1'),
    fetch('https://jsonplaceholder.typicode.com/posts/1')
  ]);

  const usuario = await res1.json();
  const post = await res2.json();

  document.querySelector('#resultado').innerHTML = `
    <p>Usuario: ${usuario.name}</p>
    <p>Post: ${post.title}</p>
  `;
}

cargarDatos();
```

</details>
