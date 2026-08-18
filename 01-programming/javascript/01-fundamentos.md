# 01 — Fundamentos de JavaScript

## Objetivos

- [ ] Declarar variables con `let`, `const` y `var` entendiendo sus diferencias.
- [ ] Explicar mutabilidad, temporal dead zone (TDZ) y hoisting.
- [ ] Identificar los tipos de datos primitivos y `typeof`.
- [ ] Usar template literals para interpolación, multilínea y anidación.
- [ ] Aplicar operadores aritméticos, de comparación y lógicos.
- [ ] Comparar `==` con `===` y entender la coerción implícita.
- [ ] Escribir condicionales `if/else if/else`, ternarios y `switch`.
- [ ] Usar `&&`, `||` con short-circuit y el nullish coalescing `??`.
- [ ] Usar los bucles `for`, `while`, `do...while`, `for...of` y `for...in`.
- [ ] Iterar objetos con `Object.keys`, `Object.values` y `Object.entries`.
- [ ] Depurar con `console.table`, `console.group` y `console.assert`.

## Apuntes

### Variables: let, const y var

- `let` declara una variable que puede **reasignarse** (cambiar su valor).
- `const` declara una constante que **no puede reasignarse**. La referencia es fija, aunque un objeto/array declarado con `const` sí puede mutarse por dentro.
- `var` es la forma antigua: tiene ámbito de **función** (no de bloque) y permite hoisting problemático. Evítala en código moderno.
- Regla práctica: usa `const` por defecto y `let` solo cuando necesites reasignar.

```javascript
const gravedad = 9.81;      // constante, no se reasigna
let contador = 0;           // se reasigna
contador = contador + 1;    // ok

const numeros = [1, 2, 3];
numeros.push(4);            // ok: mutar el array no es reasignar
// numeros = [5];           // ERROR: no se puede reasignar
```

#### Mutabilidad

`const` no hace inmutable el valor: solo impide **reasignar** el nombre. Los contenidos de objetos y arrays siguen siendo mutables. Para congelar un objeto a fondo usa `Object.freeze()`.

```javascript
const config = { tema: "oscuro" };
config.tema = "claro";         // ok: mutamos una propiedad
// config = { tema: "claro" }; // TypeError: Assignment to constant variable

const congelado = Object.freeze({ a: 1 });
// congelado.a = 2;            // TypeError en modo estricto
```

#### Hoisting y temporal dead zone (TDZ)

El **hoisting** es el proceso por el que las declaraciones se "mueven" al inicio de su ámbito durante la compilación.

- `var` se declara (con valor `undefined`) al inicio; la asignación queda en su lugar.
- `let` y `const` también se hoistean, pero **no se inicializan**: existe una *temporal dead zone* (TDZ) desde el inicio del bloque hasta la línea de la declaración. Acceder ahí lanza `ReferenceError`.

```javascript
console.log(conVar);   // undefined (declaración subida, valor no)
var conVar = "hola";

// console.log(conLet); // ReferenceError: Cannot access 'conLet' before initialization
let conLet = "hola";
```

La TDZ también aplica dentro de bloques: no puedes usar una variable `let` antes de su declaración aunque exista una igual en el ámbito exterior.

```javascript
let x = "exterior";
{
  // console.log(x); // ReferenceError: está en TDZ (x declarada abajo en este bloque)
  let x = "interior";
  console.log(x);    // "interior"
}
```

#### Reglas de naming

- Usa **camelCase** para variables y funciones: `totalParcial`, `obtenerUsuario`.
- Usa **UPPER_SNAKE_CASE** para constantes de configuración: `MAX_RETRIES`, `API_URL`.
- Los nombres deben ser descriptivos y coherentes con el idioma del proyecto.
- No uses palabras reservadas (`let`, `class`, `function`, etc.) ni nombres que empiecen por número.

```javascript
const MAX_INTENTOS = 3;          // constante de configuración
let totalParcial = 0;            // camelCase
const usuarioActual = { nombre: "Ana" };
// const 2nombre = 1;            // SyntaxError
// let class = 1;                // SyntaxError
```

#### Tabla comparativa

