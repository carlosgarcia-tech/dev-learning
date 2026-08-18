# 03 — Arrays y Objetos

## Objetivos

- [ ] Crear y manipular arrays con los métodos principales.
- [ ] Usar `push`, `pop`, `shift`, `unshift`, `slice`, `splice`, `indexOf`, `includes`, `join` y `concat`.
- [ ] Explicar copias shallow vs deep y el aliasing de referencias.
- [ ] Transformar arrays con `map`, `filter`, `reduce`, `forEach`, `some`, `every`, `find`, `findIndex`, `flat`, `flatMap`, `sort` y `reverse`.
- [ ] Crear y acceder a objetos con notación de punto y de corchetes, computed keys y shorthand properties.
- [ ] Usar `Object.keys`, `Object.values`, `Object.entries`, `Object.assign` y `Object.freeze`/`seal`.
- [ ] Aplicar destructuring en objetos y arrays, incluido anidado y en parámetros de funciones.
- [ ] Usar spread/rest en arrays, objetos y llamadas de funciones.
- [ ] Serializar con JSON (`JSON.stringify` / `JSON.parse`) conociendo sus límites.
- [ ] Entender `this` dentro de métodos y objetos.
- [ ] Usar `Map` y `Set` y saber cuándo convienen frente a objetos y arrays.
- [ ] Recorrer arrays, `Map`, `Set` y strings con `for...of`.

## Apuntes

### Arrays

Un array es una lista ordenada indexada desde 0. Con `const` puedes mutarlo pero no reasignarlo.

#### Creación, acceso y length

Se crea con el literal de corchetes, `new Array(n)`, `Array.of()` o `Array.from()`. `length` es la cantidad de elementos; acceder fuera de rango devuelve `undefined`; `at()` acepta índices negativos.

```javascript
const a = [1, 2, 3];                          // forma literal (recomendada)
const b = new Array(5);                       // 5 huecos vacíos
const c = Array.of(5);                        // [5]
const d = Array.from("hola");                 // ["h","o","l","a"]

const colores = ["rojo", "verde", "azul"];
console.log(colores.length);                  // 3
console.log(colores[99]);                     // undefined
console.log(colores.at(-1));                  // "azul"
colores.length = 2;                           // recorta el array
```

#### push, pop, shift, unshift, indexOf e includes

`push`/`pop` mutan el **final**; `unshift`/`shift` el **inicio** (`unshift` reindexa todo el array, es O(n)). `indexOf` devuelve el índice o `-1`; `includes` devuelve un booleano; `findIndex` busca con un predicado.

```javascript
const frutas = ["manzana", "pera"];
frutas.push("uva");                   // -> ["manzana","pera","uva"]
const ultima = frutas.pop();          // "uva"
frutas.unshift("kiwi");               // -> ["kiwi","manzana","pera"]
const primera = frutas.shift();       // "kiwi"

console.log(["ana", "luis"].indexOf("luis"));   // 1
console.log(["ana", "luis"].includes("ana"));   // true
console.log([18, 21, 30].findIndex((e) => e < 18)); // 0
```

#### slice, splice, join y concat

- `slice(inicio, fin)` **no muta**: devuelve un array nuevo (fin excluido).
- `splice(inicio, cantidad, ...reemplazos)` **muta**: extrae y/o reemplaza.
- `join` une los elementos en un string; `concat` combina arrays sin mutar.

```javascript
const letras = ["a", "b", "c", "d", "e"];
console.log(letras.slice(1, 3));      // ["b","c"] (original intacto)

const extraidos = letras.splice(1, 2, "X"); // extrae ["b","c"], inserta "X"
console.log(letras);                  // ["a","X","d","e"]

const nums = [1, 4];
nums.splice(1, 0, 2, 3);              // cantidad 0 = solo insertar
console.log(nums);                    // [1, 2, 3, 4]
console.log(["a", "b", "c"].join(" - "));  // "a - b - c"
console.log([1, 2].concat([3, 4]));   // [1, 2, 3, 4]
```

#### Copias shallow vs deep

