# 05 — Errores en JavaScript

## Objetivos

- [ ] Lanzar errores manualmente con `throw`.
- [ ] Capturar errores con `try`, `catch` y `finally`.
- [ ] Distinguir los tipos de error nativos (`TypeError`, `ReferenceError`, `SyntaxError`, etc.).
- [ ] Crear errores personalizados extendiendo `Error`.
- [ ] Comprender la propagación de errores y el *stack trace*.
- [ ] Manejar errores en código asíncrono (promesas, `async/await`, callbacks).
- [ ] Trabajar con errores de Node.js (`err.code`, `ENOENT`, `exitCode`).
- [ ] Identificar los errores más comunes de JS y depurarlos.

## Apuntes

### Lanzar errores con throw

`throw` detiene la ejecución y entrega un valor (normalmente un objeto `Error`). Todo lo que esté después de `throw` dentro del mismo bloque no se ejecuta, y el control salta al `catch` más cercano o, si no hay ninguno, el error sube por la pila de llamadas.

**Qué se puede lanzar.** Técnicamente cualquier valor, aunque cada opción tiene sus matices:

- `new Error(...)` o una subclase — conserva `message` y `stack`. Es la opción recomendada.
- Un objeto plano — puedes adjuntar metadatos, pero pierdes el *stack trace* automático.
- Un string — funciona, pero es mala práctica: no hay `name` ni `stack`, y es difícil de depurar.

```javascript
throw new Error("Algo salió mal");              // recomendado
throw new TypeError("Tipo incorrecto");         // subclase nativa
throw { codigo: 400, detalle: "bad request" };  // objeto plano (sin stack)
throw "Mensaje suelto";                         // string (mala práctica)
```

**Cuándo lanzar.** Lanza un error cuando una función no puede cumplir su contrato: sus entradas o estado interno hacen imposible devolver un resultado válido. Usa `throw` para errores de programación o de datos, y reserva `null`/`undefined` (o "objetos resultado") para fallos que no son excepcionales.

```javascript
function raizCuadrada(n) {
  if (typeof n !== "number") {
    throw new TypeError("Se esperaba un número");
  }
  if (n < 0) {
    throw new RangeError("No existe raíz cuadrada de un negativo");
  }
  return Math.sqrt(n);
}
```

**Errores síncronos vs. asíncronos.** `throw` solo funciona dentro de la misma ejecución síncrona. No puedes capturar con `try/catch` un error que ocurre dentro de un callback, un `setTimeout` o una promesa si no forma parte del mismo *stack* (las promesas tienen su propia maquinaria de rechazo). En asíncrono se usa `reject`, `throw` dentro de `async` (que se convierte en rechazo) y los *error-first callbacks*.

```javascript
try {
  setTimeout(() => {
    throw new Error("Fuera del try"); // NO lo captura el catch de abajo
  }, 0);
} catch (e) {
  console.log("Nunca se ejecuta");
}
// => Uncaught Error: Fuera del try
```

### try / catch / finally

- `try` — bloque que puede fallar.
- `catch` — se ejecuta solo si algo lanzó un error. Recibe el error como parámetro.
- `finally` — se ejecuta **siempre**, haya o no error (ideal para limpiar recursos).

**Sintaxis y orden de ejecución.** El orden es siempre `try` → `catch` (solo si hubo error) → `finally`. El `finally` corre incluso si el `catch` vuelve a lanzar o si hay un `return` en el `try`.

```javascript
function flujo(ok) {
  try {
    if (!ok) throw new Error("falló");
    return "ok";
  } catch (e) {
    return "error";
  } finally {
    console.log("finally se ejecuta igualmente");
  }
}
console.log(flujo(true));  // ok (después del log del finally)
console.log(flujo(false)); // error (después del log del finally)
```

**`catch` sin parámetro (optional catch binding).** Cuando no necesitas el objeto error, puedes omitirlo. Es útil cuando solo importa saber que algo falló.

```javascript
let huboError = false;
try {
  JSON.parse("{inválido");
} catch {
  huboError = true; // no nos interesa el error en sí
}
console.log(huboError); // true
```

