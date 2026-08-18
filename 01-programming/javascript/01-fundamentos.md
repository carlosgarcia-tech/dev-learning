# 01 — Fundamentos de JavaScript

## Objetivos

- [ ] Declarar variables con `let`, `const` y `var` entendiendo sus diferencias.
- [ ] Identificar los tipos de datos primitivos y `typeof`.
- [ ] Usar template literals para interpolación de strings.
- [ ] Aplicar operadores aritméticos, de comparación y lógicos.
- [ ] Escribir condicionales `if/else if/else` y ternarios.
- [ ] Usar los bucles `for`, `while`, `do...while` y `for...of`.

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

### Template literals

Los template literals usan backticks y permiten interpolación con `${}` y texto multilínea.

```javascript
const nombre = "Ana";
const edad = 30;
console.log(`Hola, soy ${nombre} y tengo ${edad} años.`);
console.log(`Suma: ${2 + 3}`); // 5
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

## Ejercicios relacionados

- [Ejercicios nivel 01 — Fundamentos](../ejercicios/nivel-01-fundamentos/)

## Errores comunes

- **Usar `const` y luego intentar reasignar** → `TypeError: Assignment to constant variable`.
- **Usar `==` en vez de `===`** → comparaciones sorprendentes como `"0" == 0`.
- **Confundir `null` con `undefined`** → `typeof null` devuelve `"object"`, una curiosidad del lenguaje.
- **Olvidar el `break` en un `switch`** → se "cae" al siguiente caso.
- **Empezar `while` con condición falsa** → si necesitas ejecutar al menos una vez, usa `do...while`.
- **Índices fuera de rango** → acceder a `arr[arr.length]` devuelve `undefined` sin error.

## Recursos

- [MDN — JavaScript guide](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide)
- [MDN — let](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Statements/let)
- [MDN — Template literals](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Template_literals)
- [JavaScript.info — Fundamentos](https://es.javascript.info/first-steps)
- [Node.js download](https://nodejs.org/es/download)