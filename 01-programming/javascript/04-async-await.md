# 04 — Async/Await y asincronía

## Objetivos

- [ ] Explicar por qué JavaScript, siendo de un solo hilo, no se bloquea con operaciones de entrada/salida.
- [ ] Describir el event loop, la call stack, la cola de microtareas y la de macrotareas.
- [ ] Predecir el orden de ejecución entre `setTimeout`, promesas y `async`/`await`.
- [ ] Usar callbacks con `setTimeout`/`setInterval`, los módulos `fs` y `http` de Node, y los *error-first callbacks*.
- [ ] Reconocer el *callback hell* y saber por qué las promesas lo mitigan.
- [ ] Crear promesas con `new Promise` y consumirlas con `then`/`catch`/`finally`.
- [ ] Encadenar promesas y manejar errores a lo largo de la cadena.
- [ ] Dominar `Promise.all`, `Promise.allSettled`, `Promise.race`, `Promise.any`, `Promise.resolve` y `Promise.reject`.
- [ ] Escribir código con `async`/`await` y manejar errores con `try/catch/finally`.
- [ ] Distinguir ejecución paralela de secuencial (`Promise.all` vs `await` en un bucle).
- [ ] Usar *top-level await* en módulos ESM.
- [ ] Realizar peticiones GET/POST con `fetch`, procesar JSON y comprobar `response.ok`.
- [ ] Aplicar `AbortController` para timeouts y cancelación.
- [ ] Reconocer los rechazos no manejados (`unhandledrejection`).
- [ ] Aplicar patrones comunes: secuencial, paralelo, productor-consumidor y retry con backoff.

## Apuntes

### ¿Por qué async?

JavaScript es de un solo hilo. Las operaciones de entrada/salida (red, disco, timers) son lentas, así que no deben bloquear el programa. En su lugar se programan como **callbacks**, **promesas** o con **async/await**, y el *event loop* las retoma cuando terminan.

```javascript
console.log("1: inicio");
setTimeout(() => console.log("2: timer 0ms"), 0);
console.log("3: fin");
// Orden: 1, 3, 2  (el timer se aplaza al event loop)
```

Un cálculo síncrono de un millón de iteraciones tarda milisegundos; una petición de red, cientos de milisegundos o más. Si el programa esperara de forma **bloqueante**, la interfaz se congelaría y no podría atender nada más. Por eso JS delega esas esperas al runtime y sigue ejecutando: la asincronía no es *multitarea*, es *delegación de esperas*.

### El modelo de concurrencia: call stack y event loop

JavaScript ejecuta **una sola tarea a la vez** sobre la **call stack** (pila de llamadas). Las operaciones asíncronas (timers, `fetch`, `fs`) se delegan al runtime y su "continuación" se encola; el **event loop**, cuando la pila queda vacía, ejecuta lo que corresponda.

Hay dos colas con prioridad distinta: **microtareas** (`.then`, `.catch`, `.finally`, `await`, `queueMicrotask`) y **macrotareas** (`setTimeout`, `setInterval`, I/O). Regla práctica: primero corre todo el código síncrono; después se vacían todas las microtareas; luego corre una macrotarea; y se repite el ciclo.

```javascript
console.log("A");                                // síncrono
setTimeout(() => console.log("B"), 0);           // macrotarea
Promise.resolve().then(() => console.log("C"));  // microtarea
console.log("D");                                // síncrono
// Orden: A, D, C, B
```

El `setTimeout` con 0 ms no es "inmediato": es una macrotarea y corre **después** de todas las microtareas. Por eso `C` gana a `B`. Las microtareas encoladas mientras se procesan otras también corren antes que la siguiente macrotarea. `await` pausa la función y encola una microtarea; cuando el resto del código síncrono termina, la función continúa.

### Callbacks

Una función pasada como argumento que se ejecuta cuando algo termina.

```javascript
function leerYMostrar(callback) {
  setTimeout(() => callback("dato leído"), 1000);
}
leerYMostrar((dato) => console.log(dato)); // "dato leído"
```

#### setTimeout, setInterval, clearTimeout y clearInterval

`setTimeout(fn, ms)` ejecuta `fn` una sola vez; `setInterval(fn, ms)` la repite cada `ms`. Ambos devuelven un identificador que se cancela con `clearTimeout`/`clearInterval`.

