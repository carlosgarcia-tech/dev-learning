# Ejercicio 02 — Fetch y JSON

- **Nivel:** 4/5
- **Tema:** fetch, JSON, manejo de errores
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `fetch-json.js` que use la API pública gratuita `https://jsonplaceholder.typicode.com` (requiere conexión a internet):

1. Con `fetch`, obtenga el *todo* con `id = 1` de `https://jsonplaceholder.typicode.com/todos/1`.
2. Compruebe `respuesta.ok` y, si no es verdadero, lance un `Error` con el código de estado.
3. Convierta la respuesta a JSON con `respuesta.json()`.
4. Imprima el `title` y si `completed` es `true` o `false`.
5. Defina una función `async` `obtenerVarios()` que con `Promise.all` obtenga los todos 1, 2 y 3 en paralelo e imprima cuántos están completados.
6. Envuelva las llamadas en try/catch y en caso de error imprima `"Fallo: " + error.message`.

Salida esperada (aproximada, depende de la API):

```
Todo 1: "delectus aut autem" - completado: false
Completados de los 3 primeros: 1
```

## Requisitos

- [ ] Usar `fetch` con `await` dentro de `async`.
- [ ] Validar `respuesta.ok` y lanzar error si hay fallo HTTP.
- [ ] Procesar JSON con `respuesta.json()`.
- [ ] Usar `Promise.all` con varias peticiones.
- [ ] Ejecutarlo localmente con `node fetch-json.js` (Node 18+ incluye `fetch`) y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `fetch` devuelve una promesa; usa `await fetch(url)`.
- `respuesta.ok` es `true` para estados 2xx.
- `const datos = await respuesta.json();` convierte el body a objeto.
- `Promise.all([...])` recibe un array de promesas.
- En Node < 18 `fetch` no existe; usa `node --version` para comprobarlo o instala Node 18+.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const BASE = "https://jsonplaceholder.typicode.com/todos";

async function obtenerTodo(id) {
  const respuesta = await fetch(`${BASE}/${id}`);
  if (!respuesta.ok) {
    throw new Error(`HTTP ${respuesta.status}`);
  }
  return respuesta.json();
}

async function mostrarUno() {
  try {
    const todo = await obtenerTodo(1);
    console.log(
      `Todo 1: "${todo.title}" - completado: ${todo.completed}`
    );
  } catch (error) {
    console.log(`Fallo: ${error.message}`);
  }
}

async function obtenerVarios() {
  try {
    const todos = await Promise.all([obtenerTodo(1), obtenerTodo(2), obtenerTodo(3)]);
    const completados = todos.filter((t) => t.completed).length;
    console.log(`Completados de los 3 primeros: ${completados}`);
  } catch (error) {
    console.log(`Fallo: ${error.message}`);
  }
}

mostrarUno();
obtenerVarios();
````

</details>