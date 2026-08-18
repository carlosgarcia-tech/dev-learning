# 02 — Funciones en JavaScript

## Objetivos

- [ ] Declarar funciones por declaración, expresión y arrow function.
- [ ] Diferenciar las tres formas de declarar y usar funciones como valores de primera clase.
- [ ] Crear y ejecutar IIFE (funciones de ejecución inmediata).
- [ ] Usar parámetros, valores por defecto, `rest`, destructuring y `return`.
- [ ] Diferenciar parámetros de argumentos y usar el objeto `arguments`.
- [ ] Entender el scope (ámbito) global, local y de bloque, y el shadowing.
- [ ] Comprender el hoisting de `function`, `var` y la zona muerta temporal de `let`/`const`.
- [ ] Crear y usar closures que "recuerdan" su entorno.
- [ ] Aplicar closures: contadores, encapsulación, memorización y patrón módulo.
- [ ] Entender el valor de `this` según el contexto y `call`/`apply`/`bind`.
- [ ] Usar funciones de orden superior: `map`, `filter`, `reduce`, `forEach`, `some`/`every`, `find`/`findIndex` y `sort`.
- [ ] Implementar recursión (factorial, fibonacci) y conocer el riesgo de desbordar la pila.
- [ ] Dominar las arrow functions: return implícito, `this` heredado y cuándo no usarlas.

## Apuntes

### Formas de declarar funciones

Existen tres formas principales de definir una función:

1. **Declaración:** `function nombre() {}`. Es *hoisted*: puedes llamarla antes de su definición.
2. **Expresión:** se asigna a una variable. No tiene hoisting de nombre, debe definirse antes de usarse.
3. **Arrow function:** sintaxis corta, sin su propio `this` ni objeto `arguments`.

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

| Característica | Declaración | Expresión | Arrow |
|---|---|---|---|
| Hoisting del nombre | Sí (completa) | No | No |
| Su propio `this` | Sí | Sí | No (hereda) |
| Objeto `arguments` | Sí | Sí | No |
| Usable con `new` | Sí | Sí | No |
| Return implícito | No | No | Sí (sin llaves) |

#### IIFE (Immediately Invoked Function Expression)

Una **IIFE** se ejecuta inmediatamente tras definirse. Se usa para aislar código y no ensuciar el scope global.

```javascript
(function () {
  console.log("Función normal inmediata");
})();

(() => {
  console.log("IIFE con arrow");
})();

const resultado = (function (a, b) {
  return a + b;
})(2, 3);
console.log(resultado); // 5
```

#### Funciones como valores de primera clase

Las funciones son *valores de primera clase*: se asignan a variables, se pasan como argumentos, se retornan desde otras funciones y se guardan en arrays u objetos.

```javascript
const operaciones = {
  suma: (a, b) => a + b,
  resta: (a, b) => a - b,
};
console.log(operaciones.suma(4, 5)); // 9

function aplicar(fn, a, b) {         // fn es una función recibida
  return fn(a, b);
}
console.log(aplicar(operaciones.suma, 10, 2)); // 12

function crearSaludo(prefijo) {      // devolvemos una función
  return (nombre) => `${prefijo}, ${nombre}`;
}
const saludoFormal = crearSaludo("Estimado");
console.log(saludoFormal("Marcos")); // Estimado, Marcos
```

### Parámetros y return

- Los parámetros pueden tener **valores por defecto** (se aplican cuando el argumento es `undefined`).
- `return` devuelve un valor y termina la función. Sin `return`, devuelve `undefined`.
- Los parámetros **rest** `...rest` capturan los sobrantes en un array real.
- Los parámetros se pueden *destructuring* directamente en la firma de la función.
- El objeto `arguments` existe en funciones normales (no en arrows).
- **Parámetro** es lo que declara la firma; **argumento** es el valor que se pasa al llamar.

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

#### Valores por defecto

```javascript
function saludar(nombre = "Invitado", saludo = "Hola") {
  return `${saludo}, ${nombre}`;
}
console.log(saludar());                     // Hola, Invitado
console.log(saludar("Ana"));                // Hola, Ana
console.log(saludar(undefined, "Qué tal")); // Qué tal, Invitado
```

Solo aplican cuando el argumento es `undefined`; si pasas `null`, se usa `null`.

#### Parámetros rest

