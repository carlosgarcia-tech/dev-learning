# Ejercicio 03 — Array methods

- **Nivel:** 2/5
- **Tema:** map, filter, find
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `array-methods.js` que trabaje con la lista:

```javascript
const productos = [
  { nombre: "Camisa", precio: 20, stock: 5 },
  { nombre: "Pantalón", precio: 35, stock: 0 },
  { nombre: "Zapatos", precio: 50, stock: 8 },
  { nombre: "Sombrero", precio: 15, stock: 2 },
];
```

1. Con `map`, cree un array `nombres` con solo los nombres.
2. Con `map`, cree un array `conIVA` añadiendo a cada producto el precio con IVA del 18% (redondeado a 2 decimales).
3. Con `filter`, obtenga los productos con `stock > 0`.
4. Con `find`, obtenga el primer producto que cueste menos de 25.
5. Imprima todo.

Salida esperada:

```
Nombres: [ 'Camisa', 'Pantalón', 'Zapatos', 'Sombrero' ]
Con IVA: [ { nombre: 'Camisa', precio: 23.6 }, ... ]
Con stock: [Camisa, Zapatos, Sombrero]
Primero < 25: Camisa
```

## Requisitos

- [ ] Usar `map` dos veces (nombres y precios con IVA).
- [ ] Usar `filter` con una condición de stock.
- [ ] Usar `find` para localizar un producto.
- [ ] No modificar el array original con los métodos.
- [ ] Ejecutarlo localmente con `node array-methods.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-03-array-methods.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para redondear a 2 decimales: `Math.round(valor * 100) / 100`.
- `map` recibe el elemento (y opcionalmente índice y array).
- `find` devuelve el primer elemento que cumple o `undefined`.
- Estos métodos **no mutan** el array original.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const PRODUCTOS = [
  { nombre: "Camisa", precio: 20, stock: 5 },
  { nombre: "Pantalón", precio: 35, stock: 0 },
  { nombre: "Zapatos", precio: 50, stock: 8 },
  { nombre: "Sombrero", precio: 15, stock: 2 },
];

function obtenerNombres(productos) {
  return productos.map((p) => p.nombre);
}

function conIVA(productos) {
  return productos.map((p) => ({
    nombre: p.nombre,
    precio: Math.round(p.precio * 1.18 * 100) / 100,
  }));
}

function conStock(productos) {
  return productos.filter((p) => p.stock > 0);
}

function primeroBarato(productos) {
  return productos.find((p) => p.precio < 25);
}

if (require.main === module) {
  console.log(`Nombres: ${obtenerNombres(PRODUCTOS)}`);
  console.log("Con IVA:", conIVA(PRODUCTOS));
  console.log(`Con stock: ${conStock(PRODUCTOS).map((p) => p.nombre).join(", ")}`);
  console.log(`Primero < 25: ${primeroBarato(PRODUCTOS).nombre}`);
}

module.exports = { PRODUCTOS, obtenerNombres, conIVA, conStock, primeroBarato };
````

</details>