`[...arr]` crea una copia **shallow**: los primitivos se copian, pero los objetos anidados siguen compartiendo la referencia.

```javascript
const original = [1, 2, [3, 4]];
const copia = [...original];
copia[2].push(5);              // SÍ afecta al original (sub-array compartido)
console.log(original);         // [1, 2, [3, 4, 5]]

const profunda = structuredClone(original); // copia profunda (ES2022+)
profunda[2].push(6);
console.log(original[2]);      // [3, 4, 5] (intacto)
```

También existen `toReversed()`, `toSorted()` y `toSpliced()` (ES2023): versiones inmutables que devuelven una copia en lugar de mutar.

### Métodos funcionales

Casi todos **no mutan** el array original. Solo `sort`, `reverse`, `splice`, `push`, `pop`, `shift` y `unshift` mutan.

#### map y filter

`map(fn)` transforma cada elemento y devuelve un array de la misma longitud; `filter(fn)` conserva los que devuelven truthy.

```javascript
const numeros = [1, 2, 3, 4, 5];
console.log(numeros.map((n) => n * 2));            // [2,4,6,8,10]
console.log(numeros.map((n, i) => n + i));         // [1,3,5,7,9]
console.log(numeros.filter((n) => n % 2 === 0));   // [2,4]

const usuarios = [
  { nombre: "Ana", activo: true },
  { nombre: "Luis", activo: false },
];
console.log(usuarios.filter((u) => u.activo)); // [{ nombre: "Ana", activo: true }]
```

#### reduce

`reduce(fn, inicial)` reduce el array a un único valor. La función recibe el acumulador y cada elemento y devuelve el acumulador siguiente. Sin valor inicial usa el primer elemento como acumulador, pero un array vacío lanza `TypeError`. También sirve para **agrupar/contar** construyendo un objeto (`acc[clave] = (acc[clave] || 0) + 1`), como en el ejemplo de frecuencias de la sección Ejemplos.

```javascript
const numeros = [1, 2, 3, 4, 5];
console.log(numeros.reduce((acc, n) => acc + n, 0)); // 15
// [].reduce((a, b) => a + b);     // TypeError (sin inicial)
```

#### forEach

`forEach(fn)` ejecuta una función por cada elemento. No devuelve nada (usa `map` para transformar) y no se puede interrumpir con `break`.

```javascript
["manzana", "pera", "uva"].forEach((fruta, indice) => {
  console.log(`${indice}: ${fruta}`);
});
// 0: manzana
// 1: pera
// 2: uva
```

#### some, every, find y findIndex

`some(fn)` → `true` si **al menos uno** cumple; `every(fn)` → `true` si **todos** cumplen. `find` devuelve el **primer** elemento que cumple (o `undefined`); `findIndex` devuelve su índice (o `-1`). `findLast`/`findLastIndex` (ES2023) buscan desde el final.

```javascript
const notas = [8, 6, 9, 7];
console.log(notas.some((n) => n >= 9));   // true
console.log(notas.every((n) => n >= 5));  // true
console.log(notas.every((n) => n >= 7));  // false

const numeros = [10, 20, 30, 40];
console.log(numeros.find((n) => n > 15));      // 20
console.log(numeros.findIndex((n) => n > 15)); // 1
console.log(numeros.find((n) => n > 99));      // undefined
console.log(numeros.findLast((n) => n > 15));  // 40
```

#### flat y flatMap

`flat(depth)` aplana sub-arrays; `flatMap(fn)` aplica `map` y aplana una profundidad de golpe (útil con `split` o `filter`-y-expande).

```javascript
const anidado = [1, [2, 3], [4, [5, 6]]];
console.log(anidado.flat());         // [1,2,3,4,[5,6]]
console.log(anidado.flat(Infinity)); // [1,2,3,4,5,6]

const palabras = ["hola mundo", "adios"];
console.log(palabras.flatMap((p) => p.split(" ")));
// ["hola","mundo","adios"]
```

#### sort y reverse