```javascript
const id = setTimeout(() => console.log("tarde"), 2000);
clearTimeout(id); // nunca se ejecuta

let contador = 0;
const intervalo = setInterval(() => {
  contador++;
  console.log(`tic ${contador}`);
  if (contador >= 3) clearInterval(intervalo);
}, 500);
// tic 1, tic 2, tic 3 (y se detiene)
```

#### fs y http en Node con error-first callbacks

Node expone APIs asíncronas basadas en callbacks: `fs` para archivos y `http` para servidores y peticiones. En la convención **error-first**, el primer argumento del callback es el error (`null` si no hubo) y el segundo, el resultado; el error nunca se lanza, se pasa como valor.

```javascript
const fs = require("node:fs");

fs.readFile("no-existe.txt", "utf8", (error, contenido) => {
  if (error) return console.error("Fallo:", error.code); // ENOENT
  console.log(contenido);
});
```

#### El problema del callback hell

Anidar muchos callbacks produce el famoso *callback hell* (pirámide de la perdición): sangría creciente, difícil de leer y de manejar errores de forma uniforme. Las promesas lo resuelven.

```javascript
// Antes (callbacks anidados)
const fs = require("node:fs");
fs.readFile("a.txt", "utf8", (e1, a) => {
  if (e1) return console.error(e1);
  fs.readFile("b.txt", "utf8", (e2, b) => {
    if (e2) return console.error(e2);
    console.log(a + b);
  });
});
```

`fs/promises` devuelve promesas directamente, así que la misma lógica queda plana y legible:

```javascript
const fs = require("node:fs/promises");

async function combinar() {
  const [a, b] = await Promise.all([
    fs.readFile("a.txt", "utf8"),
    fs.readFile("b.txt", "utf8"),
  ]);
  console.log(a + b);
}
combinar().catch((error) => console.error(error));
```

Nota: los `require` de estos ejemplos son de CommonJS; en ESM se usaría `import { readFile } from "node:fs/promises"`. Si tienes que adaptar una API antigua de callbacks, `util.promisify` la convierte en promesas.

### Promesas

Una promesa es un objeto que representa un resultado **futuro**: puede resolverse (`resolve`) o rechazarse (`reject`).

#### Estados y creación con new Promise

Una promesa nace en **pending** y pasa exactamente una vez a **fulfilled** (resuelta) o **rejected** (rechazada); no puede cambiar de estado después. El ejecutor recibe `resolve` y `reject`, se llama a uno de los dos **una única vez**, y lo que pase después se ignora.

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

#### then, catch y finally

- `then(ok, fail)` — consume el valor o el error; devuelve otra promesa, así que se encadena.
- `catch(fn)` — atrapa errores de pasos anteriores; equivale a `then(undefined, fn)`.
- `finally(fn)` — se ejecuta siempre, con o sin error; no recibe el valor y propaga el resultado tal cual (ver ejemplo en "Encadenamiento y retorno en then").

#### Encadenamiento y retorno en then

Cada `then` devuelve una promesa. Lo que retorne el callback determina su resultado:

- un valor cualquiera → promesa resuelta con ese valor;
- una promesa → se espera a esa promesa y se hereda su resultado;
- `throw` → promesa rechazada con ese error.

```javascript
function doble(n) {
  return new Promise((resolve) => setTimeout(() => resolve(n * 2), 100));
}

doble(2)
  .then((n) => doble(n))   // 4 (se espera la promesa devuelta)
  .then((n) => n + 10)     // 14 (valor directo)
  .then((n) => {
    console.log(n);
    throw new Error("error intencional");
  })
  .catch((error) => console.error("capturado:", error.message))
  .finally(() => console.log("fin de la cadena"));
```

Con la segunda forma del `then` también puedes manejar el error de un paso concreto: `promesa.then(valor => ..., error => ...)`.

#### Manejo de errores en la cadena

Un `.catch` al final atrapa cualquier rechazo de los pasos anteriores. Pero si el propio `.catch` falla (lanza), el error continúa y necesitas otro `.catch`. Un `.then` que sigue a un `.catch` solo se ejecuta si el `.catch` resolvió sin lanzar.