`...rest` agrupa los argumentos sobrantes en un **array** (a diferencia de `arguments`, que es array-like). Siempre es el último parámetro y solo puede haber uno.

```javascript
function sumarTodos(...numeros) {
  return numeros.reduce((acc, n) => acc + n, 0);
}
console.log(sumarTodos(1, 2, 3, 4, 5)); // 15

function configurar(usuario, ...opciones) {
  console.log(usuario, opciones);
}
configurar("Ana", { tema: "oscuro" }, { idioma: "es" });
```

#### Destructuring de parámetros

Puedes extraer propiedades de un objeto (o elementos de un array) directamente en la firma.

```javascript
function mostrarUsuario({ nombre, edad, ciudad = "desconocida" }) {
  console.log(`${nombre}, ${edad} años, vive en ${ciudad}`);
}
mostrarUsuario({ nombre: "Ana", edad: 30 }); // Ana, 30 años, vive en desconocida

function sumarTres([a, b, c]) {
  return a + b + c;
}
console.log(sumarTres([1, 2, 3])); // 6
```

#### El objeto `arguments`

`arguments` es un objeto *array-like* con todos los argumentos pasados. Existe en funciones normales, pero **no** en arrows; ahí usa rest.

```javascript
function cuantos() {
  return arguments.length;
}
console.log(cuantos(1, 2, 3, 4)); // 4

function maximo() {
  return Math.max(...arguments); // spread convierte array-like en array
}
console.log(maximo(3, 9, 4)); // 9

const sumarArrow = (...args) => args.reduce((acc, n) => acc + n, 0);
console.log(sumarArrow(1, 2, 3)); // 6
```

### Scope (ámbito)

El **scope** determina qué variables son accesibles desde cada parte del código. JavaScript usa *scope léxico*: las funciones se resuelven según dónde fueron **escritas**, no dónde fueron llamadas.

- **Global:** visible en todo el archivo. Evita abusar de él.
- **Local (función):** creado por `var`, `let` y `const` dentro de una función.
- **Bloque (`{}`):** `let` y `const` tienen ámbito de bloque; `var` no.
- **Encadenamiento:** una función interna puede leer variables de los ámbitos externos.

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

#### Scope léxico (cadena de ámbitos)

Una función interna busca la variable en su propio ámbito y, si no la encuentra, sube por la cadena hasta el global.

```javascript
const nombre = "Globito";

function exterior() {
  const nombre = "Externa";
  function interior() {
    return nombre; // encuentra "Externa", no el global
  }
  return interior();
}
console.log(exterior()); // Externa
```

#### Shadowing

Una variable local con el mismo nombre que una del ámbito externo la **oculta** (hace *shadow*) dentro de su ámbito, sin modificarla.

```javascript
const precio = 100;

function calcular() {
  const precio = 50; // sombrea al precio global
  return precio * 2;
}
console.log(calcular()); // 100
console.log(precio);     // 100 (la global sigue intacta)
```

Evita el shadowing accidental; los linters lo marcan con la regla `no-shadow`.

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

#### Declaración de función: hoisting completo

```javascript
console.log(duplicar(4)); // 8, aunque la función se define después
function duplicar(n) {
  return n * 2;
}
```

#### `var`: solo sube la declaración

```javascript
console.log(v); // undefined
var v = 5;
```

#### `let` y `const`: zona muerta temporal (TDZ)

También se *mueven* al inicio de su ámbito, pero permanecen en la **zona muerta temporal** (Temporal Dead Zone): leerlas antes de la inicialización lanza `ReferenceError`.

```javascript
// console.log(n); // ReferenceError: Cannot access 'n' before initialization
let n = 3;

const ES_CONSTANTE = true;
// console.log(ES_CONSTANTE); // ReferenceError si se accediera antes
```

Regla práctica: declara `let`/`const` antes de usarlas.

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

// Cada llamada a la fábrica crea un entorno de closure independiente
const contadorA = crearContador();
const contadorB = crearContador();
console.log(contadorA()); // 1
console.log(contadorB()); // 1 (estado aislado)
console.log(contadorA()); // 2
```

#### Encapsulación de estado privado

El closure permite simular **propiedades privadas**: la variable solo es accesible a través de las funciones expuestas.

```javascript
function crearCuenta() {
  let saldo = 0;

  return {
    depositar(monto) {
      saldo += monto;
      return saldo;
    },
    retirar(monto) {
      if (monto > saldo) return "Fondos insuficientes";
      saldo -= monto;
      return saldo;
    },
    consultar() {
      return saldo;
    },
  };
}