`sort` y `reverse` **mutan** el original. `sort` ordena como strings por defecto: usa siempre un comparador para números. Para strings con tildes usa `a.localeCompare(b, "es")`.

```javascript
const nums = [10, 2, 35, 4];
nums.sort();                        // como strings: [10,2,35,4] (incorrecto)
nums.sort((a, b) => a - b);         // ascendente: [2,4,10,35]
nums.sort((a, b) => b - a);         // descendente: [35,10,4,2]

const arr = [1, 2, 3];
arr.reverse();                      // muta también
console.log(arr);                   // [3,2,1]
```

Versiones inmutables (ES2023): `toSorted(comparador)`, `toReversed()` y `toSpliced()` devuelven copias.

```javascript
const base = [3, 1, 2];
console.log(base.toSorted((a, b) => a - b)); // [1,2,3]
console.log(base);                           // [3,1,2] (intacto)
```

### Objetos

Un objeto agrupa pares clave/valor. Las claves son strings (o symbols); los valores pueden ser de cualquier tipo.

#### Creación, acceso, computed keys y shorthand

Acceso con punto (`obj.clave`) o corchetes (`obj["clave"]`, para claves dinámicas o con caracteres especiales).

```javascript
const nombre = "Ana";
const usuario = {
  nombre,                            // shorthand: igual a { nombre: nombre }
  edad: 30,
  "email principal": "ana@mail.com",
};

console.log(usuario.nombre);        // "Ana"
console.log(usuario["edad"]);       // 30
const clave = "edad";
console.log(usuario[clave]);        // 30
console.log(usuario["email principal"]); // claves con espacios requieren corchetes

usuario.activo = true;              // añadir propiedad
delete usuario.edad;                // eliminar propiedad

// Computed keys: clave calculada en tiempo de ejecución
const prefijo = "usuario";
const objeto = { [`${prefijo}-42`]: "valor" };
console.log(objeto["usuario-42"]);  // "valor"
```

Los **métodos compactos** se escriben sin la sintaxis `clave: function`: `sumar() { return this.a + this.b; }`.

#### Object.keys, values y entries

Devuelven arrays con claves, valores y pares `[clave, valor]`. Útiles para iterar y transformar.

```javascript
const persona = { nombre: "Ana", edad: 30, ciudad: "Madrid" };
console.log(Object.keys(persona));    // ["nombre","edad","ciudad"]
console.log(Object.values(persona));  // ["Ana",30,"Madrid"]
console.log(Object.entries(persona)); // [["nombre","Ana"],["edad",30],["ciudad","Madrid"]]
```

`Object.fromEntries` hace el camino inverso (array de pares → objeto), lo que permite transformar un objeto pasando por un array: `Object.fromEntries(Object.entries(o).map(([k, v]) => [k, v * 2]))`.

#### Object.assign, freeze y seal

`Object.assign(destino, ...fuentes)` copia propiedades (misma profundidad que spread: shallow). `Object.freeze` impide **añadir, eliminar y modificar**; `Object.seal` impide **añadir/eliminar** pero permite **modificar**. Ambos son *shallow*: los objetos anidados siguen siendo mutables.

```javascript
const destino = Object.assign({}, { a: 1, b: 2 }, { c: 3 });
console.log(destino); // { a: 1, b: 2, c: 3 }

"use strict";
const frozen = Object.freeze({ a: 1 });
// frozen.a = 2;       // TypeError en modo estricto
console.log(Object.isFrozen(frozen)); // true

const sealed = Object.seal({ a: 1 });
sealed.a = 2;            // ok: se puede modificar
// sealed.b = 3;         // TypeError (no se puede añadir)
console.log(Object.isSealed(sealed)); // true
```

### Destructuring

Extrae valores en variables con la misma forma que el dato. Funciona con arrays (posición) y con objetos (clave).

#### Arrays: posición, saltos, rest y swap

