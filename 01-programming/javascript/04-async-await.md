# 04 — Async/Await y asincronía

## Objetivos

- [ ] Entender el modelo de ejecución asíncrono de JavaScript (event loop).
- [ ] Usar callbacks y reconocer el *callback hell*.
- [ ] Crear y consumir promesas con `then`/`catch`.
- [ ] Escribir código con `async`/`await` y manejar errores con try/catch.
- [ ] Combinar tareas con `Promise.all`, `Promise.allSettled` y `Promise.race`.
- [ ] Realizar peticiones con `fetch` y procesar JSON.

## Apuntes

### ¿Por qué async?

JavaScript es de un solo hilo. Las operaciones de entrada/salida (red, disco, timers) son lentas, así que no deben bloquear el programa. En su lugar se programan como **callbacks**, **promesas** o con **async/await**, y el *event loop* las retoma cuando terminan.

```javascript
console.log("1: inicio");
setTimeout(() => console.log("2: timer 0ms"), 0);
console.log("3: fin");
// Orden: 1, 3, 2  (el timer se aplaza al event loop)
```

### Callbacks

Una función pasada como argumento que se ejecuta cuando algo termina.

```javascript
function leerYMostrar(callback) {
  setTimeout(() => callback("dato leído"), 1000);
}
leerYMostrar((dato) => console.log(dato)); // "dato leído"
```

Anidar muchos callbacks produce el famoso *callback hell* (pirámide de la perdición). Las promesas lo resuelven.

### Promesas

Una promesa es un objeto que representa un resultado **futuro**: puede resolverse (`resolve`) o rechazarse (`reject`).

```javascript
function esperar(ms) {
  return new Promise((resolve, reject) => {
    if (ms < 0) {
      reject(new Error("Tiempo negativo"));
      return;
    }
    setTimeout(() => resolve(`Esperé ${ms} ms`), ms);
  });
}

esperar(100)
  .then((mensaje) => console.log(mensaje))
  .catch((error) => console.error("Error:", error.message));
```

Los estados de una promesa son: **pending** (pendiente), **fulfilled** (resuelta) y **rejected** (rechazada).

### async/await

`async` declara una función que devuelve una promesa. `await` pausa la ejecución hasta que la promesa se resuelve, y solo puede usarse dentro de una función `async`. Es azúcar sintáctico sobre `then`.

```javascript
async function principal() {
  try {
    const mensaje = await esperar(200);
    console.log(mensaje);
  } catch (error) {
    console.error("Falló:", error.message);
  }
}
principal();
```

### Combinar promesas

- `Promise.all([...])` — espera a **todas**; si una falla, falla todo.
- `Promise.allSettled([...])` — espera a todas y reporta cuáles fueron bien/mal.
- `Promise.race([...])` — resuelve con la primera que termine.

```javascript
const tareas = [esperar(300), esperar(100), esperar(500)];
Promise.all(tareas).then((resultados) => console.log(resultados));
// ["Esperé 300 ms", "Esperé 100 ms", "Esperé 500 ms"] (al terminar todas)
```

### fetch

`fetch` realiza peticiones HTTP y devuelve una promesa. La respuesta se procesa con `.json()`, `.text()`, etc. `response.ok` indica si el estado HTTP fue exitoso (2xx).

```javascript
async function obtenerUsuario() {
  try {
    const respuesta = await fetch("https://jsonplaceholder.typicode.com/todos/1");
    if (!respuesta.ok) {
      throw new Error(`HTTP ${respuesta.status}`);
    }
    const datos = await respuesta.json();
    console.log(datos.title);
  } catch (error) {
    console.error("Error de red o HTTP:", error.message);
  }
}
obtenerUsuario();
```

Nota: `fetch` está disponible de forma global en navegadores y en Node.js 18+.

### Manejo de errores en async

`await` convierte el rechazo de una promesa en una excepción lanzada, así que se captura con `try/catch`. También puedes usar `.catch()` encadenado, o `try/catch/finally`.

```javascript
async function segura() {
  try {
    const r = await fetch("https://url-invalida.com");
    const data = await r.json();
    return data;
  } catch (e) {
    console.error("No se pudo completar:", e.message);
    return null; // valor por defecto
  } finally {
    console.log("Siempre se ejecuta, haya error o no");
  }
}
```

## Ejemplos de código

```javascript
// Petición en paralelo con Promise.all
async function datosEnParalelo() {
  const urls = [
    "https://jsonplaceholder.typicode.com/todos/1",
    "https://jsonplaceholder.typicode.com/todos/2",
    "https://jsonplaceholder.typicode.com/todos/3",
  ];
  const promesas = urls.map((u) => fetch(u).then((r) => r.json()));
  const resultados = await Promise.all(promesas);
  console.log(resultados.map((r) => r.title));
}
datosEnParalelo().catch((e) => console.error(e.message));
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)

## Errores comunes

- **Olvidar `await`** → obtienes una promesa pendiente en lugar del valor.
- **Usar `await` fuera de `async`** → `SyntaxError: await is only valid in async functions`.
- **No comprobar `response.ok`** → `fetch` no rechaza en errores HTTP 404/500; solo lo hace ante fallos de red.
- **No capturar errores con try/catch** → rechazo no manejado ("unhandled promise rejection").
- **`Promise.all` y una sola tarea que falle** → rechaza todo; usa `allSettled` si quieres tolerancia.
- **Bloquear el hilo con `while(true)` + async** → un bucle síncrono infinito congela el event loop.

## Recursos

- [MDN — Promesas](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide/Using_promises)
- [MDN — async/await](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Statements/async_function)
- [MDN — fetch](https://developer.mozilla.org/es/docs/Web/API/Fetch_API)
- [MDN — Event loop](https://developer.mozilla.org/es/docs/Web/JavaScript/EventLoop)
- [JavaScript.info — Asincronía](https://es.javascript.info/async)