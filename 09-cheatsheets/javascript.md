# Chuleta de JavaScript

Referencia rápida de JavaScript moderno (ES2020+). Cubre tipos, operadores, control de flujo, funciones, arrays, objetos, strings, destructuring, spread/rest, promises, async/await, fetch, módulos, clases, `this`, prototypes, Symbol, Map/Set, Reflect, Proxy y manejo de errores.

## Índice

- [Tipos](#tipos)
- [Operadores](#operadores)
- [Control de flujo](#control-de-flujo)
- [Funciones](#funciones)
- [Arrays (métodos)](#arrays-métodos)
- [Objetos](#objetos)
- [Strings](#strings)
- [Destructuring](#destructuring)
- [Spread / Rest](#spread--rest)
- [Promises](#promises)
- [async / await](#async--await)
- [fetch](#fetch)
- [Módulos](#módulos)
- [Clases](#clases)
- [this](#this)
- [Prototypes](#prototypes)
- [Symbol](#symbol)
- [Map / Set](#map--set)
- [Reflect](#reflect)
- [Proxy](#proxy)
- [Error handling](#error-handling)

---

## Tipos

JavaScript tiene 7 tipos primitivos y 1 tipo objeto.

| Tipo | Ejemplo | typeof |
|---|---|---|
| `Number` | `42`, `3.14`, `NaN`, `Infinity` | `"number"` |
| `String` | `"hola"`, `'a'`, `` `tpl` `` | `"string"` |
| `Boolean` | `true`, `false` | `"boolean"` |
| `Null` | `null` (ausencia intencional) | `"object"` ⚠️ |
| `Undefined` | `undefined` (no asignado) | `"undefined"` |
| `Symbol` | `Symbol("id")` | `"symbol"` |
| `BigInt` | `9007199254740993n` | `"bigint"` |
| `Object` | `{}`, `[]`, `function(){}` | `"object"` / `"function"` |

```javascript
// Comprobar tipos
typeof 42;            // "number"
typeof "hola";        // "string"
typeof true;          // "boolean"
typeof undefined;     // "undefined"
typeof null;          // "object" (bug histórico)
typeof Symbol();      // "symbol"
typeof 10n;           // "bigint"
typeof {};            // "object"
typeof function(){};  // "function"
typeof [];            // "object" (¡ojo!)

// Para arrays usa Array.isArray
Array.isArray([1, 2]);   // true
Array.isArray("a");      // false

// Para null
valor === null;
```

### Conversión de tipos (coerción)

```javascript
// A string
String(42);            // "42"
(42).toString();       // "42"
42 + "";               // "42"

// A number
Number("42");          // 42
parseInt("42px", 10);  // 42
parseFloat("3.14");    // 3.14
+"42";                 // 42
Math.floor("3.99");    // 3

// A boolean
Boolean(0);            // false
Boolean("");           // false
Boolean(null);         // false
Boolean(undefined);    // false
Boolean(NaN);          // false
Boolean("0");          // true (string no vacío)
Boolean([]);           // true (array siempre truthy)
Boolean({});           // true (objeto siempre truthy)

// == vs ===
0 == false;    // true (con coerción)
0 === false;   // false (sin coerción)
null == undefined;  // true
null === undefined; // false
"1" == 1;      // true
"1" === 1;     // false
```

Valores falsy: `false`, `0`, `-0`, `0n`, `""`, `null`, `undefined`, `NaN`. Todo lo demás es truthy.

---

## Operadores

### Aritméticos

| Operador | Descripción |
|---|---|
| `+` `-` `*` `/` | Básicos |
| `%` | Módulo (resto) |
| `**` | Potencia (`2 ** 10`) |
| `++` `--` | Incremento / decremento |
| `+=` `-=` `*=` `/=` | Asignación compuesta |

### Comparación

| Operador | Descripción |
|---|---|
| `==` `!=` | Igualdad con coerción (evitar) |
| `===` `!==` | Igualdad estricta (recomendado) |
| `<` `>` `<=` `>=` | Comparación |
| `??` | Nullish coalescing (solo null/undefined) |
| `\|\|` | OR lógico (cualquier falsy) |
| `&&` | AND lógico |

### Lógicos y de corto-circuito

```javascript
// ?? : valor por defecto solo si null/undefined
const nombre = input ?? "anónimo";

// || : valor por defecto si falsy (incluye 0, "")
const cantidad = input || 1;

// && : si truthy, evalúa el segundo
usuario && usuario.esAdmin && redirigir();

// Asignación con cortocircuito
a ??= 10;   // a = a ?? 10
a ||= 10;   // a = a || 10
a &&= 10;   // a = a && 10
```

### Otros

| Operador | Descripción |
|---|---|
| `typeof` | Tipo |
| `instanceof` | Instancia de una clase |
| `in` | Propiedad en objeto |
| `delete obj.prop` | Borra propiedad |
| `void expr` | Evalúa y devuelve undefined |
| `cond ? a : b` | Ternario |
| `obj?.prop` | Optional chaining |
| `arr?.[0]` | Optional en index |
| `fn?.()` | Optional call |

```javascript
// Optional chaining: evita "Cannot read of undefined"
const ciudad = usuario?.direccion?.ciudad;   // undefined si falta
const primero = arr?.[0];
const result = obj.metodo?.();

// Nullish coalescing
const config = { port: 0 };
const puerto = config.port ?? 3000;   // 0 (no es null/undefined)
const puerto2 = config.port || 3000; // 3000 (0 es falsy)
```

---

## Control de flujo

```javascript
// if / else if / else
if (edad >= 18) {
  console.log("adulto");
} else if (edad >= 13) {
  console.log("adolescente");
} else {
  console.log("niño");
}

// ternario
const acceso = edad >= 18 ? "sí" : "no";

// switch
switch (dia) {
  case "lun":
  case "mar":
    console.log("laborable");
    break;
  case "sab":
  case "dom":
    console.log("finde");
    break;
  default:
    console.log("?");
}

// for clásico
for (let i = 0; i < arr.length; i++) { ... }

// for...of (iterables: arrays, strings)
for (const item of arr) { ... }

// for...in (claves enumerables)
for (const key in obj) { ... }

// while / do-while
while (cond) { ... }
do { ... } while (cond);

// break y continue
for (const n of nums) {
  if (n < 0) continue;     // salta
  if (n > 100) break;      // sale del bucle
}
```

---

## Funciones

### Tipos de declaración

```javascript
// Declaración (hoisted)
function suma(a, b) { return a + b; }

// Expresión (no hoisted)
const suma = function (a, b) { return a + b; };

// Arrow function
const suma = (a, b) => a + b;
const cuadrado = x => x * x;
const saludar = () => "hola";
const log = x => { console.log(x); };

// IIFE (inmediatamente invocada)
(function () {
  console.log("ejecutado al definir");
})();

// Función como argumento (callback)
[1, 2, 3].forEach(n => console.log(n));

// Valor por defecto
function saludar(nombre = "mundo") { return `Hola ${nombre}`; }

// Rest parameters
function sumar(...nums) { return nums.reduce((a, b) => a + b, 0); }

// Devolver objeto (ojo con las llaves)
const crear = () => ({ nombre: "Ana" });
```

### Diferencias de arrow functions

- No tienen su propio `this` (lo heredan del ámbito externo)
- No tienen `arguments`
- No pueden usarse como constructor (`new`)
- No tienen `super` / `new.target`

```javascript
function Persona(nombre) {
  this.nombre = nombre;
  // arrow: this es el de Persona (correcto)
  this.saludar = () => console.log(`Hola, soy ${this.nombre}`);
  // function normal: this sería el botón (incorrecto aquí)
  this.saludarFn = function () { console.log(this.nombre); };
}
```

### Clausuras (closures)

```javascript
function contador() {
  let n = 0;
  return () => ++n;   // captura el ámbito de contador
}
const c = contador();
c(); // 1
c(); // 2
c(); // 3

// Aplicación parcial / currying
const sumar = a => b => a + b;
const sumar10 = sumar(10);
sumar10(5); // 15
```

### Funciones de orden superior

```javascript
// Reciben o devuelven funciones
const multiplicar = factor => x => x * factor;
const doble = multiplicar(2);
doble(5); // 10

// Memoización con closure
function memo(fn) {
  const cache = new Map();
  return (n) => {
    if (cache.has(n)) return cache.get(n);
    const r = fn(n);
    cache.set(n, r);
    return r;
  };
}
const fibMemo = memo(function fib(n) {
  return n < 2 ? n : fibMemo(n - 1) + fibMemo(n - 2);
});
```

---

## Arrays (métodos)

### Mutables (modifican el original)

| Método | Descripción |
|---|---|
| `push(v)` | Añade al final |
| `pop()` | Quita y devuelve el último |
| `unshift(v)` | Añade al inicio |
| `shift()` | Quita y devuelve el primero |
| `splice(i, n, ...items)` | Inserta/borra en i |
| `sort()` | Ordena (in place) |
| `reverse()` | Invierte |
| `fill(v)` | Rellena con v |

### Inmutables (devuelven nuevo array)

| Método | Descripción |
|---|---|
| `map(fn)` | Transforma cada elemento |
| `filter(fn)` | Filtra por condición |
| `reduce(fn, init)` | Acumula en un valor |
| `reduceRight(fn, init)` | Acumula de derecha a izquierda |
| `flat(n)` | Aplana n niveles |
| `flatMap(fn)` | map + flat(1) |
| `slice(i, f)` | Copia un trozo |
| `concat(arr)` | Concatena |
| `slice()` | Copia superficial (shallow) |
| `[...arr]` | Spread (copia superficial) |
| `toSorted()` | Ordena sin mutar (ES2023) |
| `toReversed()` | Invierte sin mutar (ES2023) |

### Búsqueda

| Método | Descripción |
|---|---|
| `find(fn)` | Primer elemento que cumple |
| `findIndex(fn)` | Índice del primero que cumple |
| `findLast(fn)` | Último que cumple (ES2023) |
| `indexOf(v)` | Índice de un valor |
| `lastIndexOf(v)` | Último índice |
| `includes(v)` | Si contiene el valor |
| `some(fn)` | Si alguno cumple |
| `every(fn)` | Si todos cumplen |
| `at(i)` | Elemento en i (admite negativos) |

### Iteración

| Método | Descripción |
|---|---|
| `forEach(fn)` | Recorre sin devolver |
| `keys()` | Índices |
| `values()` | Valores |
| `entries()` | Pares [índice, valor] |

```javascript
const nums = [1, 2, 3, 4, 5];

// map + filter + reduce
const resultado = nums
  .filter(n => n % 2 === 0)        // [2, 4]
  .map(n => n * 10)                // [20, 40]
  .reduce((acc, n) => acc + n, 0); // 60

// find
const user = usuarios.find(u => u.id === 5);

// some / every
const hayAdmins = usuarios.some(u => u.rol === "admin");
const todosActivos = usuarios.every(u => u.activo);

// flat / flatMap
[1, [2, [3]]].flat();        // [1, 2, [3]]
[1, [2, [3]]].flat(2);       // [1, 2, 3]
[[1, 2], [3, 4]].flat();     // [1, 2, 3, 4]
[1, 2].flatMap(n => [n, n]); // [1, 1, 2, 2]

// at (acepta negativos)
["a", "b", "c"].at(-1);  // "c"

// sort numérico (¡importante la función!)
[10, 2, 30, 1].sort((a, b) => a - b);  // [1, 2, 10, 30]
[10, 2, 30].sort();                    // [10, 2, 30] (ordena como strings)

// Agrupar por clave (ES2024)
const porRol = Object.groupBy(usuarios, u => u.rol);
// { admin: [...], user: [...] }
```

### Convertir entre array y otros

```javascript
// Array-like a array
const args = Array.from(arguments);
const args2 = [...arguments];
const nodos = Array.from(document.querySelectorAll("div"));

// String a array
[..."hola"]; // ["h", "o", "l", "a"]

// Set a array (eliminar duplicados)
[...new Set([1, 1, 2, 2, 3])]; // [1, 2, 3]

// Object.entries / fromEntries
const obj = { a: 1, b: 2 };
const entries = Object.entries(obj);   // [["a",1],["b",2]]
const copia = Object.fromEntries(entries); // {a:1, b:2}

// Invertir claves y valores
const invertido = Object.fromEntries(
  Object.entries(obj).map(([k, v]) => [v, k])
);
```

---

## Objetos

```javascript
// Literal
const user = {
  nombre: "Ana",
  edad: 30,
  // método abreviado
  saludar() { return `Hola ${this.nombre}`; },
  // getter
  get info() { return `${this.nombre} (${this.edad})`; },
  // propiedad computada
  ["id_" + 1]: 100,
};

// Acceso
user.nombre;        // "Ana"
user["edad"];       // 30

// Asignación
user.email = "a@b.com";

// Spread de objetos
const copia = { ...user };
const mezcla = { ...user, rol: "admin" };

// Optional chaining
const ciudad = user?.direccion?.ciudad;

// Shorthand (si clave = variable)
const nombre = "Ana", edad = 30;
const u = { nombre, edad };   // { nombre: "Ana", edad: 30 }

// Renombrar al desestructurar
const { nombre: nombreCompleto } = user;
```

### Métodos estáticos de Object

| Método | Descripción |
|---|---|
| `Object.keys(obj)` | Claves |
| `Object.values(obj)` | Valores |
| `Object.entries(obj)` | Pares [clave, valor] |
| `Object.fromEntries(arr)` | Crea objeto desde pares |
| `Object.assign(dest, ...src)` | Copia propiedades |
| `Object.freeze(obj)` | Congela (no se puede modificar) |
| `Object.seal(obj)` | Sella (no añadir/borrar, sí modificar) |
| `Object.preventExtensions(obj)` | No añadir props |
| `Object.create(proto)` | Crea con prototipo |
| `Object.getPrototypeOf(obj)` | Prototipo |
| `Object.setPrototypeOf(obj, proto)` | Cambia prototipo |
| `Object.defineProperty(obj, k, desc)` | Define con descriptor |
| `Object.defineProperties(obj, descs)` | Varios |
| `Object.getOwnPropertyDescriptor(obj, k)` | Descriptor |
| `Object.hasOwn(obj, k)` | Tiene propiedad propia (ES2022) |
| `Object.groupBy(arr, fn)` | Agrupar (ES2024) |

```javascript
// Object.assign vs spread
const a = { x: 1 };
const b = Object.assign({}, a, { y: 2 });   // { x:1, y:2 }
const c = { ...a, y: 2 };                    // igual

// Copia profunda (structuredClone)
const original = { items: [1, 2], meta: { ok: true } };
const profundo = structuredClone(original);
profundo.items.push(3);
original.items; // [1, 2] (no se ve afectado)

// Freeze
const frozen = Object.freeze({ a: 1 });
frozen.a = 2; // no hace nada en strict mode
Object.isFrozen(frozen); // true

// hasOwn (reemplaza obj.hasOwnProperty)
Object.hasOwn(user, "nombre"); // true
user.hasOwnProperty("nombre"); // clásico (puede fallar si se sobrescribe)
```

### Getters y setters

```javascript
const cuenta = {
  _saldo: 100,
  get saldo() { return this._saldo; },
  set saldo(v) {
    if (v < 0) throw new Error("Saldo negativo");
    this._saldo = v;
  },
};
cuenta.saldo = 200;
cuenta.saldo; // 200
```

---

## Strings

```javascript
const s = "Hola, mundo";

// Longitud y acceso
s.length;        // 11
s[0];            // "H"
s.charAt(0);     // "H"
s.at(-1);        // "o"

// Buscar
s.indexOf("mundo");      // 7
s.lastIndexOf("o");     // 10
s.includes("mundo");    // true
s.startsWith("Hola");   // true
s.endsWith("mundo");    // true
s.search(/mundo/);      // 7

// Extraer
s.slice(0, 4);           // "Hola"
s.slice(-5);             // "mundo"
s.substring(0, 4);       // "Hola"
s.substr(7, 5);          // "mundo" (deprecated)

// Transformar
s.toUpperCase();         // "HOLA, MUNDO"
s.toLowerCase();
s.trim();               // quita espacios
s.trimStart(); / s.trimEnd();
s.padStart(10, "*");     // "**Hola, mundo"
s.padEnd(15, ".");
s.repeat(3);             // repite
s.replace("mundo", "JS"); // reemplaza 1
s.replaceAll("a", "A");   // reemplaza todos
s.split(", ");           // ["Hola", "mundo"]

// Concatenar
"hola".concat(" ", "mundo");
["a", "b"].join("-");    // "a-b"

// Template literals
const nombre = "Ana";
`Hola, ${nombre}. Son las ${new Date().getHours()}h`;
`Línea 1
Línea 2`;   // multilínea

// Etiquetadas
function resaltar(cadenas, ...valores) {
  return cadenas.reduce((acc, c, i) => acc + c + (valores[i] ?? ""), "");
}
resaltar`Hola ${nombre}, tienes ${5} mensajes`;
```

---

## Destructuring

### Arrays

```javascript
const [a, b] = [1, 2];          // a=1, b=2
const [x, , z] = [1, 2, 3];     // x=1, z=3 (saltar)
const [primero, ...resto] = [1, 2, 3];  // primero=1, resto=[2,3]
const [a = 10, b = 20] = [1];   // a=1, b=20 (valores por defecto)

// Intercambio de variables
let a = 1, b = 2;
[a, b] = [b, a];   // a=2, b=1

// Anidado
const [[a, b], [c]] = [[1, 2], [3]];   // a=1, b=2, c=3
```

### Objetos

```javascript
const user = { nombre: "Ana", edad: 30, rol: "admin" };

const { nombre, edad } = user;            // nombre="Ana", edad=30
const { rol: tipo } = user;               // tipo="admin" (renombrar)
const { ciudad = "Madrid" } = user;       // ciudad="Madrid" (por defecto)
const { direccion: { calle } = {} } = user;   // anidado con defecto

// En parámetros de función
function saludar({ nombre = "invitado", edad = 0 } = {}) {
  return `Hola ${nombre}, ${edad} años`;
}
saludar({ nombre: "Ana", edad: 30 });
saludar();   // "Hola invitado, 0 años"
```

---

## Spread / Rest

- **Spread** `...` "expande" un iterable o objeto.
- **Rest** `...` "recoge" varios elementos en uno.

```javascript
// Spread en arrays
const a = [1, 2];
const b = [3, 4];
const c = [...a, ...b];   // [1, 2, 3, 4]
const copia = [...a];

// Spread en funciones
Math.max(...[3, 7, 2]);   // 7
Math.max(...a, 10, ...b);

// Spread en objetos
const base = { a: 1, b: 2 };
const extendido = { ...base, c: 3 };   // { a:1, b:2, c:3 }
const override = { ...base, b: 99 };   // { a:1, b:99 }

// Rest en parámetros (recoger)
function sumar(...nums) { return nums.reduce((a, b) => a + b, 0); }
sumar(1, 2, 3, 4);   // 10

// Rest en destructuring
const { a, ...resto } = { a: 1, b: 2, c: 3 };   // resto = { b:2, c:3 }
const [primero, ...otros] = [1, 2, 3, 4];        // otros = [2,3,4]
```

---

## Promises

Una Promise representa un valor que estará disponible en el futuro.

```javascript
const p = new Promise((resolve, reject) => {
  setTimeout(() => {
    if (exito) resolve("OK");
    else reject(new Error("fallo"));
  }, 1000);
});

p.then(valor => console.log(valor))
 .catch(err => console.error(err))
 .finally(() => console.log("fin"));
```

Estados: `pending` → `fulfilled` o `rejected`.

### Métodos estáticos

| Método | Descripción |
|---|---|
| `Promise.resolve(v)` | Crea resuelta |
| `Promise.reject(e)` | Crea rechazada |
| `Promise.all([...])` | Todas (rechaza si una falla) |
| `Promise.allSettled([...])` | Todas, sin rechazar (devuelve {status, value/reason}) |
| `Promise.race([...])` | La primera en setlear |
| `Promise.any([...])` | La primera en resolverse (ignora rechazos) |

```javascript
// all: espera todas, falla si una falla
Promise.all([fetchA(), fetchB(), fetchC()])
  .then(([a, b, c]) => console.log(a, b, c));

// allSettled: espera todas, nunca falla
Promise.allSettled([p1, p2]).then(results => {
  results.forEach(r => {
    if (r.status === "fulfilled") console.log(r.value);
    else console.error(r.reason);
  });
});

// any: la primera que se resuelva
Promise.any([p1, p2, p3]).then(first => console.log(first));
```

### Encadenamiento

```javascript
fetch("/api/user")
  .then(res => res.json())
  .then(user => fetch(`/api/posts?user=${user.id}`))
  .then(res => res.json())
  .then(posts => console.log(posts))
  .catch(err => console.error(err));
```

---

## async / await

Sintaxis que hace que el código asíncrono se lea como síncrono.

```javascript
async function obtenerUsuario(id) {
  const res = await fetch(`/api/users/${id}`);
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.json();
}

// Uso
obtenerUsuario(1)
  .then(user => console.log(user))
  .catch(err => console.error(err));
```

### Ejecución en paralelo

```javascript
async function cargarTodo() {
  // Secuencial (lento)
  const a = await fetchA();
  const b = await fetchB();

  // Paralelo (rápido)
  const [a, b] = await Promise.all([fetchA(), fetchB()]);
}
```

### Bucles con await

```javascript
async function procesar(items) {
  // Secuencial
  for (const item of items) {
    await procesarUno(item);
  }

  // Paralelo (más eficiente si no hay dependencias)
  await Promise.all(items.map(item => procesarUno(item)));
}
```

### Top-level await (módulos ES)

```javascript
// solo en módulos ES (type: module)
const config = await fetch("/config").then(r => r.json());
export default config;
```

### Errores comunes

```javascript
// ❌ Olvidar await: devuelve una Promise
const datos = fetchData();   // Promise, no los datos
console.log(datos);          // Promise {<pending>}

// ✅ Correcto
const datos = await fetchData();

// ❌ await fuera de async (excepto top-level await en módulos)
// function normal() { await x; }  // SyntaxError

// ❌ forEach no espera await
items.forEach(async item => { await x; });  // no espera
// ✅ Usar for...of o Promise.all
for (const item of items) { await x; }
```

---

## fetch

API moderna para peticiones HTTP. Devuelve una Promise con el objeto `Response`.

```javascript
// GET
const res = await fetch("https://api.ejemplo.com/users");
const data = await res.json();

// Con manejo de errores
async function getJson(url) {
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`HTTP ${res.status}: ${res.statusText}`);
  }
  return res.json();
}
```

### POST / PUT / DELETE

```javascript
// POST con JSON
const res = await fetch("/api/users", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ nombre: "Ana", edad: 30 }),
});
const creado = await res.json();

// PUT
await fetch("/api/users/1", {
  method: "PUT",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ nombre: "Ana2" }),
});

// DELETE
await fetch("/api/users/1", { method: "DELETE" });

// Con Authorization
await fetch("/api/privado", {
  headers: {
    "Authorization": `Bearer ${token}`,
    "Accept": "application/json",
  },
});

// FormData (subir archivos)
const form = new FormData();
form.append("file", fileInput.files[0]);
await fetch("/upload", { method: "POST", body: form });
```

### Opciones de fetch

| Opción | Descripción |
|---|---|
| `method` | GET, POST, PUT, PATCH, DELETE |
| `headers` | Cabeceras |
| `body` | Cuerpo (string, FormData, Blob) |
| `mode` | `cors`, `no-cors`, `same-origin` |
| `credentials` | `omit`, `same-origin`, `include` |
| `cache` | `default`, `no-store`, `reload` |
| `signal` | AbortController para cancelar |

```javascript
// Timeout con AbortController
const controller = new AbortController();
const timeout = setTimeout(() => controller.abort(), 5000);
try {
  const res = await fetch(url, { signal: controller.signal });
  const data = await res.json();
} catch (err) {
  if (err.name === "AbortError") console.log("Timeout");
} finally {
  clearTimeout(timeout);
}
```

### Response: tipos de cuerpo

```javascript
await res.text();      // string
await res.json();      // objeto
await res.blob();      // Blob
await res.arrayBuffer(); // ArrayBuffer
await res.formData();  // FormData

res.headers.get("content-type");
res.status;     // 200
res.ok;         // true si 2xx
res.redirected;
```

---

## Módulos

### ES Modules (ESM, estándar)

```javascript
// math.js
export const PI = 3.14159;
export function sumar(a, b) { return a + b; }
export default function saludar() { return "hola"; }

// main.js
import saludar, { sumar, PI } from "./math.js";
import * as math from "./math.js";
import { sumar as add } from "./math.js";

// Dynamic import (devuelve Promise)
const modulo = await import("./math.js");
modulo.sumar(1, 2);
```

```html
<!-- En HTML -->
<script type="module" src="main.js"></script>
```

```json
// package.json (Node)
{ "type": "module" }
```

### CommonJS (Node clásico, sigue siendo común)

```javascript
// math.js
module.exports = {
  PI: 3.14159,
  sumar: (a, b) => a + b,
};

// main.js
const { sumar, PI } = require("./math");
// o
const math = require("./math");
```

### Diferencias ESM vs CJS

| Característica | ESM | CJS |
|---|---|---|
| Importación | `import` / `export` | `require` / `module.exports` |
| Asíncrono | Sí (puede ser) | No (síncrono) |
| `this` en módulo | `undefined` | `module.exports` |
| Hoisting | Sí | No |
| Top-level await | Sí | No |
| Estándar | Oficial | Solo Node |

---

## Clases

```javascript
class Animal {
  // propiedades de instancia
  nombre;
  edad = 0;          // con valor por defecto

  // campo estático
  static contador = 0;

  // campo privado
  #id;

  constructor(nombre) {
    this.nombre = nombre;
    this.#id = ++Animal.contador;
  }

  // método de instancia
  sonido() { return "..."; }

  // getter
  get descripcion() { return `${this.nombre} (#${this.#id})`; }

  // método estático
  static crear(nombre) { return new Animal(nombre); }

  // bloque estático (inicialización)
  static { this.especies = []; }
}

// Herencia
class Perro extends Animal {
  #raza;
  constructor(nombre, raza) {
    super(nombre);          // llama al constructor padre
    this.#raza = raza;
  }

  sonido() { return "Guau"; }   // override
  get raza() { return this.#raza; }
}

const p = new Perro("Rex", "labrador");
p.sonido();            // "Guau"
p.descripcion;         // "Rex (#1)"
Perro.crear("Luna");   // método heredado
Animal.contador;       // 2
```

### Campos privados (#)

```javascript
class Cuenta {
  #saldo = 0;
  depositar(v) { this.#saldo += v; }
  get saldo() { return this.#saldo; }
}
const c = new Cuenta();
c.#saldo;     // SyntaxError (fuera de la clase)
c.saldo;      // 0
```

### Mixins

```javascript
const Volador = Base => class extends Base {
  volar() { return `${this.nombre} vuela`; }
};
const Cantante = Base => class extends Base {
  cantar() { return `${this.nombre} canta`; }
};

class Pajaro extends Volador(Cantante(Animal)) {
  constructor(nombre) { super(nombre); }
}
```

---

## this

`this` depende de **cómo** se llama la función, no de dónde se define.

| Contexto | `this` |
|---|---|
| Método de objeto | El objeto |
| Función normal (no estricto) | `window`/`global` |
| Función normal (estricto) | `undefined` |
| Constructor (`new`) | La nueva instancia |
| Arrow function | El `this` del ámbito que la rodea |
| Event handler | El elemento del DOM |
| `call`/`apply`/`bind` | El que se pasa |

```javascript
const obj = {
  nombre: "Ana",
  saludar() { console.log(this.nombre); },
  retrasado() {
    setTimeout(function () { console.log(this.nombre); }, 100);  // undefined
    setTimeout(() => console.log(this.nombre), 100);            // "Ana"
  },
};
obj.saludar();   // "Ana"

const fn = obj.saludar;
fn();            // undefined (this se pierde)

// bind fija this
const bound = obj.saludar.bind(obj);
bound();         // "Ana"
```

### call / apply / bind

```javascript
function saludar(saludo, signo) {
  return `${saludo}, ${this.nombre}${signo}`;
}
const user = { nombre: "Ana" };

saludar.call(user, "Hola", "!");      // "Hola, Ana!"
saludar.apply(user, ["Hola", "!"]);    // "Hola, Ana!"
const bound = saludar.bind(user, "Hola");  // aplica parcial
bound("!");                           // "Hola, Ana!"
```

---

## Prototypes

JavaScript usa herencia basada en prototipos.

```javascript
// Cada objeto tiene un prototipo (objeto del que hereda)
const obj = {};
Object.getPrototypeOf(obj);   // Object.prototype

// Cadena de prototipos
const animal = { comer() { return "comiendo"; } };
const perro = Object.create(animal);
perro.ladrar = () => "guau";
perro.comer();   // "comiendo" (heredado de animal)

// Prototipo de función constructora
function Persona(nombre) { this.nombre = nombre; }
Persona.prototype.saludar = function () { return `Hola ${this.nombre}`; };
const ana = new Persona("Ana");
ana.saludar();   // "Hola Ana"
ana instanceof Persona;   // true
Object.getPrototypeOf(ana) === Persona.prototype;  // true

// ES6 class es azúcar sintáctico sobre prototypes
class Vehiculo { arrancar() { return "run"; } }
class Coche extends Vehiculo {}
const c = new Coche();
c.arrancar();   // "run"
Object.getPrototypeOf(Coche) === Vehiculo;   // true
```

### Cadena de prototipos

```
instancia  →  Clase.prototype  →  Padre.prototype  →  Object.prototype  →  null
```

```javascript
// Comprobaciones
"saludar" in ana;                  // true (incluye heredadas)
Object.hasOwn(ana, "nombre");      // true (solo propias)
ana.hasOwnProperty("nombre");      // true (clásico)
ana.isPrototypeOf(new Persona());   // false (al revés)
Persona.prototype.isPrototypeOf(ana);  // true
```

---

## Symbol

Tipo primitivo cuyos valores son únicos e inmutables. Útil para claves no colisionantes y para "well-known symbols" que definen comportamiento.

```javascript
const s1 = Symbol("id");
const s2 = Symbol("id");
s1 === s2;   // false (siempre únicos)

// Como clave de objeto
const ID = Symbol("id");
const user = { nombre: "Ana", [ID]: 123 };
Object.keys(user);       // ["nombre"] (no incluye Symbol)
Object.getOwnPropertySymbols(user);   // [Symbol(id)]
user[ID];                // 123

// Symbol.for: registro global (compartido)
const g1 = Symbol.for("app.id");
const g2 = Symbol.for("app.id");
g1 === g2;               // true
Symbol.keyFor(g1);       // "app.id"
```

### Well-known Symbols

Definen comportamiento interno del lenguaje.

```javascript
// Symbol.iterator: hace un objeto iterable
const rango = {
  inicio: 1,
  fin: 5,
  [Symbol.iterator]() {
    let n = this.inicio;
    const fin = this.fin;
    return {
      next() {
        return n <= fin ? { value: n++, done: false } : { done: true };
      },
    };
  },
};
[...rango];   // [1, 2, 3, 4, 5]
for (const n of rango) console.log(n);

// Symbol.toPrimitive: conversión a primitivo
const dinero = {
  valor: 100,
  [Symbol.toPrimitive](hint) {
    if (hint === "string") return `$${this.valor}`;
    if (hint === "number") return this.valor;
    return true;
  },
};
`${dinero}`;   // "$100"
+dinero;       // 100

// Otros: Symbol.asyncIterator, Symbol.hasInstance, Symbol.toStringTag...
```

---

## Map / Set

### Map

Colección de pares clave-valor donde la clave puede ser de cualquier tipo (incluso objetos).

| Método/Propiedad | Descripción |
|---|---|
| `new Map()` | Crea |
| `map.set(k, v)` | Añade/actualiza |
| `map.get(k)` | Obtiene |
| `map.has(k)` | Existe |
| `map.delete(k)` | Borra |
| `map.clear()` | Vacía |
| `map.size` | Nº de elementos |
| `map.forEach((v, k) => {})` | Itera |
| `for (const [k, v] of map)` | Itera |

```javascript
const m = new Map();
const claveObj = {};
m.set(claveObj, "valor asociado a objeto");
m.set("nombre", "Ana");
m.set(1, "uno");
m.get("nombre");   // "Ana"
m.has(1);          // true
m.size;            // 3
m.delete("nombre");
for (const [k, v] of m) console.log(k, v);

// Map vs Object
// - Map recuerda el orden de inserción
// - Claves de cualquier tipo
// - size es O(1)
// - Mejor rendimiento con muchos datos
```

### Set

Colección de valores únicos.

| Método/Propiedad | Descripción |
|---|---|
| `new Set(iterable)` | Crea |
| `set.add(v)` | Añade |
| `set.has(v)` | Existe |
| `set.delete(v)` | Borra |
| `set.clear()` | Vacía |
| `set.size` | Nº de elementos |
| `set.forEach(v => {})` | Itera |

```javascript
const s = new Set([1, 2, 2, 3, 3, 3]);  // Set {1, 2, 3}
s.add(4);
s.has(2);   // true
s.size;     // 4
[...s];     // [1, 2, 3, 4]

// Usos típicos de Set
// Eliminar duplicados de un array
const unicos = [...new Set([1, 1, 2, 2, 3])];   // [1, 2, 3]

// Operaciones de conjuntos
const a = new Set([1, 2, 3]);
const b = new Set([2, 3, 4]);
const interseccion = new Set([...a].filter(x => b.has(x)));   // {2, 3}
const union = new Set([...a, ...b]);                          // {1,2,3,4}
const diferencia = new Set([...a].filter(x => !b.has(x)));    // {1}
```

### WeakMap / WeakSet

```javascript
// WeakMap: claves deben ser objetos, no impide GC
const wm = new WeakMap();
let clave = {};
wm.set(clave, "datos");
wm.get(clave);   // "datos"
clave = null;     // el GC puede liberar la entrada

// WeakSet: valores deben ser objetos, débilmente referenciados
const ws = new WeakSet();
```

> WeakMap/WeakSet no son iterables ni tienen `size`: sirven para metadatos asociados a objetos sin evitar su recolección.

---

## Reflect

Objeto que ofrece funciones para operaciones fundamentales del lenguaje (reflejan métodos internos). Útil con Proxy y para evitar `Object` legacy.

| Método | Descripción |
|---|---|
| `Reflect.get(obj, key)` | Obtener propiedad |
| `Reflect.set(obj, key, val)` | Asignar propiedad |
| `Reflect.has(obj, key)` | `in` |
| `Reflect.deleteProperty(obj, key)` | `delete` |
| `Reflect.ownKeys(obj)` | Claves propias (strings + symbols) |
| `Reflect.getPrototypeOf(obj)` | Prototipo |
| `Reflect.setPrototypeOf(obj, p)` | Cambiar prototipo |
| `Reflect.apply(fn, thisArg, args)` | Llamar función |
| `Reflect.construct(fn, args)` | `new fn(...args)` |
| `Reflect.defineProperty(obj, k, desc)` | Definir propiedad |

```javascript
const obj = { a: 1 };
Reflect.get(obj, "a");           // 1
Reflect.set(obj, "b", 2);        // true
Reflect.has(obj, "a");           // true
Reflect.deleteProperty(obj, "a"); // true
Reflect.ownKeys(obj);            // ["b"]

// apply con argumentos como array
function sumar(a, b) { return a + b; }
Reflect.apply(sumar, null, [1, 2]);  // 3

// construct (new)
const fecha = Reflect.construct(Date, [2020, 0, 1]);
```

---

## Proxy

Permite interceptar y personalizar operaciones fundamentales sobre un objeto (get, set, etc.).

```javascript
const target = { nombre: "Ana", edad: 30 };
const proxy = new Proxy(target, {
  get(obj, key) {
    console.log(`Lectura de ${String(key)}`);
    return Reflect.get(obj, key);
  },
  set(obj, key, value) {
    if (key === "edad" && typeof value !== "number") {
      throw new TypeError("edad debe ser número");
    }
    return Reflect.set(obj, key, value);
  },
  has(obj, key) {
    return key.startsWith("_") ? false : Reflect.has(obj, key);
  },
});

proxy.nombre;      // log: "Lectura de nombre" → "Ana"
proxy.edad = 31;   // ok
proxy.edad = "31"; // TypeError
"_secreto" in proxy;  // false
```

### Trampas (handlers) comunes

| Trampa | Intercepta |
|---|---|
| `get` | `obj.prop` |
| `set` | `obj.prop = v` |
| `has` | `prop in obj` |
| `deleteProperty` | `delete obj.prop` |
| `ownKeys` | `Object.keys`, `for...in` |
| `getPrototypeOf` | `Object.getPrototypeOf` |
| `apply` | Llamar a la función proxy |
| `construct` | `new proxy()` |

```javascript
// Validación con Proxy
function validar(obj, reglas) {
  return new Proxy(obj, {
    set(target, key, value) {
      const regla = reglas[key];
      if (regla && !regla.test(value)) {
        throw new Error(`Valor inválido para ${String(key)}`);
      }
      target[key] = value;
      return true;
    },
  });
}

const usuario = validar(
  { nombre: "", edad: 0 },
  { nombre: /^[a-zA-Z]+$/, edad: n => n >= 0 && n <= 150 }
);
usuario.nombre = "Ana";   // ok
usuario.edad = 999;       // Error
```

```javascript
// Proxy para registrar acceso (logging/debug)
function logear(obj) {
  return new Proxy(obj, {
    get(target, key) {
      console.log(`GET ${String(key)}`);
      return target[key];
    },
    set(target, key, value) {
      console.log(`SET ${String(key)} = ${value}`);
      target[key] = value;
      return true;
    },
  });
}
const debug = logear({ x: 1 });
debug.x;        // GET x
debug.x = 5;    // SET x = 5
```

---

## Error handling

```javascript
// Lanzar errores
throw new Error("algo falló");
throw new TypeError("tipo incorrecto");
throw new RangeError("fuera de rango");

// try / catch / finally
try {
  const data = await fetch("/api").then(r => r.json());
  procesar(data);
} catch (err) {
  console.error("Error:", err.message);
  console.error(err.stack);
} finally {
  limpiar();
}

// Capturar y reenviar con contexto
try {
  await guardar(datos);
} catch (err) {
  throw new Error(`No se pudo guardar: ${err.message}`, { cause: err });
}

// Errores personalizados
class MiError extends Error {
  constructor(mensaje, codigo) {
    super(mensaje);
    this.name = "MiError";
    this.codigo = codigo;
  }
}
throw new MiError("No autorizado", 401);
```

### Tipos de Error nativos

| Constructor | Cuándo |
|---|---|
| `Error` | Genérico |
| `TypeError` | Tipo incorrecto |
| `RangeError` | Valor fuera de rango |
| `SyntaxError` | Sintaxis inválida |
| `ReferenceError` | Variable no definida |
| `URIError` | Error en `encodeURI` |
| `EvalError` | `eval` (en desuso) |

### Propiedades de Error

| Propiedad | Descripción |
|---|---|
| `err.message` | Mensaje |
| `err.name` | Nombre del constructor |
| `err.stack` | Traza de pila |
| `err.cause` | Error original (ES2022) |

```javascript
// Errores asíncronos: await + try/catch
async function conReintentos(fn, max = 3) {
  let ultimoError;
  for (let i = 0; i < max; i++) {
    try {
      return await fn();
    } catch (err) {
      ultimoError = err;
      await new Promise(r => setTimeout(r, 1000 * (i + 1)));
    }
  }
  throw ultimoError;
}
```

### Errores globales

```javascript
// Promesas no captadas
window.addEventListener("unhandledrejection", (e) => {
  console.error("Promise sin catch:", e.reason);
  e.preventDefault();
});

// Errores síncronos no capturados
window.onerror = (msg, url, line, col, err) => {
  console.error("Error global:", err?.stack || msg);
};

// En Node
process.on("unhandledRejection", (reason) => {
  console.error("Promise sin catch:", reason);
});
process.on("uncaughtException", (err) => {
  console.error("Excepción no capturada:", err);
  process.exit(1);
});
```

### Encadenamiento de errores (cause)

```javascript
async function cargarConfig() {
  try {
    const res = await fetch("/config.json");
    return await res.json();
  } catch (err) {
    // Envuelve con contexto, conservando el original
    throw new Error("No se pudo cargar la configuración", { cause: err });
  }
}

try {
  await cargarConfig();
} catch (err) {
  console.error(err.message);   // "No se pudo cargar la configuración"
  console.error(err.cause);    // TypeError: fetch failed
}
```