```javascript
const puntos = [10, 20, 30];
const [x, y, z] = puntos;
console.log(x, y, z); // 10 20 30

const [, segundo, , cuarto] = [1, 2, 3, 4]; // saltos con comas vacías
console.log(segundo, cuarto); // 2 4

const [primero, ...resto] = [1, 2, 3, 4, 5]; // rest agrupa lo sobrante
console.log(primero, resto); // 1 [2,3,4,5]

const [a, b = 10] = [5];   // valor por defecto
console.log(a, b);         // 5 10
```

El **swap** sin auxiliar usa reasignación por destructuring: `[i, j] = [j, i];`.

#### Objetos: renombrado, valores por defecto y rest

```javascript
const persona = { nombre: "Luis", ciudad: "Lima", edad: 30 };
const { nombre, ciudad } = persona;
console.log(nombre, ciudad); // Luis Lima

const { nombre: n, edad } = persona;   // renombrar
console.log(n, edad);                  // Luis 30

const { pais = "Perú" } = persona;     // valor por defecto
console.log(pais);                     // Perú

const { nombre: nombreSolo, ...detalles } = persona; // rest
console.log(nombreSolo, detalles);     // Luis { ciudad: "Lima", edad: 30 }
```

#### Anidado y en parámetros de funciones

```javascript
const usuario = {
  nombre: "Ana",
  direccion: { calle: "Av. Siempre Viva", ciudad: "Lima" },
  contactos: [{ email: "ana@mail.com" }],
};
const {
  direccion: { calle, ciudad },
  contactos: [{ email }],
} = usuario;
console.log(calle, ciudad, email); // Av. Siempre Viva Lima ana@mail.com

// En la firma de la función
function saludar({ nombre, edad }) {
  return `Hola, soy ${nombre} y tengo ${edad} años`;
}
console.log(saludar({ nombre: "Ana", edad: 30 }));
```

Para valores por defecto de todo el parámetro usa `function configurar({ tema = "claro" } = {}) {}`: el `= {}` evita el error si se llama sin argumento.

### Spread y rest

- **Spread (`...`)** expande elementos donde se esperan elementos individuales.
- **Rest (`...`)** agrupa elementos sobrantes (parámetros o destructuring).

```javascript
// Spread en arrays y llamadas
const a = [1, 2];
const b = [...a, 3, 4];       // [1,2,3,4]
const d = [...a, ...b];       // combinar arrays
const copia = [...a];         // copia shallow
copia.push(99);
console.log(a, copia);        // [1,2] [1,2,99]

function sumar(a, b, c) {
  return a + b + c;
}
console.log(sumar(...[1, 2, 3]));       // 6
console.log(Math.max(...[5, 12, 8]));   // 12

// Spread en objetos (equivalente a Object.assign)
const base = { x: 1, y: 2 };
console.log({ ...base, z: 3 });         // { x: 1, y: 2, z: 3 }

// Orden importa: las últimas claves ganan
console.log({ ...base, x: 99 }.x);      // 99
console.log({ x: 99, ...base }.x);      // 1

// Rest en parámetros
function sumarTodos(...nums) {
  return nums.reduce((acc, n) => acc + n, 0);
}
console.log(sumarTodos(1, 2, 3, 4));    // 10

// Rest siempre va al final de la firma
// function f(...a, b) {} // SyntaxError
```

### JSON

Es el formato de intercambio de datos. En JS se usa `JSON.stringify` (objeto → texto) y `JSON.parse` (texto → objeto).

```javascript
const datos = { nombre: "Ana", edad: 30 };
const texto = JSON.stringify(datos);       // '{"nombre":"Ana","edad":30}'
console.log(texto, typeof texto);          // ... "string"

const deVuelta = JSON.parse(texto);        // objeto real
console.log(deVuelta.nombre);              // "Ana"
```

#### stringify: replacer y space

`JSON.stringify(valor, replacer, space)`. El `replacer` filtra o transforma valores, y `space` formatea con indentación.

```javascript
const usuario = {
  nombre: "Ana",
  edad: 30,
  password: "secreto",
  hobbies: ["leer", "correr"],
};

console.log(JSON.stringify(usuario, null, 2)); // formateado legible
// {
//   "nombre": "Ana",
//   ...

// Replacer como función: omitir campos sensibles
console.log(JSON.stringify(usuario, (clave, valor) =>
  clave === "password" ? undefined : valor
));
// '{"nombre":"Ana","edad":30,"hobbies":["leer","correr"]}'
```