const cuenta = crearCuenta();
console.log(cuenta.depositar(100)); // 100
console.log(cuenta.consultar());    // 100
console.log(cuenta.retirar(30));    // 70
console.log(cuenta.saldo);          // undefined: sin acceso directo
```

#### Memorización

Los closures permiten **cachear** resultados costosos: la caché vive en el closure.

```javascript
function crearMemoizador(fn) {
  const cache = {};

  return function (n) {
    if (n in cache) return cache[n];
    cache[n] = fn(n);
    return cache[n];
  };
}

const factorialMemo = crearMemoizador((n) => {
  console.log(`calculando ${n}`); // aparece una vez por valor
  return n <= 1 ? 1 : n * factorialMemo(n - 1);
});

console.log(factorialMemo(5)); // calculando 5 ... calculando 1, luego 120
console.log(factorialMemo(5)); // 120 (desde caché, sin logs nuevos)
```

#### Patrón módulo (IIFE con closure)

Combinando una IIFE con un closure se obtiene el **patrón módulo**: una API pública con estado interno oculto.

```javascript
const contadorModulo = (function () {
  let valor = 0;

  return {
    incrementar: () => ++valor,
    decrementar: () => --valor,
    ver: () => valor,
  };
})();

console.log(contadorModulo.incrementar()); // 1
console.log(contadorModulo.incrementar()); // 2
console.log(contadorModulo.ver());         // 2
```

#### El problema del `var` en bucles y su solución

Con `var`, todas las iteraciones comparten la **misma** variable `i`. Cuando el callback se ejecuta, `i` ya vale el último valor.

```javascript
const funcionesVar = [];
for (var i = 0; i < 3; i++) {
  funcionesVar.push(function () {
    return i;
  });
}
console.log(funcionesVar[0]()); // 3 (¡esperado 0!)
console.log(funcionesVar[2]()); // 3
```

**Solución 1:** `let` — cada iteración crea un ámbito nuevo.

```javascript
const funcionesLet = [];
for (let j = 0; j < 3; j++) {
  funcionesLet.push(() => j);
}
console.log(funcionesLet[0]()); // 0
console.log(funcionesLet[2]()); // 2
```

**Solución 2:** una IIFE que captura el valor de cada vuelta.

```javascript
const funcionesIIFE = [];
for (var k = 0; k < 3; k++) {
  (function (valor) {
    funcionesIIFE.push(() => valor);
  })(k);
}
console.log(funcionesIIFE[0]()); // 0
console.log(funcionesIIFE[1]()); // 1
```

### `this` y el contexto de llamada

El valor de `this` **no depende de dónde se define la función, sino de cómo se llama** (salvo las arrows y `bind`).

| Cómo se llama | `this` vale |
|---|---|
| `funcion()` suelta (strict mode) | `undefined` |
| `funcion()` suelta (sin strict) | el objeto global (`globalThis`) |
| `objeto.metodo()` | el objeto (`objeto`) |
| `fn.call(ctx)` / `fn.apply(ctx)` | `ctx` |
| `fn.bind(ctx)` | siempre `ctx` (función nueva) |
| Arrow function | hereda el `this` de su ámbito léxico |

```javascript
function verThis() {
  console.log(this);
}

verThis(); // undefined en modo estricto (o globalThis sin strict)

const persona = {
  nombre: "Ana",
  presentarse() {
    console.log(`Hola, soy ${this.nombre}`);
  },
};

persona.presentarse(); // Hola, soy Ana

const desacoplada = persona.presentarse;
desacoplada(); // this ya no es persona → this.nombre es undefined
```

#### `call`, `apply` y `bind`

`call` y `apply` invocan la función estableciendo `this` explícitamente; `bind` devuelve una **nueva función** con `this` fijado.

```javascript
function saludar(pais, edad) {
  console.log(`${this.nombre} vive en ${pais} y tiene ${edad} años`);
}

const ana = { nombre: "Ana" };

saludar.call(ana, "Chile", 30);   // Ana vive en Chile y tiene 30 años
saludar.apply(ana, ["Perú", 25]); // Ana vive en Perú y tiene 25 años