**`finally` para limpieza.** Úsalo para cerrar conexiones, liberar temporizadores o restaurar estado. No lo uses para lógica de negocio: `finally` no distingue entre éxito y error, y un `return` dentro de `finally` **tapa** cualquier error en curso (por eso los linters lo desaconsejan). El `finally` es el lugar natural para `clearTimeout`, `close()` o `delete` de recursos temporales.

**Errores que se propagan.** Si el `try` lanza un error y no hay `catch` (o el `catch` vuelve a lanzar), el error sube por la pila hasta que alguien lo captura o el proceso termina. Un `try` con solo `finally` no captura nada: solo demora la propagación hasta terminar de limpiar.

```javascript
function a() { throw new Error("desde a"); }
function b() {
  try { a(); } finally { console.log("limpiando..."); }
}
try {
  b();
} catch (e) {
  console.log("Capturado:", e.message); // Capturado: desde a
}
```

### Tipos de error nativos

| Error | Cuándo ocurre |
|---|---|
| `TypeError` | Operar con un tipo inapropiado (ej. `null.propiedad`). |
| `ReferenceError` | Usar una variable no declarada. |
| `SyntaxError` | El código no es válido sintácticamente. |
| `RangeError` | Un valor fuera del rango permitido (ej. `new Array(-1)`). |
| `URIError` | Una función de URI (`decodeURIComponent`, `encodeURI`) recibe un argumento malformado. |
| `EvalError` | Reservado históricamente para `eval()`; hoy prácticamente no se lanza. |
| `AggregateError` | Agrupa varios errores en uno solo (ej. `Promise.any`). |
| `Error` | Error genérico; base de todos los demás. |

Todos los errores nativos son subclases de `Error` y comparten `name`, `message` y `stack`. Puedes distinguirlos con `instanceof` o con `name`.

```javascript
try {
  null.metodo(); // TypeError
} catch (e) {
  console.log(e.name); // "TypeError"
}

try {
  console.log(variableInexistente); // ReferenceError
} catch (e) {
  console.log(e.name); // "ReferenceError"
}

try {
  new Array(-1); // RangeError
} catch (e) {
  console.log(e.name); // "RangeError"
}

try {
  decodeURIComponent("%"); // URIError
} catch (e) {
  console.log(e.name); // "URIError"
}

// EvalError existe como clase, pero hoy no se lanza de forma natural
const ev = new EvalError("error de eval");
console.log(ev instanceof Error); // true
```

```javascript
// AggregateError: Promise.any rechaza reuniendo todos los fallos
Promise.any([
  Promise.reject(new Error("servidor 1 caído")),
  Promise.reject(new Error("servidor 2 caído")),
]).catch((e) => {
  console.log(e.name);          // "AggregateError"
  console.log(e.errors.length); // 2
});
```

**Distingue con `instanceof`, no con `name`.** `instanceof` es más robusto cuando tienes una jerarquía (por ejemplo, un `TypeError` también es un `Error`), mientras que `name` es una cadena y puede coincidir entre errores de distinto origen.

```javascript
try {
  JSON.parse("{muy mal");
} catch (e) {
  console.log(e instanceof SyntaxError); // true
  console.log(e instanceof Error);       // true
}
```

### Errores personalizados

Extiende `Error` para crear errores con significado semántico. Las reglas básicas de la subclase:

1. Llama siempre a `super(mensaje)` para inicializar `message` (y `stack`).
2. Sobrescribe `this.name` con el nombre de tu clase; si no, heredará `"Error"`.
3. Añade propiedades extra con el contexto que necesite quien capture el error.

```javascript
class ValidacionError extends Error {
  constructor(mensaje, campo) {
    super(mensaje);
    this.name = "ValidacionError";
    this.campo = campo;
  }
}

function validarEdad(edad) {
  if (edad < 18) {
    throw new ValidacionError("Debes ser mayor de edad", "edad");
  }
  return "OK";
}

try {
  validarEdad(15);
} catch (e) {
  console.log(e.name, e.campo, e.message);
  // "ValidacionError edad Debes ser mayor de edad"
}
```