El `replacer` también puede ser un **array de claves** para serializar solo esas: `JSON.stringify(usuario, ["nombre", "edad"])`.

#### parse y errores

`JSON.parse` lanza `SyntaxError` ante texto mal formado (p. ej. `'{"total": 42'` o una cadena vacía). Envuélvelo siempre en `try/catch` cuando venga de una fuente externa. El JSON válido usa comillas dobles: `'{"a": 1}'` ok, `"{a: 1}"` lanza `SyntaxError`.

#### Límites de JSON

JSON solo admite objetos, arrays, strings, números, booleanos y `null`. No admite:

- **Funciones** → se omiten al serializar.
- **`undefined`** → se omite en propiedades; en un array se convierte en `null`.
- **`NaN` / `Infinity`** → se convierten en `null`.
- **Fechas (`Date`)** → se serializan como string ISO, no como objeto Date.
- **`Map`, `Set`, `BigInt`** → sin representación nativa (`BigInt` lanza `TypeError`).
- **Referencias circulares** → lanzan `TypeError`.

```javascript
const raro = {
  fn: () => 1,
  indefinido: undefined,
  nan: NaN,
  fecha: new Date("2024-01-01"),
  set: new Set([1, 2]),
};
console.log(JSON.stringify(raro));
// '{"nan":null,"fecha":"2024-01-01T00:00:00.000Z","set":{}}'
console.log(JSON.stringify([1, undefined, 2])); // "[1,null,2]"
```

### `this` en métodos y objetos

Dentro de un método, `this` apunta al objeto sobre el que se invoca el método (el receptor). Las arrow functions **no tienen `this` propio**: heredan el del ámbito donde se definieron. Por eso un método no debe definirse como arrow.

```javascript
const contador = {
  valor: 0,
  incrementar() {
    this.valor++;      // this = contador
    return this.valor;
  },
};
console.log(contador.incrementar()); // 1

// Arrow: no crea su propio this
const mal = {
  valor: 10,
  malMetodo: () => this.valor,   // this es el ámbito global, no `mal`
};
console.log(mal.malMetodo()); // undefined

// Dentro de un método, los callbacks con arrow capturan su this
const equipo = {
  nombre: "Rojo",
  miembros: ["Ana", "Luis"],
  listar() {
    return this.miembros.map((m) => `${this.nombre}: ${m}`);
  },
};
console.log(equipo.listar());
// ["Rojo: Ana", "Rojo: Luis"]
```

El valor de `this` depende de **cómo se invoca** la función, no de dónde se define. Si la desligas de su objeto pierde el receptor (`const f = obj.quien;`); `call`/`apply` la invocan fijando `this` y `bind` devuelve una función ligada de forma permanente.

```javascript
const obj = {
  quien() {
    return this;
  },
};
console.log(obj.quien() === obj);        // true (invocada como método)

const cliente = { nombre: "Ana" };
function presentar() {
  return this.nombre;
}
console.log(presentar.call(cliente));    // "Ana" (call fija this)
console.log(presentar.bind(cliente)());  // "Ana" (bind liga de forma permanente)
```

### Maps y Sets

`Map` y `Set` son colecciones de ES6 que mejoran a objetos y arrays en ciertos casos.

#### Map

Un `Map` guarda pares clave/valor donde **las claves pueden ser de cualquier tipo** (objetos, funciones, números), no solo strings. Recuerda el orden de inserción y conoce su tamaño.

```javascript
const objetoClave = { id: 1 };
const precios = new Map();
precios.set("manzana", 1.2);
precios.set(1, "unidad");            // clave numérica válida
precios.set(objetoClave, "clave objeto");

console.log(precios.get("manzana"));  // 1.2
console.log(precios.has("pera"));     // false
console.log(precios.size);            // 3
precios.delete("manzana");
console.log(precios.size);            // 2
precios.clear();
console.log(precios.size);            // 0
```