const saludarAna = saludar.bind(ana, "Argentina");
saludarAna(28); // Ana vive en Argentina y tiene 28 años
```

`apply` recibe los argumentos en un array; útil con spread, por ejemplo `Math.max.apply(null, numeros)`.

#### `this` en arrow functions

Las arrows **no tienen `this` propio**: usan el `this` del ámbito donde fueron creadas.

```javascript
const coche = {
  velocidad: 0,
  acelerar() {
    const suma = () => this.velocidad + 10; // arrow hereda el this de acelerar()
    this.velocidad = suma();
  },
};

coche.acelerar();
console.log(coche.velocidad); // 10
```

Sin arrow, la función interna usaría su propio `this` (undefined en strict) y el ejemplo fallaría.

### Funciones de orden superior

Una **función de orden superior** es aquella que recibe funciones como argumentos o devuelve funciones. Los métodos de array son el ejemplo más común.

#### `map` — transformar

Devuelve un **nuevo array** de la misma longitud, con cada elemento transformado.

```javascript
const numeros = [1, 2, 3, 4, 5];
const dobles = numeros.map((n) => n * 2);
console.log(dobles); // [2, 4, 6, 8, 10]
```

#### `filter` — seleccionar

Devuelve un nuevo array solo con los elementos que cumplen la condición.

```javascript
const numeros = [1, 2, 3, 4, 5];
const pares = numeros.filter((n) => n % 2 === 0);
console.log(pares); // [2, 4]
```

#### `reduce` — acumular

Recorre el array acumulando un valor; recibe un acumulador y el elemento actual.

```javascript
const numeros = [1, 2, 3, 4, 5];
const suma = numeros.reduce((acc, n) => acc + n, 0);
console.log(suma); // 15

const maximo = numeros.reduce((acc, n) => (n > acc ? n : acc), numeros[0]);
console.log(maximo); // 5

const contador = ["a", "b", "a", "c", "a"].reduce((acc, letra) => {
  acc[letra] = (acc[letra] ?? 0) + 1;
  return acc;
}, {});
console.log(contador); // { a: 3, b: 1, c: 1 }
```

#### `forEach` — recorrer con efectos

Itera sin devolver nada; útil para efectos secundarios.

```javascript
const numeros = [1, 2, 3, 4, 5];
numeros.forEach((n) => console.log(`número: ${n}`));
```

#### `some` y `every` — comprobar condiciones

`some` devuelve `true` si **al menos uno** cumple; `every` si **todos** cumplen.

```javascript
const numeros = [1, 2, 3, 4, 5];
console.log(numeros.some((n) => n > 4));  // true
console.log(numeros.every((n) => n > 0)); // true
console.log(numeros.every((n) => n > 2)); // false
```

#### `find` y `findIndex` — buscar

`find` devuelve el **primer** elemento que cumple (o `undefined`); `findIndex` su índice (o `-1`).

```javascript
const usuarios = [
  { id: 1, nombre: "Ana" },
  { id: 2, nombre: "Luis" },
  { id: 3, nombre: "Sofía" },
];

console.log(usuarios.find((u) => u.id === 2));                // { id: 2, nombre: 'Luis' }
console.log(usuarios.findIndex((u) => u.nombre === "Sofía")); // 2
console.log(usuarios.find((u) => u.id === 99));               // undefined
```

#### `sort` con comparadores

Por defecto, `sort` ordena como **strings** (`10` va antes que `2`). El comparador `(a, b)` devuelve negativo (a antes), positivo (b antes) o cero (iguales). `sort` muta el array; usa `[...arr]` si quieres una copia.

```javascript
const numeros = [10, 2, 5, 1, 33];
console.log(numeros.sort());                 // [1, 10, 2, 33, 5] (como strings)

const numeros2 = [10, 2, 5, 1, 33];
console.log(numeros2.sort((a, b) => a - b)); // [1, 2, 5, 10, 33]
console.log(numeros2.sort((a, b) => b - a)); // [33, 10, 5, 2, 1]