**`instanceof` para distinguirlos.** Al crear jerarquías, puedes tratar cada error según su tipo. La comprobación con `instanceof` respeta la cadena de herencia.

```javascript
class HttpError extends Error {
  constructor(status, mensaje) {
    super(mensaje);
    this.name = "HttpError";
    this.status = status;
  }
}

class NotFoundError extends HttpError {
  constructor(recurso) {
    super(404, `No se encontró ${recurso}`);
    this.name = "NotFoundError";
    this.recurso = recurso;
  }
}

try {
  throw new NotFoundError("/api/usuarios");
} catch (e) {
  console.log(e instanceof NotFoundError); // true
  console.log(e instanceof HttpError);     // true
  console.log(e instanceof Error);         // true
  console.log(e.status, e.recurso);        // 404 /api/usuarios
}
```

**Encadenar la causa con `cause` (ES2022).** `super(mensaje, { cause })` guarda el error original en `.cause`, útil cuando una capa envuelve el error de otra sin perder la raíz.

```javascript
class ServicioError extends Error {
  constructor(mensaje, causa) {
    super(mensaje, { cause: causa });
    this.name = "ServicioError";
  }
}

try {
  JSON.parse("{inválido");
} catch (causa) {
  throw new ServicioError("No se pudo procesar la respuesta", causa);
}
// Al capturar ServicioError: e.cause es el SyntaxError original
```

### Propagación y call stack

Cuando se lanza un error, el motor sube por la pila de llamadas (*unwinding*) buscando un `catch`. Si no encuentra ninguno, el error se reporta como *uncaught* y el programa termina (o la promesa queda rechazada).

**El stack trace.** Cada objeto `Error` guarda en `stack` la secuencia de llamadas en el momento del lanzamiento. La primera línea es `NombreError: mensaje`; el resto son los marcos de pila, que se leen de arriba hacia abajo.

```javascript
function c() { throw new Error("boom"); }
function b() { c(); }
function a() { b(); }

try {
  a();
} catch (e) {
  console.log(e.stack);
  // Error: boom
  //     at c (archivo.js:2)
  //     at b (archivo.js:3)
  //     at a (archivo.js:4)
}
```

**Re-lanzar errores.** Si capturas un error que no puedes manejar, vuelve a lanzarlo con `throw` para no tragarlo. Es la diferencia entre *manejar* y *delegar*.

```javascript
try {
  procesar();
} catch (e) {
  if (e instanceof ValidacionError) {
    return formatear(e); // este sí lo manejo
  }
  throw e; // el resto lo delego hacia arriba
}
```

Consejos para leer stacks: el marco más reciente está arriba y la llamada raíz abajo; `at` puede aparecer con `async` (funciones asíncronas) o `node:` (módulos internos de Node); en producción usa *source maps* para ver el código original, no el minificado.

### Errores en código asíncrono

El `try/catch` clásico solo cubre la ejecución síncrona. Para asincronía existen tres modelos de manejo de errores.

**1. Promesas: `reject` y `.catch`.** Un error lanzado dentro de un ejecutor rechaza la promesa. Encadena `.catch` al final y usa `.finally` para limpieza.

```javascript
function leerConfig(ruta) {
  return new Promise((resolve, reject) => {
    if (ruta === "mal") reject(new Error("ruta inválida"));
    else resolve({ formato: "json" });
  });
}

leerConfig("mal")
  .then((c) => console.log(c))
  .catch((e) => console.error("Fallo:", e.message)) // Fallo: ruta inválida
  .finally(() => console.log("terminó"));
```

**2. `async/await` con `try/catch`.** Dentro de una función `async`, `throw` se convierte en rechazo y `await` propaga el rechazo de la promesa. Así el `try/catch` vuelve a funcionar como en código síncrono.

```javascript
async function descargar(id) {
  const respuesta = await fetch(`https://api.ejemplo.com/items/${id}`);
  if (!respuesta.ok) {
    throw new Error(`HTTP ${respuesta.status}`);
  }
  return respuesta.json();
}