| Característica        | `var`            | `let`           | `const`          |
|-----------------------|------------------|-----------------|------------------|
| Ámbito                | Función          | Bloque          | Bloque           |
| Reasignable           | Sí               | Sí              | No               |
| Hoisting              | Sí (`undefined`) | Sí (con TDZ)    | Sí (con TDZ)     |
| Declarar sin valor    | Sí               | Sí              | No (obligatorio inicializar) |
| Uso recomendado       | Evitar           | Solo si reasignas | Por defecto    |

### Tipos de datos primitivos

- `string` — texto: `"hola"`, `'hola'`, `` `hola` ``.
- `number` — números: enteros y decimales (`3.14`).
- `boolean` — `true` o `false`.
- `null` — valor intencionalmente vacío.
- `undefined` — variable declarada sin valor.
- `bigint` — enteros muy grandes (`10n`).
- `symbol` — identificadores únicos.

Además existe el tipo **`object`**, que agrupa arrays, objetos, funciones y fechas.

```javascript
console.log(typeof "texto");  // "string"
console.log(typeof 42);       // "number"
console.log(typeof true);     // "boolean"
console.log(typeof null);     // "object"  <-- peculiaridad histórica de JS
console.log(typeof x);        // "undefined" (x no existe)
console.log(typeof {});       // "object"
console.log(typeof []);       // "object"
```

#### number: NaN, Infinity y precisión

- `NaN` (Not a Number) representa un resultado numérico inválido. Es el **único valor que no es igual a sí mismo**: compruébalo con `Number.isNaN()`, nunca con `NaN === NaN`.
- `Infinity` y `-Infinity` representan valores infinitos (por ejemplo, al dividir por cero).
- `Number.MAX_SAFE_INTEGER` es `9007199254740991`: por encima de él los enteros pierden precisión. Para números mayores usa `bigint`.
- Los decimales en coma flotante no son exactos: `0.1 + 0.2` no es `0.3`.

```javascript
console.log(0 / 0);               // NaN
console.log(NaN === NaN);         // false
console.log(Number.isNaN(NaN));   // true
console.log(1 / 0);               // Infinity

console.log(0.1 + 0.2);           // 0.30000000000000004
console.log((0.1 + 0.2).toFixed(2)); // "0.30"

console.log(Math.max(3, 8, 1));   // 8
console.log(Math.floor(4.7));     // 4
console.log(Math.round(4.5));     // 5
console.log(Math.random());       // número entre 0 y 1
```

Para comparar decimales usa una tolerancia (épsilon), no igualdad exacta.

```javascript
const casiIgual = (a, b) => Math.abs(a - b) < 1e-9;
console.log(casiIgual(0.1 + 0.2, 0.3)); // true
```

#### string y sus métodos

Los strings son **inmutables**: ningún método los modifica, todos devuelven un string nuevo.

```javascript
const texto = "JavaScript es genial";

console.log(texto.slice(0, 10));       // "JavaScript"
console.log(texto.substring(0, 10));   // "JavaScript"
console.log(texto.includes("genial")); // true
console.log(texto.toLowerCase());      // "javascript es genial"
console.log("hola".toUpperCase());     // "HOLA"

const csv = "ana,luis,carla";
console.log(csv.split(","));           // ["ana", "luis", "carla"]

console.log("7".padStart(3, "0"));     // "007"
console.log("abc".padEnd(5, "-"));     // "abc--"
console.log("  texto  ".trim());       // "texto"
console.log(texto.startsWith("Java")); // true
console.log("a-b-c".replaceAll("-", "_")); // "a_b_c"
```

Diferencia clave entre `slice` y `substring`: `slice` acepta índices negativos (cuenta desde el final) y `substring` los trata como `0`.

```javascript
console.log("abcdef".slice(-3));      // "def"
console.log("abcdef".substring(-3));  // "abcdef" (negativo => 0)
console.log("abcdef".slice(1, 4));    // "bcd"
```

#### boolean: truthy y falsy

Un valor es falsy si es uno de: `false`, `0`, `-0`, `0n`, `""`, `null`, `undefined`, `NaN`. **Todo lo demás es truthy**, incluidos `[]`, `{}`, `"0"` y `"false"`.