```javascript
Promise.reject(new Error("original"))
  .catch((e) => {
    console.error("1º:", e.message);
    throw new Error("sigue");
  })
  .catch((e) => console.error("2º:", e.message)); // atrapa el segundo
```

### async/await

`async` declara una función que devuelve una promesa. `await` pausa la ejecución hasta que la promesa se resuelve, y solo puede usarse dentro de una función `async`. Es azúcar sintáctico sobre `then`: más legible y con `try/catch` para errores.

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

#### Declaración y valor de retorno

Se declara como `async function`, arrow `async () => ...` o método `async metodo() {}`. Siempre devuelve una promesa: si retornas un valor, se envuelve en `Promise.resolve`; si lanzas, se rechaza.

```javascript
async function suma(a, b) {
  return a + b; // => Promise que resuelve con a + b
}
suma(2, 3).then((n) => console.log(n)); // 5

const falla = async () => {
  throw new Error("no");
};
falla().catch((e) => console.log(e.message)); // "no"
```

#### try/catch con await

`await` convierte un rechazo en una excepción: el control salta al `catch` más cercano. Como en sincronía, puedes usar `try/catch/finally`, con `return` de un valor por defecto en el `catch` (ver ejemplos en "fetch" y en "Errores en código asíncrono").

#### await con Promise.all

Un `await` solo espera **una** promesa. Para esperar varias a la vez, pasa un array a `Promise.all` y desestructura el resultado.

```javascript
async function enParalelo() {
  const [a, b, c] = await Promise.all([esperar(300), esperar(100), esperar(500)]);
  console.log(a, b, c); // las tres juntas, al terminar la última (~500 ms)
}
```

#### Paralelo vs secuencial

- `await` dentro de un bucle espera cada paso **antes** de lanzar el siguiente → **secuencial**.
- `Promise.all` lanza todas las tareas al mismo tiempo → **paralelo** (concurrencia real de esperas, no threads).

```javascript
// Secuencial: 100 + 200 + 300 = ~600 ms
async function secuencial() {
  const resultados = [];
  for (const ms of [100, 200, 300]) {
    resultados.push(await esperar(ms));
  }
  return resultados;
}

// Paralelo: tarda ~300 ms (el más lento)
async function paralela() {
  const resultados = await Promise.all([100, 200, 300].map((ms) => esperar(ms)));
  return resultados;
}
```

Usa secuencial solo cuando cada paso dependa del anterior (por ejemplo, `token → perfil → posts`).

#### Top-level await (ESM)

En un módulo ES (`.mjs` o `"type": "module"` en el `package.json`), `await` puede usarse directamente en el nivel superior, sin envolverlo en una función `async`. En CommonJS (`require`) lanza `SyntaxError`. Ideal para inicializar configuración, cargar datos al arrancar o scripts de una sola pasada.

```javascript
// archivo: init.mjs
import { readFile } from "node:fs/promises";

const config = JSON.parse(await readFile("config.json", "utf8"));
console.log(config.appName);
```

Ejecuta con `node init.mjs`. Funciona también en REPL y en `node --input-type=module`.

### La API de promesas: all, allSettled, race y any

- `Promise.all([...])` espera a **todas** y falla todo si una falla (fail-fast); `Promise.allSettled` reporta cada resultado y **nunca rechaza**.
- `Promise.race([...])` resuelve o rechaza con la primera que **termine**; `Promise.any` resuelve con la primera que **resuelva** (si todas rechazan, rechaza con `AggregateError`).

```javascript
const tareas = [esperar(300), esperar(100), esperar(500)];
Promise.all(tareas).then((resultados) => console.log(resultados));
// ["Esperé 300 ms", "Esperé 100 ms", "Esperé 500 ms"] (al terminar todas)
```

#### Promise.all

Si una promesa rechaza, `Promise.all` rechaza de inmediato con ese error y **no espera** a las demás. Útil cuando ninguna tarea puede faltar (por ejemplo, tres reportes obligatorios).

```javascript
Promise.all([Promise.resolve(1), Promise.reject(new Error("boom")), Promise.resolve(3)])
  .then((r) => console.log("todo:", r))
  .catch((e) => console.log("algo falló:", e.message)); // "boom"
```

#### Promise.allSettled