async function main() {
  try {
    const datos = await descargar("abc");
    console.log(datos);
  } catch (e) {
    console.error("No se pudo descargar:", e.message);
  }
}
main();
```

**3. Callbacks y error-first.** En Node, los callbacks siguen la convención `(err, resultado)`: ante un fallo, `err` es un objeto (y `null`/`undefined` si todo fue bien). Revisa `err` antes de usar `resultado`.

```javascript
const fs = require("node:fs");
fs.readFile("config.json", "utf8", (err, data) => {
  if (err) {
    console.error("No se pudo leer:", err.message);
    return;
  }
  console.log(data);
});
```

**`unhandledRejection`.** Una promesa rechazada sin `.catch` ni `await` dispara el evento `unhandledRejection`. En Node moderno esto **termina el proceso** (desde Node 15). Captúralo solo como red de seguridad, nunca como sustituto de un manejo correcto.

```javascript
process.on("unhandledRejection", (razon) => {
  console.error("Promesa rechazada sin manejar:", razon);
  process.exit(1);
});
```

### Errores en Node.js

**`err.code` y errores de sistema (`fs`).** Los errores de E/S llevan un `code` canónico que permite distinguir la causa sin depender de mensajes localizados.

```javascript
const fs = require("node:fs");
try {
  fs.readFileSync("/ruta/que/no/existe.txt", "utf8");
} catch (e) {
  console.log(e.code); // "ENOENT"
  if (e.code === "ENOENT") {
    console.log("El archivo no existe");
  } else if (e.code === "EACCES") {
    console.log("Permisos insuficientes");
  } else {
    throw e;
  }
}
```

Códigos frecuentes: `ENOENT` (no existe), `EACCES` (sin permiso), `EISDIR` (es un directorio), `EEXIST` (ya existe), `ECONNREFUSED` (conexión rechazada).

**`process.exitCode`.** Asignar `exitCode` en lugar de llamar a `process.exit()` permite que las salidas asíncronas pendientes terminen y que los flujos se vacíen antes de salir.

```javascript
const fs = require("node:fs");
const archivo = process.argv[2];

try {
  const contenido = fs.readFileSync(archivo, "utf8");
  console.log(contenido.toUpperCase());
} catch (e) {
  console.error(`Error al leer ${archivo}: ${e.message}`);
  process.exitCode = 1;
}
```

**Lanzar errores en callbacks.** En un *error-first callback*, si no puedes manejar el fallo, propágalo como rechazo o como evento; lanzarlo con `throw` dentro del callback rompería el flujo de la API asíncrona. Para encajar con `async/await`, usa las APIs basadas en promesas (`node:fs/promises`, `node:util.promisify`).

```javascript
const fs = require("node:fs/promises");

async function leerConParseo(ruta) {
  try {
    const texto = await fs.readFile(ruta, "utf8");
    return JSON.parse(texto);
  } catch (e) {
    throw new Error(`No se pudo cargar ${ruta}`, { cause: e });
  }
}
```

**Dominios (obsoletos).** El módulo `domain`, diseñado para capturar errores en callbacks, está en desuso y no debe usarse en código nuevo. Sustitúyelo por promesas/`async/await`, por `uncaughtException` (con cautela) o por herramientas externas de supervisión del proceso.

### Errores comunes de JS y cómo depurarlos

1. **`ReferenceError: x is not defined`** — Variable no declarada. Revisa la ortografía y el ámbito.
2. **`TypeError: Cannot read property of undefined`** — Accedes a una propiedad de un valor `undefined`. Comprueba que el dato llegó.
3. **`TypeError: Assignment to constant variable`** — Reasignaste un `const`.
4. **`Cannot read properties of null`** — `document.getElementById(...)` devolvió `null` (el selector no existe).
5. **`SyntaxError: Unexpected token`** — Falta una llave, paréntesis o coma.
6. **`NaN` como resultado** — Operación inválida como `"abc" * 2` o `undefined + 1`.

Técnicas de depuración:

- `console.log()` / `console.table()` / `console.dir()` para inspeccionar.
- `console.error()` para mensajes de error y `console.warn()` para advertencias. `console.trace()` imprime además el *stack trace* en el punto actual.
- `debugger;` pausa la ejecución en herramientas de desarrollo.
- Node: `node --inspect archivo.js` abre el inspector (por defecto en el puerto 9229); `node --inspect-brk archivo.js` pausa en la primera línea. Conecta Chrome DevTools desde `chrome://inspect` para poner breakpoints, inspeccionar variables y seguir el *stack*.
- **Breakpoints:** en el panel Sources (o Node) de DevTools, haz clic en el número de línea para pausar; los breakpoints condicionales solo pausan cuando se cumple una condición (ej. `edad > 18`).
- `node --watch archivo.js` reinicia el proceso automáticamente al guardar cambios, ideal para el ciclo de depuración (Node 18.11+).
- `util.inspect(obj, { depth: null })` imprime objetos profundamente anidados en la terminal.