const usuarios = [
  { id: 1, nombre: "Ana" },
  { id: 2, nombre: "Luis" },
  { id: 3, nombre: "Sofía" },
];
const porNombre = [...usuarios].sort((a, b) => a.nombre.localeCompare(b.nombre));
console.log(porNombre.map((u) => u.nombre)); // ['Ana', 'Luis', 'Sofía']
```

### Recursión

Una función **recursiva** se llama a sí misma. Toda recursión necesita un **caso base** (cuándo dejar de llamarse) y un **caso recursivo** (cada llamada se aproxima al caso base).

#### Factorial

`n! = n * (n - 1)!`, con caso base `0! = 1`.

```javascript
function factorial(n) {
  if (n <= 1) return 1;        // caso base
  return n * factorial(n - 1); // caso recursivo
}
console.log(factorial(5)); // 120
```

#### Fibonacci

Cada término es la suma de los dos anteriores: `0, 1, 1, 2, 3, 5, 8, ...`

```javascript
function fibonacci(n) {
  if (n <= 1) return n; // caso base: fib(0) = 0, fib(1) = 1
  return fibonacci(n - 1) + fibonacci(n - 2);
}
console.log(fibonacci(6)); // 8
```

La versión ingenua recalcula lo mismo muchas veces: `fibonacci(40)` ya tarda. Se mejora con memorización (closure visto antes) o con iteración.

#### Recursión vs iteración

```javascript
function factorialIterativo(n) {
  let resultado = 1;
  for (let i = 2; i <= n; i++) {
    resultado *= i;
  }
  return resultado;
}
console.log(factorialIterativo(5)); // 120

function fibIterativo(n) {
  if (n <= 1) return n;
  let a = 0;
  let b = 1;
  for (let i = 2; i <= n; i++) {
    [a, b] = [b, a + b];
  }
  return b;
}
console.log(fibIterativo(50)); // 12586269025 (rápido, sin desbordar)
```

La iteración no consume pila por llamada y suele ser más eficiente; la recursión destaca en estructuras análogas (árboles, directorios) por su claridad.

#### Riesgo de desbordamiento de pila (stack overflow)

Cada llamada recursiva ocupa espacio en la **pila de llamadas**; demasiadas lanzan `RangeError: Maximum call stack size exceeded`.

```javascript
function recursivaInfinita() {
  return recursivaInfinita();
}
// recursivaInfinita(); // RangeError: Maximum call stack size exceeded (¡no ejecutar!)

function contar(n) {
  if (n === 0) return "fin";
  return contar(n - 1);
}
console.log(contar(1000)); // fin
// console.log(contar(100000)); // RangeError en la mayoría de motores
```

La **recursión de cola** (la llamada recursiva es la última operación) puede optimizarse en algunos motores, pero no está garantizada en JavaScript estándar: para rangos grandes prefiere iteración o memorización.

### Arrow functions en profundidad

#### Return implícito

Con cuerpo de una sola expresión (sin llaves), el arrow devuelve esa expresión automáticamente.

```javascript
const cuadrado = (n) => n * n;
console.log(cuadrado(4)); // 16

const saludo = (nombre) => `Hola, ${nombre}`;
console.log(saludo("Ana")); // Hola, Ana
```

Para devolver un **objeto literal** con retorno implícito, envuélvelo en paréntesis:

```javascript
const crearPunto = (x, y) => ({ x, y });
console.log(crearPunto(3, 5)); // { x: 3, y: 5 }
```

Sin paréntesis, las llaves se interpretan como un bloque:

```javascript
const erroneo = (x) => { x: x + 1 }; // bloque: no retorna nada
console.log(erroneo(1));             // undefined
```

#### Cuerpo con llaves

Si el cuerpo tiene varias sentencias, usa llaves y `return` explícito.

```javascript
const clasificar = (n) => {
  if (n % 2 === 0) return "par";
  return "impar";
};
console.log(clasificar(7)); // impar
```

#### `this` heredado

Las arrows no tienen `this` ni `arguments` propios: los toman del ámbito en que se crearon. Esto las hace ideales como callbacks dentro de métodos.

```javascript
const temporizador = {
  inicio: 0,
  arrancar() {
    setTimeout(() => {
      // this hereda el de arrancar() → temporizador
      console.log(this.inicio);
    }, 0);
  },
};
temporizador.arrancar(); // 0
```

Con una function normal, `this` dentro de `setTimeout` no sería `temporizador`.

#### Cuándo NO usar arrow functions

1. **Como método de objeto** que necesite `this`: el arrow no apuntará al objeto.
2. **Cuando necesites `arguments`.**
3. **Como constructor** (con `new`): las arrows lanzan `TypeError`.

```javascript
const robot = {
  nombre: "R2",
  presentarse: () => console.log(this?.nombre ?? "sin this"), // this NO es robot
};
robot.presentarse(); // sin this (o el this del ámbito exterior)

