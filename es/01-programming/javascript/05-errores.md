# 05 — Errores en JavaScript

## Objetivos

- [ ] Lanzar errores manualmente con `throw`.
- [ ] Capturar errores con `try`, `catch` y `finally`.
- [ ] Distinguir los tipos de error nativos (`TypeError`, `ReferenceError`, `SyntaxError`, etc.).
- [ ] Crear errores personalizados extendiendo `Error`.
- [ ] Identificar los errores más comunes de JS y depurarlos.

## Apuntes

### Lanzar errores con throw

`throw` detiene la ejecución y entrega un valor (normalmente un objeto `Error`). Puedes lanzar cualquier cosa, pero es buena práctica usar `Error` para conservar el *stack trace*.

```javascript
function dividir(a, b) {
  if (b === 0) {
    throw new Error("No se puede dividir entre cero");
  }
  return a / b;
}

console.log(dividir(10, 2)); // 5
// console.log(dividir(10, 0)); // Error: No se puede dividir entre cero
```

### try / catch / finally

- `try` — bloque que puede fallar.
- `catch` — se ejecuta solo si algo lanzó un error. Recibe el error como parámetro.
- `finally` — se ejecuta **siempre**, haya o no error (ideal para limpiar recursos).

```javascript
try {
  const resultado = dividir(10, 0);
  console.log(resultado);
} catch (error) {
  console.error("Algo falló:", error.message);
} finally {
  console.log("Este bloque siempre corre");
}
```

### Tipos de error nativos

| Error | Cuándo ocurre |
|---|---|
| `TypeError` | Operar con un tipo inapropiado (ej. `null.propiedad`). |
| `ReferenceError` | Usar una variable no declarada. |
| `SyntaxError` | El código no es válido sintácticamente. |
| `RangeError` | Un valor fuera del rango permitido (ej. `new Array(-1)`). |
| `Error` | Error genérico; base de todos los demás. |

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
```

### Errores personalizados

Extiende `Error` para crear errores con significado semántico.

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

### Errores comunes de JS y cómo depurarlos

1. **`ReferenceError: x is not defined`** — Variable no declarada. Revisa la ortografía y el ámbito.
2. **`TypeError: Cannot read property of undefined`** — Accedes a una propiedad de un valor `undefined`. Comprueba que el dato llegó.
3. **`TypeError: Assignment to constant variable`** — Reasignaste un `const`.
4. **`Cannot read properties of null`** — `document.getElementById(...)` devolvió `null` (el selector no existe).
5. **`SyntaxError: Unexpected token`** — Falta una llave, paréntesis o coma.
6. **`NaN` como resultado** — Operación inválida como `"abc" * 2` o `undefined + 1`.

Técnicas de depuración:
- `console.log()` / `console.table()` / `console.dir()` para inspeccionar.
- `console.error()` para mensajes de error, y `console.warn()` para advertencias.
- `debugger;` pausa la ejecución en herramientas de desarrollo.
- Node: `node --inspect-brk archivo.js` abre el inspector de Chrome DevTools.

```javascript
console.table([
  { nombre: "Ana", edad: 30 },
  { nombre: "Luis", edad: 28 },
]);
console.error("Esto es un error");
```

## Ejemplos de código

```javascript
// Validador con manejo completo de errores
function procesarNumero(texto) {
  const numero = Number(texto);
  if (texto.trim() === "") {
    throw new RangeError("El campo está vacío");
  }
  if (Number.isNaN(numero)) {
    throw new TypeError("No es un número válido");
  }
  if (numero < 0) {
    throw new RangeError("El número no puede ser negativo");
  }
  return numero * 2;
}

const entradas = ["10", "abc", "", "-5"];
for (const entrada of entradas) {
  try {
    console.log(`Entrada "${entrada}" -> ${procesarNumero(entrada)}`);
  } catch (e) {
    console.log(`Entrada "${entrada}" -> Error (${e.name}): ${e.message}`);
  }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)

## Errores comunes

- **Tragar errores silenciosamente** → un `catch` vacío oculta bugs. Al menos registra con `console.error`.
- **`catch` sin parámetro en la rama que necesita el error** → la variable no existe ahí.
- **Olvidar `finally` para limpiar** → conexiones o archivos abiertos pueden quedar colgados.
- **Lanzar strings en vez de `Error`** → pierdes el stack trace; lanza siempre `new Error(...)`.
- **`JSON.parse` sin try/catch** → un JSON inválido rompe el programa.
- **Ignorar el campo `message` y `stack`** → son la mejor pista para depurar.

## Recursos

- [MDN — Control de flujo y manejo de errores](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide/Control_flow_and_error_handling)
- [MDN — Error](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Error)
- [MDN — console](https://developer.mozilla.org/es/docs/Web/API/console)
- [Node.js — Debugging](https://nodejs.org/en/learn/getting-started/debugging)
- [JavaScript.info — Manejo de errores](https://es.javascript.info/error-handling)