```javascript
function dividir(a, b) {
  debugger; // pausa aquí al depurar con el inspector
  return a / b;
}
console.trace("rastreando la llamada");
```

```bash
node --inspect-brk depuracion.js
# Debugger listening on ws://127.0.0.1:9229/...
# Abre chrome://inspect y conecta la sesión.
```

### Buenas prácticas

- **Nunca captures y tragues errores.** Un `catch {}` vacío oculta bugs y hace imposible depurar. Si no puedes manejarlo, vuelve a lanzarlo o al menos regístralo.
- **Lanza errores específicos.** Usa `TypeError` para tipos, `RangeError` para rangos y subclases propias para tu dominio. Así quien captura puede distinguir con `instanceof`.
- **Mensajes claros y accionables.** Di qué pasó y en qué contexto: "Se esperaba un número, se recibió: string" es mejor que "error".
- **Adjunta contexto con `cause`.** Encadena el error original para no perder la raíz al propagar por capas.
- **No lances strings ni objetos planos** salvo casos puntuales: pierdes `name`, `stack` y la interoperabilidad con las herramientas.
- **Cubre solo lo que esperas.** Captura la operación concreta y deja que el resto suba; un `try/catch` gigante que envuelve todo el programa dificulta saber dónde falló.
- **Usa `finally` para limpiar**, nunca para lógica de negocio.
- **En asíncrono, toda promesa termina manejada.** Cada cadena `.then` debe acabar en `.catch` (o quedar bajo un `await` dentro de `try/catch`).
- **Prueba tus errores.** Con `assert.throws` (y `assert.rejects` para promesas) verificas que se lanza el error correcto, con el tipo y el mensaje esperados.

```javascript
const assert = require("node:assert/strict");

function sumar(a, b) {
  if (typeof a !== "number" || typeof b !== "number") {
    throw new TypeError("sumar espera dos números");
  }
  return a + b;
}

assert.throws(() => sumar(2, "x"), TypeError);
assert.throws(() => sumar(2, "x"), /espera dos números/);
assert.throws(() => sumar(2, "x"), (e) => e.message.includes("números"));

async function cargar(ruta) {
  if (!ruta) throw new RangeError("Falta la ruta");
  return "datos";
}

assert.rejects(() => cargar(""), RangeError);
assert.rejects(() => cargar(""), /Falta la ruta/);

console.log("assert.throws y assert.rejects OK");
```

## Ejemplos de código

Ejemplo 1 — Clasificar errores nativos por tipo. Copia esto a `errores.js` y ejecuta `node errores.js`.

```javascript
function lanzar(tipo) {
  switch (tipo) {
    case "type":  return null.x;
    case "range": return new Array(-1);
    case "ref":   return variableInexistente;
    case "uri":   return decodeURIComponent("%");
    default:      throw new Error("tipo desconocido");
  }
}

for (const tipo of ["type", "range", "ref", "uri"]) {
  try {
    lanzar(tipo);
  } catch (e) {
    console.log(`${tipo.padEnd(5)} -> ${e.name}`);
  }
}
// type  -> TypeError
// range -> RangeError
// ref   -> ReferenceError
// uri   -> URIError
```

Ejemplo 2 — Errores personalizados con `cause` y re-lanzado a través de capas.

