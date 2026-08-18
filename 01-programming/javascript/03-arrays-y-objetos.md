# 03 — Arrays y Objetos

## Objetivos

- [ ] Crear y manipular arrays con los métodos principales.
- [ ] Usar `push`, `pop`, `shift`, `unshift`, `slice`, `splice` y `indexOf`.
- [ ] Transformar arrays con `map`, `filter`, `reduce` y `find`.
- [ ] Crear y acceder a objetos con notación de punto y de corchetes.
- [ ] Aplicar destructuring en objetos y arrays.
- [ ] Usar spread/rest y JSON (`JSON.stringify` / `JSON.parse`).

## Apuntes

### Arrays

Un array es una lista ordenada indexada desde 0. Con `const` puedes mutarlo pero no reasignarlo.

```javascript
const frutas = ["manzana", "pera"];
console.log(frutas.length);      // 2
console.log(frutas[0]);          // "manzana"

frutas.push("uva");              // añade al final  -> ["manzana","pera","uva"]
frutas.pop();                    // quita del final -> ["manzana","pera"]
frutas.unshift("kiwi");          // añade al inicio -> ["kiwi","manzana","pera"]
frutas.shift();                  // quita del inicio-> ["manzana","pera"]
```

### Métodos funcionales

No mutan el array original, devuelven uno nuevo:

- `map(fn)` — transforma cada elemento.
- `filter(fn)` — conserva los que cumplen la condición.
- `reduce(fn, inicial)` — reduce a un único valor.
- `find(fn)` — devuelve el primer elemento que cumple la condición.

```javascript
const numeros = [1, 2, 3, 4, 5];

const dobles = numeros.map((n) => n * 2);          // [2,4,6,8,10]
const pares = numeros.filter((n) => n % 2 === 0);  // [2,4]
const total = numeros.reduce((acc, n) => acc + n, 0); // 15
const primeroMayor = numeros.find((n) => n > 3);   // 4

console.log(dobles, pares, total, primeroMayor);
```

`reduce` también sirve para agrupar o construir objetos:

```javascript
const palabras = ["hola", "mundo", "hola"];
const conteo = palabras.reduce((acc, p) => {
  acc[p] = (acc[p] || 0) + 1;
  return acc;
}, {});
console.log(conteo); // { hola: 2, mundo: 1 }
```

### Objetos

Un objeto agrupa pares clave/valor. Acceso con punto (`obj.clave`) o corchetes (`obj["clave"]`, útil para claves dinámicas).

```javascript
const usuario = {
  nombre: "Ana",
  edad: 30,
  "email principal": "ana@mail.com",
};

console.log(usuario.nombre);        // "Ana"
console.log(usuario["edad"]);       // 30
console.log(usuario["email principal"]); // claves con espacios requieren corchetes

usuario.activo = true;              // añadir propiedad
delete usuario.edad;                // eliminar propiedad
```

### Destructuring

Extrae valores en variables con la misma forma que el dato.

```javascript
const persona = { nombre: "Luis", ciudad: "Lima" };
const { nombre, ciudad } = persona;
console.log(nombre, ciudad); // Luis Lima

const puntos = [10, 20, 30];
const [x, y, z] = puntos;
console.log(x, y, z); // 10 20 30

// con valor por defecto
const { pais = "Perú" } = persona;
console.log(pais); // Perú
```

### Spread y rest

- **Spread (`...`)** expande elementos (arrays/objetos).
- **Rest (`...`)** agrupa elementos sobrantes.

```javascript
const a = [1, 2];
const b = [...a, 3, 4];      // [1,2,3,4]
console.log(b);

const base = { x: 1, y: 2 };
const copia = { ...base, z: 3 }; // {x:1, y:2, z:3}
console.log(copia);

function sumarTodos(...nums) { // rest
  return nums.reduce((acc, n) => acc + n, 0);
}
console.log(sumarTodos(1, 2, 3, 4)); // 10
```

### JSON

Es el formato de intercambio de datos. En JS se usa `JSON.stringify` (objeto → texto) y `JSON.parse` (texto → objeto).

```javascript
const datos = { nombre: "Ana", edad: 30 };
const texto = JSON.stringify(datos);       // '{"nombre":"Ana","edad":30}'
console.log(texto);
console.log(typeof texto);                 // "string"

const deVuelta = JSON.parse(texto);        // objeto real
console.log(deVuelta.nombre);              // "Ana"
```

## Ejemplos de código

```javascript
// Procesar una lista de pedidos
const pedidos = [
  { id: 1, total: 50, pagado: true },
  { id: 2, total: 120, pagado: false },
  { id: 3, total: 30, pagado: true },
];

const pagados = pedidos.filter((p) => p.pagado);
const totales = pagados.map((p) => p.total);
const suma = totales.reduce((acc, t) => acc + t, 0);
console.log(`Suma de pagados: ${suma}`); // 80

const [primero, ...resto] = pedidos;
console.log(primero.id, resto.length); // 1 2
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **Mutar el array original por accidente** → `map`/`filter` devuelven nuevo; `sort`/`reverse` mutan.
- **Olvidar el valor inicial en `reduce`** → con arrays vacíos lanza `TypeError`.
- **Copiar arrays/objetos con `=`** → no copia, crea una referencia compartida; usa spread.
- **`JSON.parse` con texto inválido** → lanza `SyntaxError`; envuélvelo en try/catch.
- **Confundir `null` en `find`** → `find` devuelve `undefined` si no encuentra; comprueba antes de usar la propiedad.
- **Comparar objetos con `===`** → dos objetos con el mismo contenido son referencias distintas.

## Recursos

- [MDN — Array](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Array)
- [MDN — Array.prototype.reduce](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)
- [MDN — Destructuring](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
- [MDN — Spread syntax](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Operators/Spread_syntax)
- [MDN — JSON](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/JSON)
- [JavaScript.info — Arrays y objetos](https://es.javascript.info/object-basics)