| Valor            | Truthy | Nota                          |
|------------------|--------|-------------------------------|
| `0`, `-0`, `0n`  | No     | cero y BigInt cero            |
| `""`             | No     | string vacío                  |
| `null`           | No     | ausencia intencional          |
| `undefined`      | No     | sin asignar                   |
| `NaN`            | No     | número no válido              |
| `"0"`            | Sí     | string con texto              |
| `" "`            | Sí     | string con espacio            |
| `[]`, `{}`       | Sí     | objetos vacíos                |

```javascript
if ("0") {
  console.log("truthy");   // entra: "0" es truthy
}
console.log(Boolean([]));  // true
console.log(Boolean(0));   // false
console.log(!!"hola");     // true (doble negación fuerza a boolean)
```

#### bigint

`bigint` permite enteros arbitrariamente grandes. Se crea con sufijo `n` o con la función `BigInt()`. No se puede mezclar con `number` en operaciones aritméticas sin conversión explícita.

```javascript
const grande = 123456789012345678901234567890n;
console.log(grande + 1n);   // 123456789012345678901234567891n
console.log(typeof grande); // "bigint"
// console.log(grande + 1); // TypeError: Cannot mix BigInt and other types
console.log(Number("9007199254740993")); // 9007199254740992 (pierde precisión)
```

#### symbol

`Symbol()` crea un identificador único, útil como clave de objeto o para evitar colisiones. Cada llamada genera un símbolo distinto, incluso con la misma descripción.

```javascript
const id1 = Symbol("id");
const id2 = Symbol("id");
console.log(id1 === id2);          // false (únicos aunque compartan descripción)

const usuario = { nombre: "Ana" };
const secreto = Symbol("clave");
usuario[secreto] = "valor oculto";
console.log(usuario[secreto]);     // "valor oculto"
console.log(Object.keys(usuario)); // ["nombre"] (las claves symbol no se listan)
```

#### null vs undefined

Ambos representan "no hay valor", pero con intención distinta:

- `undefined` es el valor por defecto de una variable declarada sin inicializar, de un parámetro no pasado o de una propiedad inexistente.
- `null` es un valor **explícito** que tú asignas para indicar "vacío a propósito".

```javascript
let a;              // undefined (implícito)
let b = null;       // null (explícito)
function f(x) {}    // x vale undefined si no se pasa
console.log(typeof undefined);   // "undefined"
console.log(typeof null);        // "object"
console.log(undefined == null);  // true  (con coerción)
console.log(undefined === null); // false (tipos distintos)
```

### Template literals

Los template literals usan backticks y permiten interpolación con `${}` y texto multilínea.

```javascript
const nombre = "Ana";
const edad = 30;
console.log(`Hola, soy ${nombre} y tengo ${edad} años.`);
console.log(`Suma: ${2 + 3}`); // 5
```

#### Interpolación

Dentro de `${}` se puede meter **cualquier expresión**: variables, llamadas a funciones, ternarios, operaciones. JavaScript la evalúa y la convierte a string.

```javascript
const precio = 25;
const iva = 0.21;
console.log(`Total con IVA: ${precio * (1 + iva)}`); // "Total con IVA: 30.25"

const usuario = { nombre: "Luis", rol: "admin" };
console.log(`${usuario.nombre} es ${usuario.rol === "admin" ? "administrador" : "usuario"}`);
```

#### Multilínea

Con backticks el salto de línea es literal: no hace falta `\n` ni concatenación.

```javascript
const texto = `Línea uno
Línea dos
Línea tres`;
console.log(texto);
// Línea uno
// Línea dos
// Línea tres

const conFormato = `Dirección:
  Calle Falsa 123
  Madrid`;
```

#### Anidación de expresiones

Un template literal puede contener otros template literals. Si la anidación se complica, conviene extraerla a una variable para mantener la legibilidad.

```javascript
const precios = [5, 10, 15];
const resumen = precios.map(
  (p) => `Item: ${p} -> ${p >= 10 ? "caro" : "barato"}`
);
console.log(resumen.join("\n"));

const fila = (etiqueta, valor) => `| ${etiqueta} | ${valor} |`;
console.log(fila("Nombre", "Ana"));
```