Se crea desde un array de pares: `new Map([["a", 1], ["b", 2]])`. Se recorre con `for...of` (ver más abajo) y se convierte a array con `[...map]` o `[...map.keys()]`.

#### Map vs Objeto

| Característica     | Objeto                        | Map                             |
|--------------------|-------------------------------|---------------------------------|
| Claves             | strings/symbols               | cualquier tipo                  |
| Tamaño             | `Object.keys(o).length`       | `map.size`                      |
| Orden de iteración | claves numéricas primero      | orden de inserción              |
| Iteración directa  | `Object.entries`              | `for...of` directo              |
| Serializar JSON    | nativo                        | requiere conversión manual      |

Prefiere `Map` cuando necesites claves no-string, añadir/eliminar pares con frecuencia o el tamaño en O(1).

#### Set

Un `Set` guarda **valores únicos** (sin duplicados). Útil para deduplicar y para comprobaciones de pertenencia rápidas.

```javascript
const colores = new Set();
colores.add("rojo");
colores.add("rojo");          // ignorado: ya existe
console.log(colores.size);    // 1
console.log(colores.has("rojo")); // true
colores.delete("rojo");

// Deduplicar un array
const numeros = [1, 2, 2, 3, 3, 3, 4];
console.log([...new Set(numeros)]); // [1,2,3,4]
```

La **unión** se hace con spread (`new Set([...a, ...b])`) y la **intersección** filtrando con `has` (`[...a].filter((x) => b.has(x))`). El orden de un `Set` es el de inserción.

### Referencias: valor vs referencia

- Los **primitivos** (`string`, `number`, `boolean`, `null`, `undefined`, `bigint`, `symbol`) se asignan y comparan **por valor**.
- Los **objetos y arrays** se asignan y comparan **por referencia**: la variable guarda una referencia a la memoria, no el contenido.

```javascript
// Por valor
let a = 10;
let b = a;
b = 20;
console.log(a, b); // 10 20 (independientes)

// Por referencia (aliasing)
const obj1 = { n: 1 };
const obj2 = obj1;   // mismo objeto
obj2.n = 99;
console.log(obj1.n); // 99
```

**Aliasing**: dos nombres apuntan al mismo objeto; mutar desde uno se ve desde el otro. Para copias independientes usa spread o `slice` (shallow) y `structuredClone` (deep); el ejemplo de ambas está en la sección de Arrays.

**Comparación de objetos**: dos objetos con el mismo contenido no son `===`. Para comparar contenido hay que comparar campo a campo o serializar (con cuidado del orden de las claves): `JSON.stringify(x) === JSON.stringify(y)` da `true` aunque `x === y` sea `false`. Pasar un objeto a una función pasa la referencia: mutar dentro afecta al objeto del llamador.

### Iteración con for...of

`for...of` recorre los **valores** de cualquier iterable: arrays, strings, `Map`, `Set`, `arguments`, generadores. Los objetos planos no son iterables: convierte antes con `Object.entries`.

```javascript
// Arrays, strings y con índice usando entries
const frutas = ["manzana", "pera", "uva"];
for (const fruta of frutas) {
  console.log(fruta);
}
for (const letra of "hola") {
  console.log(letra);   // h o l a
}
for (const [i, fruta] of frutas.entries()) {
  console.log(`${i}: ${fruta}`);
}

// Map y Set son iterables directamente
for (const [clave, valor] of new Map([["a", 1], ["b", 2]])) {
  console.log(clave, valor);
}

// Objetos: convertir primero
const persona = { nombre: "Ana", edad: 30 };
for (const [clave, valor] of Object.entries(persona)) {
  console.log(`${clave}: ${valor}`);
}
// nombre: Ana
// edad: 30
```

## Ejemplos de código

```javascript
// Procesar una lista de pedidos
const pedidos = [
  { id: 1, total: 50, pagado: true },
  { id: 2, total: 120, pagado: false },
  { id: 3, total: 30, pagado: true },
];

const suma = pedidos
  .filter((p) => p.pagado)
  .map((p) => p.total)
  .reduce((acc, t) => acc + t, 0);
console.log(`Suma de pagados: ${suma}`); // 80

const [primero, ...resto] = pedidos;
console.log(primero.id, resto.length); // 1 2
```