const correcto = {
  nombre: "R2",
  presentarse() {
    console.log(this.nombre);
  },
};
correcto.presentarse(); // R2

const ObjetoArrow = () => {};
// new ObjetoArrow(); // TypeError: ObjetoArrow is not a constructor
```

Regla general: usa arrows como callbacks y funciones puras; usa functions normales cuando necesites `this` dinámico, métodos de objeto o constructores.

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

```javascript
// Encadenar funciones de orden superior
const pedidos = [
  { producto: "camisa", precio: 30, unidades: 2 },
  { producto: "pantalón", precio: 45, unidades: 1 },
  { producto: "gorra", precio: 15, unidades: 5 },
];

const total = pedidos
  .filter((p) => p.unidades > 1)
  .map((p) => p.precio * p.unidades)
  .reduce((acc, subtotal) => acc + subtotal, 0);

console.log(total); // 135 (30*2 + 15*5)
```

```javascript
// Recursión: contar archivos en una estructura anidada
const estructura = {
  nombre: "src",
  hijos: [
    { nombre: "index.js" },
    {
      nombre: "lib",
      hijos: [
        { nombre: "util.js" },
        { nombre: "data.js" },
      ],
    },
    { nombre: "main.js" },
  ],
};

function contarHojas(nodo) {
  if (!nodo.hijos) return 1; // caso base: archivo sin hijos
  return nodo.hijos.reduce((acc, hijo) => acc + contarHojas(hijo), 0);
}

console.log(contarHojas(estructura)); // 3
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)

## Errores comunes

- **Olvidar el `return`** → la función devuelve `undefined`.
- **Arrow con cuerpo `{}` sin `return`** → la llave convierte al arrow en bloque, no hay retorno implícito.
- **Usar `var` en bucles y callbacks** → el famoso problema del `var i` que comparte la misma variable; usa `let` o una IIFE.
- **Shadowing accidental** → declarar una variable local con el mismo nombre que una global oculta a la global.
- **Asumir hoisting con `let`/`const`** → `ReferenceError: Cannot access before initialization` (zona muerta temporal).
- **`this` en arrow functions** → las arrows no tienen su propio `this`, heredan el del contexto.
- **Usar arrow como método de objeto** → `this` no apunta al objeto; usa una function normal.
- **Aplicar `new` a una arrow** → `TypeError: ... is not a constructor`.
- **Buscar `arguments` en arrows** → no existe; usa parámetros rest.
- **Pasar `null` a un parámetro con valor por defecto** → el valor por defecto solo aplica con `undefined`, no con `null`.
- **Ordenar números con `sort()` sin comparador** → ordena como strings (`10` antes que `2`).
- **Mutar el array con `sort`/`reverse`** → modifican el original; usa `[...arr]` si quieres una copia.
- **Recursión sin caso base** → bucle infinito que termina en `RangeError: Maximum call stack size exceeded`.
- **Parámetro rest mal ubicado** → `...rest` debe ser el último parámetro y único.
- **Pasar la función en vez de llamarla** → `objeto.metodo` sin `()` entrega la función, no la ejecuta (y pierde el `this`).

## Recursos

- [MDN — Funciones](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide/Functions)
- [MDN — Arrow functions](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Functions/Arrow_functions)
- [MDN — Closures](https://developer.mozilla.org/es/docs/Web/JavaScript/Closures)
- [JavaScript.info — Funciones](https://es.javascript.info/function-basics)
- [JavaScript.info — Scope y closures](https://es.javascript.info/closure)
- [MDN — Operador `this`](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/this)
- [MDN — Métodos de array (orden superior)](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Array)
- [MDN — Array.prototype.reduce](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)
- [MDN — Glosario: Recursión](https://developer.mozilla.org/es/docs/Glossary/Recursion)
- [JavaScript.info — Rest parameters y spread](https://es.javascript.info/rest-parameters-spread)
- [JavaScript.info — call/apply/bind](https://es.javascript.info/call-apply-decorators)
- [JavaScript.info — Recursión](https://es.javascript.info/recursion)
- [JavaScript.info — Hoisting y `var`](https://es.javascript.info/var)