### Operadores

- **Aritméticos:** `+ - * / % **` (módulo y potencia).
- **Comparación:** `== === != !== > < >= <=`. Usa siempre `===` para evitar coerción sorprendente.
- **Lógicos:** `&& || !`.
- **Asignación:** `= += -= *= /= ++ --`.

```javascript
console.log(7 % 3);   // 1 (resto)
console.log(2 ** 10); // 1024 (potencia)
console.log(5 === "5"); // false (tipos distintos)
console.log(5 == "5");  // true  (coerción: evítalo)
console.log(!true);   // false
```

#### Precedencia

Los operadores se evalúan según su precedencia, como en matemáticas. Los paréntesis sobreescriben el orden: `**` liga antes que la multiplicación, y la multiplicación antes que la suma. Los operadores con la misma precedencia se evalúan de izquierda a derecha (salvo `**`, que es asociativo por la derecha).

```javascript
console.log(2 + 3 * 4);     // 14  (primero la multiplicación)
console.log((2 + 3) * 4);   // 20  (paréntesis primero)
console.log(2 ** 3 * 2);    // 16  (** antes que *)
console.log(10 - 4 - 3);    // 3   (asociativo por la izquierda)
console.log(2 ** 3 ** 2);   // 512 (2 ** (3 ** 2))
```

#### Coerción implícita y `==` vs `===`

La **coerción implícita** convierte tipos automáticamente. `==` aplica coerción antes de comparar; `===` compara valor **y** tipo sin convertir. Regla práctica: usa siempre `===`.

| Expresión           | `==`  | `===` | Motivo                         |
|---------------------|-------|-------|--------------------------------|
| `1 == "1"`          | true  | false | `"1"` se convierte a número   |
| `0 == false`        | true  | false | `false` se convierte a `0`    |
| `"" == 0`           | true  | false | ambos se convierten a número  |
| `null == undefined` | true  | false | "vacíos" equivalentes         |
| `NaN == NaN`        | false | false | NaN nunca es igual a sí mismo |
| `"1" === "1"`       | true  | true  | mismo tipo y valor            |

```javascript
console.log("5" - 2);     // 3   (string a número en la resta)
console.log("5" + 2);     // "52" (+ con string concatena)
console.log(+"5");        // 5   (unario convierte a número)
console.log(Number("5")); // 5   (conversión explícita, preferible)
```

#### Operador de concatenación `+`

Cuando al menos uno de los operandos es un string, `+` concatena en vez de sumar. El resto de operadores aritméticos (`-`, `*`, `/`) siempre intentan convertir a número.

```javascript
console.log("Hola" + " mundo");  // "Hola mundo"
console.log(2 + "2");            // "22"
console.log(2 + 2 + "2");        // "42" (evalúa de izquierda a derecha)
console.log("10" - 3);           // 7
console.log("10" * 2);           // 20
console.log("10" / "2");         // 5
```

#### Comparación de objetos por referencia

Los objetos (incluidos arrays y funciones) se comparan por **referencia**, no por contenido. Dos objetos con las mismas propiedades son distintos; dos variables que apuntan al mismo objeto son iguales.

```javascript
const a = { x: 1 };
const b = { x: 1 };
const c = a;

console.log(a === b);   // false (objetos distintos)
console.log(a === c);   // true  (misma referencia)
console.log([] == []);  // false (los arrays también son referencias)
```

### Condicionales

`if`, `else if`, `else` evalúan valores de verdad. Recuerda los *falsy*: `0`, `""`, `null`, `undefined`, `NaN`, `false`.

El ternario `condición ? valorSiTrue : valorSiFalse` es una expresión que devuelve un valor.

```javascript
const nota = 85;
if (nota >= 90) {
  console.log("Excelente");
} else if (nota >= 70) {
  console.log("Aprobado");
} else {
  console.log("Reprobado");
}

const resultado = nota >= 60 ? "aprueba" : "reprueba";
console.log(resultado);
```

#### Ternarios anidados

Los ternarios se pueden anidar encadenándolos en la rama `false`. Funcionan, pero la legibilidad se resiente: para más de dos niveles prefiere `if/else` o un objeto de búsqueda.