Reporta cada resultado como `{ status: "fulfilled", value }` o `{ status: "rejected", reason }`. Perfecto para tolerancia a fallos y resultados parciales.

```javascript
Promise.allSettled([esperar(100), esperar(-1), esperar(50)]).then((resultados) => {
  resultados.forEach((r) =>
    console.log(r.status === "fulfilled" ? `OK: ${r.value}` : `Error: ${r.reason.message}`)
  );
});
```

#### Promise.race y Promise.any

`race` devuelve la primera que **llegue**, sea éxito o fracaso; `any` ignora los rechazos y espera el primer éxito.

```javascript
// race: gana el primero en terminar
Promise.race([esperar(500), esperar(100)]).then((v) => console.log(v)); // "Esperé 100 ms"

// any: primer éxito, ignorando rechazos
Promise.any([esperar(-1), esperar(200)]).then((v) => console.log(v)); // "Esperé 200 ms"
```

#### Promise.resolve y Promise.reject

Permiten crear promesas ya resueltas o rechazadas sin ejecutor: útiles para valores por defecto, resultados en caché o mocks en tests.

```javascript
Promise.resolve(42).then((n) => console.log(n)); // 42
Promise.reject(new Error("fijo")).catch((e) => console.log(e.message));
```

### fetch

`fetch` realiza peticiones HTTP y devuelve una promesa que resuelve con el objeto `Response`. La respuesta se procesa con `.json()`, `.text()`, `.blob()`... `response.ok` indica si el estado HTTP fue exitoso (2xx). Está disponible de forma **global** en navegadores y en Node.js 18+ (antes se usaba el paquete `node-fetch` o axios).

#### GET y leer el body JSON

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

`fetch` **no rechaza** ante errores HTTP 404/500: la promesa resuelve igual. Solo rechaza por fallos de red (sin conexión, DNS, timeout). Por eso siempre compruebas `response.ok` (o `response.status`).

#### POST con cabeceras y body

Se pasa un objeto de opciones con `method`, `headers` y `body`. El body de JSON se serializa con `JSON.stringify`.

```javascript
async function crearPublicacion() {
  const respuesta = await fetch("https://jsonplaceholder.typicode.com/posts", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ title: "Hola", userId: 1 }),
  });
  if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
  const creado = await respuesta.json();
  console.log("Creado con id:", creado.id);
}
crearPublicacion().catch((e) => console.error(e.message));
```

Otras cabeceras habituales: `Authorization: Bearer <token>` o `Accept: application/json`. Recuerda que `.json()`, `.text()` y `.blob()` solo pueden llamarse **una vez** por respuesta.

#### AbortController y timeout

`fetch` no tiene timeout por defecto: una petición colgada puede esperar para siempre. Con `AbortController` puedes cancelarla y controlar el tiempo máximo.

```javascript
async function conTimeout(url, ms = 5000) {
  const controlador = new AbortController();
  const timer = setTimeout(() => controlador.abort(), ms);
  try {
    const respuesta = await fetch(url, { signal: controlador.signal });
    if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
    return await respuesta.json();
  } finally {
    clearTimeout(timer); // la señal ya no se usa
  }
}

conTimeout("https://jsonplaceholder.typicode.com/todos/1", 3000)
  .then((d) => console.log(d.title))
  .catch((e) => {
    if (e.name === "AbortError") console.error("Timeout: tardó demasiado");
    else console.error(e.message);
  });
```

Nota: los ejemplos de esta sección requieren **acceso a internet**. Para probar sin salir de la máquina, usa un servidor local (ver sección Ejemplos de código) y cambia la URL a `http://localhost:3000/...`.

### Patrones de programación asíncrona

Los siguientes patrones se repiten en casi todo software que trabaja con red, archivos o bases de datos. Usan `esperar(ms)`, definida antes, como tarea genérica.

**Secuencial** — cada paso depende del anterior (autenticar → pedir perfil → pedir posts): encadena `await` en orden (ver "Paralelo vs secuencial").

**Paralelo (fan-out / fan-in)** — lanza todas las tareas a la vez y espera con `Promise.all` (ver "await con Promise.all"); solo sirve si son independientes.

#### Productor-consumidor

Un productor encola tareas mientras los consumidores las procesan. Encadenar promesas garantiza orden sin bloquear la cola.

