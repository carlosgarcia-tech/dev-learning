# Ejercicio 02 — Operadores y condicionales

- **Nivel:** 1/5
- **Tema:** Aritmética, comparación, if/else/ternario
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `operadores.js` que:

1. Tenga dos números (p. ej. `a = 10` y `b = 3`) y calcule con `console.log` la suma, resta, multiplicación, división, módulo y potencia.
2. Compare `a` y `b` con `>`, `<`, `>=`, `===` y `!==`, imprimiendo `true` o `false`.
3. Con `if/else if/else`, imprima si el producto de `a * b` es mayor a 50, entre 10 y 50, o menor a 10.
4. Con un **ternario**, imprima si `a` es par o impar.

Salida esperada (ejemplo con `a = 10`, `b = 3`):

```
Suma: 13
Resta: 7
Multiplicacion: 30
Division: 3.3333333333333335
Modulo: 1
Potencia: 1000
10 > 3: true
10 < 3: false
10 >= 3: true
10 === 3: false
10 !== 3: true
El producto 30 está entre 10 y 50
10 es par
```

## Requisitos

- [ ] Imprimir los 6 operadores aritméticos.
- [ ] Imprimir 5 comparaciones con su resultado.
- [ ] Usar `if/else if/else` para clasificar el producto.
- [ ] Usar un operador ternario para par/impar.
- [ ] Ejecutarlo localmente con `node operadores.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-02-operadores-y-condicionales.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El operador de módulo es `%` y el de potencia es `**`.
- Para saber si un número es par: `n % 2 === 0`.
- En el ternario: `condicion ? "sí" : "no"`.
- Usa `===` para comparar sin coerción.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function operaciones(a, b) {
  return {
    suma: a + b,
    resta: a - b,
    multiplicacion: a * b,
    division: a / b,
    modulo: a % b,
    potencia: a ** b,
  };
}

function comparaciones(a, b) {
  return [a > b, a < b, a >= b, a === b, a !== b];
}

function clasificarProducto(a, b) {
  const producto = a * b;
  if (producto > 50) {
    return `El producto ${producto} es mayor a 50`;
  } else if (producto >= 10) {
    return `El producto ${producto} está entre 10 y 50`;
  } else {
    return `El producto ${producto} es menor a 10`;
  }
}

function parOImpar(n) {
  return n % 2 === 0 ? "par" : "impar";
}

if (require.main === module) {
  const a = 10;
  const b = 3;
  const op = operaciones(a, b);
  console.log(`Suma: ${op.suma}`);
  console.log(`Resta: ${op.resta}`);
  console.log(`Multiplicacion: ${op.multiplicacion}`);
  console.log(`Division: ${op.division}`);
  console.log(`Modulo: ${op.modulo}`);
  console.log(`Potencia: ${op.potencia}`);
  const [mayor, menor, mayorIgual, estrictamenteIgual, distinto] = comparaciones(a, b);
  console.log(`${a} > ${b}: ${mayor}`);
  console.log(`${a} < ${b}: ${menor}`);
  console.log(`${a} >= ${b}: ${mayorIgual}`);
  console.log(`${a} === ${b}: ${estrictamenteIgual}`);
  console.log(`${a} !== ${b}: ${distinto}`);
  console.log(clasificarProducto(a, b));
  console.log(`${a} es ${parOImpar(a)}`);
}

module.exports = { operaciones, comparaciones, clasificarProducto, parOImpar };
````

</details>