```javascript
const puntaje = 75;
const nivel =
  puntaje >= 90 ? "A" :
  puntaje >= 70 ? "B" :
  puntaje >= 50 ? "C" : "D";
console.log(nivel); // "B"

const saludo = (hora) =>
  hora < 12 ? "Buenos días" : hora < 18 ? "Buenas tardes" : "Buenas noches";
console.log(saludo(9));  // "Buenos días"
console.log(saludo(20)); // "Buenas noches"
```

#### switch

`switch` compara un valor contra varios `case`. Cada `case` necesita `break` para no "caerse" al siguiente. La comparación es estricta (`===`, sin coerción). Agrupar varios `case` seguidos comparte el mismo bloque.

```javascript
const dia = "martes";
switch (dia) {
  case "lunes":
    console.log("Inicio de semana");
    break;
  case "martes":
  case "miércoles":
  case "jueves":
    console.log("Mitad de semana");
    break;
  case "viernes":
    console.log("¡Por fin viernes!");
    break;
  default:
    console.log("Fin de semana");
}
```

#### Operadores lógicos y short-circuit

- `&&` devuelve el primer valor falsy, o el último si todos son truthy.
- `||` devuelve el primer valor truthy, o el último si todos son falsy.
- Ambos **cortocircuitan**: dejan de evaluar en cuanto hay resultado. Por eso sirven como valores por defecto o guardas.

```javascript
console.log(0 && "hola");      // 0    (falsy: corta la evaluación)
console.log(1 && "hola");      // "hola"
console.log("" || "defecto");  // "defecto"
console.log("texto" || "defecto"); // "texto"

// Guarda: si `usuario` es null, no se evalúa la segunda parte
const usuario = null;
const nombre = usuario && usuario.nombre; // null
```

Cuidado con `||` como valor por defecto: `0`, `""` y `NaN` también son falsy y activarán el defecto. Para filtrar solo `null`/`undefined` usa el **nullish coalescing** `??`.

```javascript
const a = 0;
console.log(a || 10);  // 10  (0 es falsy)
console.log(a ?? 10);  // 0   (solo null/undefined activan el defecto)

const b = null;
console.log(b ?? 10);  // 10
console.log(b || 10);  // 10
```

`??` no se puede mezclar con `&&`/`||` sin paréntesis (lanza `SyntaxError`).

```javascript
// console.log(true || x ?? 1); // SyntaxError
console.log((true || x) ?? 1);  // ok con paréntesis
```

También existe el encadenamiento opcional `?.`, que evita errores al acceder a propiedades de posibles `null`/`undefined`.

```javascript
const persona = null;
console.log(persona?.nombre);      // undefined (no lanza error)
console.log(persona?.direccion?.calle ?? "sin dirección"); // "sin dirección"
```

### Bucles

- `for` — repetición con contador.
- `while` — repite mientras la condición sea verdadera (revisa antes).
- `do...while` — ejecuta al menos una vez (revisa después).
- `for...of` — recorre valores de arrays, strings, etc.
- `break` corta el bucle; `continue` salta a la siguiente iteración.

```javascript
for (let i = 0; i < 3; i++) {
  console.log(i); // 0, 1, 2
}

let n = 0;
while (n < 3) {
  n++;
}

const frutas = ["manzana", "pera", "uva"];
for (const fruta of frutas) {
  console.log(fruta);
}
```

#### for...of con entries

`for...of` recorre valores. Combinándolo con `Array.entries()` (o `Map`, o `Object.entries()`) se obtienen pares `[índice, valor]` que se pueden desestructurar.

```javascript
const colores = ["rojo", "verde", "azul"];
for (const [indice, color] of colores.entries()) {
  console.log(`${indice}: ${color}`);
}
// 0: rojo
// 1: verde
// 2: azul

for (const [indice, letra] of "abc".split("").entries()) {
  console.log(indice, letra);
}
// 0 a
// 1 b
// 2 c
```

#### for...in: advertencia

`for...in` itera sobre **claves enumerables** (como strings), no valores, e incluye propiedades heredadas del prototipo. Para recorrer objetos prefiere `Object.keys/values/entries`; para arrays usa `for...of`.