```javascript
// Tabla de frecuencias con reduce y ranking con sort
const votos = ["a", "b", "a", "c", "a", "b"];
const frecuencias = votos.reduce((acc, v) => {
  acc[v] = (acc[v] || 0) + 1;
  return acc;
}, {});
console.log(frecuencias); // { a: 3, b: 2, c: 1 }

const ranking = Object.entries(frecuencias).sort((a, b) => b[1] - a[1]);
console.log(ranking);     // [["a",3],["b",2],["c",1]]
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)
- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

- **Mutar el array original por accidente** → `map`/`filter` devuelven nuevo; `sort`, `reverse` y `splice` mutan. Usa `toSorted`/`toReversed` si quieres una copia.
- **Olvidar el valor inicial en `reduce`** → con arrays vacíos lanza `TypeError`.
- **Copiar arrays/objetos con `=`** → no copia, crea una referencia compartida; usa spread.
- **Copiar con spread y asumir que es profunda** → los objetos anidados se comparten; usa `structuredClone` si los necesitas independientes.
- **`JSON.parse` con texto inválido, vacío o `undefined`** → lanza `SyntaxError`; valida la entrada y envuélvelo en try/catch.
- **Confundir `null` en `find`** → `find` devuelve `undefined` si no encuentra; comprueba antes de usar la propiedad.
- **Comparar objetos con `===`** → dos objetos con el mismo contenido son referencias distintas.
- **`sort` sin comparador con números** → ordena como strings: `[10, 2]` ordena como `["10","2"]`. Usa `(a, b) => a - b`.
- **Confundir `slice` con `splice`** → `slice` no muta y `splice` sí. `slice(1, 3)` extrae índices 1 y 2; `splice(1, 3)` borra 3 elementos desde el índice 1.
- **`shift`/`unshift` en arrays grandes** → reindexan todo el array; si el orden no importa, `pop`/`push` son O(1).
- **Confundir `indexOf` con `includes`** → `indexOf` devuelve `-1` si no existe (¡que es truthy!), usa `includes` para booleano o comprueba `>= 0`.
- **Usar `forEach` cuando necesitas transformar o cortar** → `forEach` no devuelve nada y no se puede interrumpir; usa `map` o `for...of` con `break`.
- **Esperar `for...of` sobre objetos** → los objetos planos no son iterables; convierte con `Object.entries`.
- **Métodos arrow en objetos** → una arrow function como método no tiene `this` propio: `this` no apunta al objeto.
- **Usar `JSON.stringify` con `undefined`, funciones o `BigInt`** → se omiten o lanzan `TypeError`; conviértelos antes si los necesitas.
- **Usar objetos como Map con claves no-string** → las claves se convierten a string (`{"[object Object]": ...}`); usa `Map` para claves de cualquier tipo.
- **No usar `Set` para deduplicar** → `[...new Set(arr)]` es más claro y rápido que `filter` con `indexOf`.

## Recursos

- [MDN — Array](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Array)
- [MDN — Array.prototype.reduce](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)
- [MDN — Array.prototype.sort](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- [MDN — Destructuring](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
- [MDN — Spread syntax](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/Spread_syntax)
- [MDN — Rest parameters](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Functions/rest_parameters)
- [MDN — JSON](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/JSON)
- [MDN — Object](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Object)
- [MDN — Map](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Map)
- [MDN — Set](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Set)
- [MDN — this](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/this)
- [MDN — structuredClone](https://developer.mozilla.org/es/docs/Web/API/structuredClone)
- [MDN — for...of](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Statements/for...of)
- [JavaScript.info — Arrays y objetos](https://es.javascript.info/object-basics)
- [JavaScript.info — Map y Set](https://es.javascript.info/map-set)
- [JavaScript.info — Destructuring](https://es.javascript.info/destructuring-assignment)