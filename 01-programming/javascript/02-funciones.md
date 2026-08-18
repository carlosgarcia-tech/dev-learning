# 02 — Funciones en JavaScript

## Objetivos

- [ ] Declarar funciones por declaración, expresión y arrow function.
- [ ] Usar parámetros, valores por defecto y `return`.
- [ ] Entender el scope (ámbito) y las variables globales/locales.
- [ ] Comprender el hoisting de declaraciones `function` y `var`.
- [ ] Crear y usar closures que "recuerdan" su entorno.

## Apuntes

### Formas de declarar funciones

1. **Declaración:** `function nombre() {}`. Es *hoisted*: puedes llamarla antes de su definición.
2. **Expresión:** se asigna a una variable. No tiene hoisting de nombre.
3. **Arrow function:** sintaxis corta, sin su propio `this`.

```javascript
function saludar(nombre) {          // declaración
  return `Hola, ${nombre}`;
}

const sumar = function (a, b) {      // expresión
  return a + b;
};

const restar = (a, b) => a - b;      // arrow con return implícito

console.log(saludar("Ana"));
console.log(sumar(2, 3));
console.log(restar(10, 4));
```

### Parámetros y return

- Los parámetros pueden tener **valores por defecto**.
- `return` devuelve un valor y termina la función. Sin `return`, devuelve `undefined`.
- El objeto `arguments` existe en funciones normales (no en arrows).
- Los parámetros **rest** `...rest` capturan los sobrantes en un array.

```javascript
function registrar(nombre, email, ...extra) {
  console.log(nombre, email, extra);
}
registrar("Ana", "ana@mail.com", "admin", "es");

function area(base, altura = 1) {
  return (base * altura) / 2;
}
console.log(area(4));      // 2
console.log(area(4, 3));   // 6
```

### Scope (ámbito)

- **Global:** visible en todo el archivo. Evita abusar de él.
- **Local (función):** creado por `var` dentro de una función.
- **Bloque (`{}`):** `let` y `const` tienen ámbito de bloque; `var` no.

```javascript
let global = "visible en todo";

function demo() {
  let local = "solo en la función";
  if (true) {
    let bloque = "solo en este bloque";
    var vieja = "se escapa del bloque"; // var NO tiene ámbito de bloque
  }
  console.log(vieja);  // ok
  // console.log(bloque); // ReferenceError
}
demo();
```

### Hoisting

JavaScript "sube" las declaraciones `function` y `var` al inicio de su ámbito en tiempo de compilación. Las declaraciones `function` están completas (nombre y cuerpo); `var` solo sube la declaración (el valor queda `undefined`). `let`/`const` existen pero no están inicializadas (zona muerta temporal).

```javascript
console.log(hola()); // funciona: "Hola"
function hola() {
  return "Hola";
}

console.log(v);   // undefined (declaración subida, valor no)
var v = 5;
```

### Closures

Un closure es una función que **recuerda** las variables de su entorno de creación, aunque ese entorno ya haya terminado de ejecutarse.

```javascript
function crearContador() {
  let cuenta = 0; // variable "privada"
  return function () {
    cuenta++;
    return cuenta;
  };
}

const contador = crearContador();
console.log(contador()); // 1
console.log(contador()); // 2
console.log(contador()); // 3
```

## Ejemplos de código

```javascript
// Fábrica de sumadores con closures
function crearSumador(n) {
  return (x) => x + n;
}
const mas5 = crearSumador(5);
console.log(mas5(10)); // 15
console.log(mas5(2));  // 7
```

```javascript
// Recorrer arrays con callbacks
const numeros = [1, 2, 3, 4];
const dobles = numeros.map((n) => n * 2);
console.log(dobles); // [2, 4, 6, 8]
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

- **Olvidar el `return`** → la función devuelve `undefined`.
- **Arrow con cuerpo `{}` sin `return`** → la llave convierte al arrow en bloque, no hay retorno implícito.
- **Usar `var` en bucles y callbacks** → el famoso problema del `var i` que comparte la misma variable.
- **Shadowing accidental** → declarar una variable local con el mismo nombre que una global oculta a la global.
- **Asumir hoisting con `let`/`const`** → `ReferenceError: Cannot access before initialization`.
- **`this` en arrow functions** → las arrows no tienen su propio `this`, heredan el del contexto.

## Recursos

- [MDN — Funciones](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide/Functions)
- [MDN — Arrow functions](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Functions/Arrow_functions)
- [MDN — Closures](https://developer.mozilla.org/es/docs/Web/JavaScript/Closures)
- [JavaScript.info — Funciones](https://es.javascript.info/function-basics)
- [JavaScript.info — Scope y closures](https://es.javascript.info/closure)