```javascript
class ApiError extends Error {
  constructor(mensaje, causa) {
    super(mensaje, { cause: causa });
    this.name = "ApiError";
  }
}

function capaDatos() {
  throw new Error("conexión perdida");
}

function capaServicio() {
  try {
    capaDatos();
  } catch (causa) {
    throw new ApiError("no se pudo procesar el pedido", causa);
  }
}

try {
  capaServicio();
} catch (e) {
  console.log(`${e.name}: ${e.message}`);      // ApiError: no se pudo procesar el pedido
  console.log(`causa: ${e.cause.message}`);     // causa: conexión perdida
}
```

Ejemplo 3 — Manejo de errores asíncronos con `async/await` y `fetch` simulado.

```javascript
async function pedirDatos(url) {
  if (!url) throw new TypeError("Se necesita una URL");
  const res = await fetch(url);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.json();
}

(async () => {
  try {
    await pedirDatos(null);
  } catch (e) {
    console.error(`${e.name}: ${e.message}`); // TypeError: Se necesita una URL
  }
})();
```

Ejemplo 4 — Errores de sistema en Node.js: diferenciar `ENOENT` de otros fallos.

```javascript
const fs = require("node:fs");

function leerOpcional(ruta) {
  try {
    return fs.readFileSync(ruta, "utf8");
  } catch (e) {
    if (e.code === "ENOENT") {
      console.warn("El archivo no existe, se devuelve vacío.");
      return "";
    }
    throw e;
  }
}

console.log(JSON.stringify(leerOpcional("no-existe.txt")));
// El archivo no existe, se devuelve vacío.
// ""
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — Experto](../ejercicios/nivel-05-experto/)
  - [Ejercicio 01 — Gestor de tareas CLI](../ejercicios/nivel-05-experto/ejercicio-01-gestor-de-tareas-cli/)
  - [Ejercicio 02 — Servidor HTTP](../ejercicios/nivel-05-experto/ejercicio-02-servidor-http/)
  - [Ejercicio 03 — Cache LRU](../ejercicios/nivel-05-experto/ejercicio-03-cache-lru/)
  - [Ejercicio 04 — Event Emitter](../ejercicios/nivel-05-experto/ejercicio-04-event-emitter/)

## Errores comunes

- **Tragar errores silenciosamente** → un `catch` vacío oculta bugs. Al menos registra con `console.error`.
- **`catch` sin parámetro en la rama que necesita el error** → la variable no existe ahí; usa `catch (e)` cuando la necesites.
- **Olvidar `finally` para limpiar** → conexiones o archivos abiertos pueden quedar colgados.
- **`JSON.parse` sin try/catch** → un JSON inválido rompe el programa.
- **Ignorar el campo `message` y `stack`** → son la mejor pista para depurar.
- **Olvidar el `.catch` en una cadena de promesas** → en Node 15+ termina el proceso con `unhandledRejection`.
- **No revisar `err` en un *error-first callback*** → acceder a `resultado` cuando hay error puede explotar con un `TypeError` confuso.
- **Comparar `e.code` sin comprobar el tipo** → el error puede ser de otro tipo (ej. un `TypeError` de tu código); verifica con `instanceof` antes.
- **Dejar `debugger;` en producción** → no hace nada sin un inspector conectado, pero deja el código lleno de residuos.

## Recursos

- [MDN — Control de flujo y manejo de errores](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide/Control_flow_and_error_handling)
- [MDN — Error](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Error)
- [MDN — Error.prototype.cause](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Error/cause)
- [MDN — AggregateError](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/AggregateError)
- [MDN — Promise.any](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Promise/any)
- [MDN — console](https://developer.mozilla.org/es/docs/Web/API/console)
- [Node.js — Errores](https://nodejs.org/api/errors.html)
- [Node.js — Errores comunes de sistema (códigos)](https://nodejs.org/api/errors.html#common-system-errors)
- [Node.js — Debugging](https://nodejs.org/en/learn/getting-started/debugging)
- [Node.js — node --watch](https://nodejs.org/en/learn/getting-started/nodejs-with-typescript)
- [Node.js — Test runner: assert.throws / assert.rejects](https://nodejs.org/api/assert.html)
- [JavaScript.info — Manejo de errores](https://es.javascript.info/error-handling)
- [JavaScript.info — Promesas, async/await](https://es.javascript.info/async)