```javascript
async function colaEnOrden(tareas, trabajador) {
  let cadena = Promise.resolve();
  const resultados = [];
  for (const tarea of tareas) {
    cadena = cadena.then(async () => {
      resultados.push(await trabajador(tarea));
    });
  }
  await cadena;
  return resultados;
}

colaEnOrden([100, 200, 300], (ms) => esperar(ms)).then((r) => console.log(r.length)); // 3
```

#### Retry con backoff exponencial

Reintenta N veces con espera creciente (`50ms`, `100ms`, `200ms`...) más un poco de ruido para evitar sincronización entre procesos.

```javascript
async function conReintentos(fn, intentos = 3) {
  for (let i = 0; i < intentos; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === intentos - 1) throw error;
      const espera = 50 * 2 ** i + Math.random() * 50;
      await new Promise((r) => setTimeout(r, espera));
    }
  }
}

let fallos = 0;
const inestable = () => new Promise((res, rej) =>
  setTimeout(() => (fallos++ < 2 ? rej(new Error("ocupado")) : res("OK")), 100)
);

conReintentos(inestable, 4).then((r) => console.log(r)); // "OK" (al tercer intento)
```

#### Timeout con Promise.race

Enfrenta la promesa real contra un `setTimeout` que rechaza; el primero que termine decide.

```javascript
function conRace(promesa, ms = 3000) {
  const timer = new Promise((_, reject) =>
    setTimeout(() => reject(new Error("Timeout con race")), ms)
  );
  return Promise.race([promesa, timer]);
}

conRace(esperar(100), 5000).then((v) => console.log(v)); // la tarea gana
```

#### Cancelación con AbortController

`AbortController` permite cancelar peticiones desde fuera: un botón "cancelar", un componente que se desmonta, etc. (requiere red o un servidor local).

```javascript
const controlador = new AbortController();

async function pedido() {
  try {
    const datos = await fetch("/api/pedidos", { signal: controlador.signal });
    return await datos.json();
  } catch (e) {
    if (e.name === "AbortError") console.log("Cancelado por el usuario");
    else throw e;
  }
}

const tarea = pedido();
setTimeout(() => controlador.abort(), 100); // simula que el usuario cancela
```

La misma señal puede pasarse a varias peticiones a la vez, y `AbortSignal.timeout(ms)` (Node 17.3+ y navegadores) crea una señal que aborta sola: `fetch(url, { signal: AbortSignal.timeout(4000) })`.

### Errores en código asíncrono

#### try/catch y rechazos

Con `async/await` un rechazo se convierte en excepción y lo atrapa el `try/catch` más cercano; con `.then`, lo atrapa el siguiente `.catch` (ver los ejemplos de "fetch" y de "finally" más abajo). Un rechazo nunca se resuelve solo: si nadie lo maneja, se convierte en un **rechazo no manejado**.

#### Rechazos no manejados (unhandled rejection)

Si una promesa rechaza y no hay `.catch` ni `try/catch`, Node (o el navegador) lo avisa. En Node 15+ el proceso **termina** con un error de rechazo no manejado. La buena práctica es capturar siempre; además puedes registrar un manejador global para loguear y no morir en silencio.

```javascript
// Node
process.on("unhandledRejection", (razon) => {
  console.error("Rechazo no manejado:", razon);
});

// Navegadores
window.addEventListener("unhandledrejection", (evento) => {
  console.error("Promesa sin manejar:", evento.reason);
});
```

#### finally para limpieza

`finally` ejecuta su cuerpo pase lo que pase: cerrar conexiones, borrar timers, ocultar un spinner, liberar recursos. No recibe el valor ni el error, y propaga el resultado original.

```javascript
async function procesar(id) {
  const conn = await abrirConexion();
  try {
    return await consulta(conn, id);
  } catch (error) {
    console.error("Falló la consulta:", error.message);
    return null;
  } finally {
    await cerrarConexion(conn); // se ejecuta siempre
  }
}
```

Cuidado: si el `finally` lanza, ese error reemplaza al anterior. No pongas ahí operaciones que puedan fallar sin su propio try/catch.

## Ejemplos de código

```javascript
// Petición en paralelo con Promise.all (requiere internet)
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

```javascript
// server.mjs — servidor local mínimo para probar fetch sin internet
import { createServer } from "node:http";