```javascript
const obj = { a: 1, b: 2 };
for (const clave in obj) {
  console.log(clave); // "a", "b"
}

const arr = [10, 20, 30];
for (const idx in arr) {
  console.log(idx); // "0", "1", "2"  (¡strings, no números!)
}
```

#### while y do...while

- `while` evalúa la condición **antes** de cada iteración: si es falsa al inicio, no ejecuta nada.
- `do...while` ejecuta el cuerpo **una vez** y luego evalúa la condición.

```javascript
let contador = 5;
while (contador > 0) {
  console.log(contador--);
}

let intento = 0;
do {
  console.log(`Intento ${intento}`);
  intento++;
} while (intento < 2);
// Intento 0
// Intento 1

// Diferencia clave:
let falso = false;
while (falso) {
  console.log("nunca");          // no se ejecuta
}
do {
  console.log("al menos una vez"); // sí se ejecuta
} while (falso);
```

#### break/continue con labels

`break` y `continue` cortan el bucle más interno. Con una **label** (etiqueta) se puede controlar un bucle externo desde dentro de uno anidado.

```javascript
outer: for (let i = 0; i < 3; i++) {
  for (let j = 0; j < 3; j++) {
    if (i === 1 && j === 1) {
      break outer; // sale de ambos bucles
    }
    console.log(`${i},${j}`);
  }
}
// 0,0 0,1 0,2 1,0

outer2: for (let i = 0; i < 3; i++) {
  for (let j = 0; j < 3; j++) {
    if (j === 1) {
      continue outer2; // salta la iteración del bucle externo
    }
    console.log(`${i},${j}`);
  }
}
// 0,0 1,0 2,0
```

#### Iteración sobre objetos

`for...of` no funciona directamente sobre objetos (no son iterables). Usa los métodos de `Object`:

- `Object.keys(obj)` → array de claves.
- `Object.values(obj)` → array de valores.
- `Object.entries(obj)` → array de pares `[clave, valor]`.

```javascript
const persona = { nombre: "Ana", edad: 30, ciudad: "Madrid" };

console.log(Object.keys(persona));   // ["nombre", "edad", "ciudad"]
console.log(Object.values(persona)); // ["Ana", 30, "Madrid"]

for (const [clave, valor] of Object.entries(persona)) {
  console.log(`${clave}: ${valor}`);
}
// nombre: Ana
// edad: 30
// ciudad: Madrid

Object.entries(persona).forEach(([clave, valor]) => {
  console.log(clave, valor);
});
```

### console avanzado

Además de `console.log`, la consola ofrece utilidades para inspeccionar datos estructurados y agrupar la salida.

#### console.table

`console.table` imprime arrays y objetos en formato de tabla, ideal para revisar colecciones de un vistazo.

```javascript
const usuarios = [
  { nombre: "Ana", edad: 30 },
  { nombre: "Luis", edad: 25 },
];
console.table(usuarios);

const puntajes = { ana: 90, luis: 70 };
console.table(puntajes);
```

#### console.group

`console.group` y `console.groupEnd` agrupan mensajes en bloques colapsables. Útil para estructurar la salida de una función.

```javascript
console.group("Cálculo");
console.log("Paso 1: leer datos");
console.group("Subcálculo");
console.log("Multiplicando...");
console.groupEnd();
console.log("Paso 2: mostrar resultado");
console.groupEnd();

console.groupCollapsed("Grupo colapsado"); // empieza cerrado
console.log("Contenido oculto");
console.groupEnd();
```

#### console.assert

`console.assert(condición, mensaje)` solo imprime el mensaje si la condición es falsa. Sirve como "mini-test" dentro de scripts.

```javascript
console.assert(2 + 2 === 4, "La suma debería dar 4"); // no imprime nada
console.assert(2 + 2 === 5, "La suma debería dar 5"); // Assertion failed: ...

const doble = (n) => n * 2;
console.assert(doble(4) === 8, "doble(4) debe ser 8");
console.assert(doble(4) === 9, "doble(4) debe ser 9");
```

## Ejemplos de código

```javascript
// Programa completo: tabla de multiplicar con template literals
const numero = 7;
for (let i = 1; i <= 10; i++) {
  console.log(`${numero} x ${i} = ${numero * i}`);
}
```

```javascript
// Comprobador de números
function clasificar(n) {
  if (n % 2 === 0) {
    return `${n} es par`;
  }
  return `${n} es impar`;
}
console.log(clasificar(10)); // "10 es par"
console.log(clasificar(7));  // "7 es impar"
```

```javascript
// Nota textual con switch sobre decenas
function notaTextual(nota) {
  switch (Math.floor(nota / 10)) {
    case 10:
    case 9:
      return "Sobresaliente";
    case 8:
    case 7:
      return "Notable";
    case 6:
    case 5:
      return "Aprobado";
    default:
      return "Suspenso";
  }
}
console.log(notaTextual(95)); // "Sobresaliente"
console.log(notaTextual(55)); // "Aprobado"
```

```javascript
// Recorrer un objeto con Object.entries
const coche = { marca: "Toyota", modelo: "Corolla", año: 2022 };
for (const [clave, valor] of Object.entries(coche)) {
  console.log(`${clave}: ${valor}`);
}
// marca: Toyota
// modelo: Corolla
// año: 2022
```

```javascript
// Defensa contra valores inválidos con short-circuit y nullish
function formatear(usuario) {
  const nombre = usuario?.nombre ?? "Anónimo";
  const mayor = usuario?.edad >= 18 ? "mayor" : "menor";
  return `${nombre} es ${usuario?.edad ?? "?"} años (${mayor})`;
}
console.log(formatear({ nombre: "Ana", edad: 30 })); // Ana es 30 años (mayor)
console.log(formatear(null));                        // Anónimo es ? años (menor)
```

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)

## Errores comunes

- **Usar `const` y luego intentar reasignar** → `TypeError: Assignment to constant variable`.
- **Usar `==` en vez de `===`** → comparaciones sorprendentes como `"0" == 0`.
- **Confundir `null` con `undefined`** → `typeof null` devuelve `"object"`, una curiosidad del lenguaje.
- **Olvidar el `break` en un `switch`** → se "cae" al siguiente caso.
- **Empezar `while` con condición falsa** → si necesitas ejecutar al menos una vez, usa `do...while`.
- **Índices fuera de rango** → acceder a `arr[arr.length]` devuelve `undefined` sin error.
- **Comprobar `NaN` con `NaN === NaN`** → siempre es `false`. Usa `Number.isNaN()`.
- **Confiar en `0.1 + 0.2 === 0.3`** → en coma flotante da `0.30000000000000004`. Compara con una tolerancia.
- **Acceder a una variable `let`/`const` antes de declararla** → `ReferenceError` por la TDZ.
- **Usar `||` para valores por defecto y sorprenderse con `0` o `""`** → son falsy; si solo quieres filtrar `null`/`undefined`, usa `??`.
- **Comparar objetos con `===`** → compara referencias, no contenido. `{ a: 1 } === { a: 1 }` es `false`.
- **Confundir `slice` con `substring`** → `slice` acepta índices negativos; `substring` los trata como `0`.
- **Usar `for...in` sobre arrays** → itera sobre claves (strings), no valores; incluye propiedades heredadas.

## Recursos

- [MDN — JavaScript guide](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide)
- [MDN — let](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Statements/let)
- [MDN — Template literals](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Template_literals)
- [MDN — Igualdad y sameness](https://developer.mozilla.org/es/docs/Web/JavaScript/Equality_comparisons_and_sameness)
- [MDN — Number](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Number)
- [MDN — String](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/String)
- [MDN — BigInt](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/BigInt)
- [MDN — Symbol](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
- [MDN — Nullish coalescing (`??`)](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing)
- [MDN — console](https://developer.mozilla.org/es/docs/Web/API/console)
- [MDN — Loop label](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Statements/label)
- [JavaScript.info — Fundamentos](https://es.javascript.info/first-steps)
- [JavaScript.info — Comparaciones](https://es.javascript.info/comparison)
- [Node.js download](https://nodejs.org/es/download)