const server = createServer((req, res) => {
  res.setHeader("Content-Type", "application/json");
  if (req.method === "POST") {
    let cuerpo = "";
    req.on("data", (c) => (cuerpo += c));
    req.on("end", () => {
      res.end(JSON.stringify({ ok: true, recibido: JSON.parse(cuerpo) }));
    });
    return;
  }
  res.end(JSON.stringify({ mensaje: "Hola desde el servidor local", ruta: req.url }));
});

server.listen(3000, () => console.log("Servidor en http://localhost:3000"));
// Ejecuta primero: node server.mjs
// Prueba el GET desde otro terminal:
//   node -e "fetch('http://localhost:3000/a').then(r=>r.json()).then(console.log)"
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)
  - [Ejercicio 01 — Async/Await](../ejercicios/nivel-04-avanzado/ejercicio-01-async-await/)
  - [Ejercicio 02 — Fetch y JSON](../ejercicios/nivel-04-avanzado/ejercicio-02-fetch-y-json/)

## Errores comunes

- **Olvidar `await`** → obtienes una promesa pendiente en lugar del valor; imprimes `Promise { <pending> }`.
- **Usar `await` fuera de `async`** → `SyntaxError: await is only valid in async functions`. En el nivel superior solo funciona en módulos ESM.
- **No comprobar `response.ok`** → `fetch` no rechaza en errores HTTP 404/500; solo lo hace ante fallos de red.
- **No capturar errores con try/catch** → rechazo no manejado ("unhandled promise rejection"); en Node 15+ el proceso termina.
- **`Promise.all` y una sola tarea que falle** → rechaza todo; usa `Promise.allSettled` si quieres tolerancia y resultado parcial.
- **Bloquear el hilo con `while (true)` + async** → un bucle síncrono infinito congela el event loop y nunca se ejecutan las promesas.
- **Suponer que `setTimeout(..., 0)` es inmediato** → es una macrotarea: se ejecuta después de todo el código síncrono y de todas las microtareas.
- **Llamar dos veces a `resolve` o `reject`** → la promesa solo cambia de estado una vez; el resto de llamadas se ignoran.
- **Olvidar `return` dentro del ejecutor** → si `reject` no va seguido de `return`, la función continúa y la promesa puede quedar en `pending`.
- **Anidar `await` en un bucle cuando las tareas son independientes** → secuencial y lento; usa `Promise.all` para paralelismo.
- **Esperar que `Promise.race` prefiera el éxito** → `race` devuelve la primera en terminar, aunque sea un rechazo; usa `Promise.any` si quieres el primer éxito.
- **`fetch` sin `AbortController` y colgado** → puede esperar para siempre; usa `AbortSignal.timeout(ms)` o un timeout manual.
- **Manejar el error con el segundo argumento de `then` y olvidar el `catch` final** → los errores lanzados dentro de ese `then` quedan sin atrapar.
- **Usar `finally` para devolver un valor** → `finally` no cambia el resultado; si quieres transformarlo, hazlo en un `then`.
- **Confundir `error-first` callbacks de Node con promesas** → en callbacks el error es el primer argumento y no se lanza; con promesas se rechaza.

## Recursos

- [MDN — Promesas](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide/Using_promises)
- [MDN — async/await](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Statements/async_function)
- [MDN — fetch](https://developer.mozilla.org/es/docs/Web/API/Fetch_API)
- [MDN — AbortController](https://developer.mozilla.org/es/docs/Web/API/AbortController)
- [MDN — Event loop](https://developer.mozilla.org/es/docs/Web/JavaScript/EventLoop)
- [MDN — Microtasks (queueMicrotask)](https://developer.mozilla.org/es/docs/Web/API/HTML_DOM_API/Microtask_guide)
- [Node.js — fs/promises](https://nodejs.org/api/fs.html#promises-api)
- [Node.js — util.promisify](https://nodejs.org/api/util.html#utilpromisifyoriginal)
- [JavaScript.info — Asincronía](https://es.javascript.info/async)
- [JavaScript.info — Microtasks y el event loop](https://es.javascript.info/microtask-queue)
- [Eloquent JavaScript — Asincronía y promesas](https://eloquentjavascript.net/11_async.html)