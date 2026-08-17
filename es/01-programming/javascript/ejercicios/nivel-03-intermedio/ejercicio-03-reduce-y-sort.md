# Ejercicio 03 — Reduce y sort

- **Nivel:** 3/5
- **Tema:** reduce, sort, comparadores
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `reduce-sort.js` que trabaje con:

```javascript
const ventas = [
  { producto: "Laptop", cantidad: 3, precio: 800 },
  { producto: "Mouse", cantidad: 10, precio: 20 },
  { producto: "Monitor", cantidad: 2, precio: 300 },
  { producto: "Teclado", cantidad: 5, precio: 50 },
];
```

1. Con `reduce`, calcule el **total de ingresos** (`cantidad * precio`) de todas las ventas.
2. Con `reduce`, construya un objeto que agrupe ventas por el **producto con mayor ingreso**... más simple: con `reduce` devuelva el producto con mayor ingreso individual.
3. Con `reduce`, cuente el total de unidades vendidas.
4. Con `sort`, ordene las ventas por `precio` de mayor a menor y por cantidad de menor a mayor.
5. Imprima los resultados. Cuidado: `sort` muta; haz copias con `[...ventas]` antes de ordenar.

Salida esperada:

```
Ingresos totales: 3450
Producto con mayor ingreso: Laptop (2400)
Unidades totales: 20
Mayor precio: Laptop (800)
Menor cantidad: Monitor (2)
```

## Requisitos

- [ ] Usar `reduce` para sumar, para encontrar el máximo y para contar.
- [ ] Usar `sort` con comparadores (ascendente y descendente).
- [ ] Ordenar copias con `[...ventas]` sin mutar el original.
- [ ] Ejecutarlo localmente con `node reduce-sort.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-03-reduce-y-sort.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Reduce con acumulador numérico: `(acc, v) => acc + v.cantidad * v.precio, 0`.
- Reducir al máximo: comparar el ingreso del elemento actual con el del acumulado.
- `sort((a, b) => a.precio - b.precio)` ordena ascendente; `b.precio - a.precio` descendente.
- `sort` muta el array; usa `[...ventas].sort(...)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const VENTAS = [
  { producto: "Laptop", cantidad: 3, precio: 800 },
  { producto: "Mouse", cantidad: 10, precio: 20 },
  { producto: "Monitor", cantidad: 2, precio: 300 },
  { producto: "Teclado", cantidad: 5, precio: 50 },
];

function ingresosTotales(ventas) {
  return ventas.reduce((acc, v) => acc + v.cantidad * v.precio, 0);
}

function mayorIngreso(ventas) {
  return ventas.reduce((mejor, v) =>
    v.cantidad * v.precio > mejor.cantidad * mejor.precio ? v : mejor
  );
}

function unidadesTotales(ventas) {
  return ventas.reduce((acc, v) => acc + v.cantidad, 0);
}

function ordenarPorPrecioDesc(ventas) {
  return [...ventas].sort((a, b) => b.precio - a.precio);
}

function ordenarPorCantidadAsc(ventas) {
  return [...ventas].sort((a, b) => a.cantidad - b.cantidad);
}

if (require.main === module) {
  console.log(`Ingresos totales: ${ingresosTotales(VENTAS)}`);
  const mayor = mayorIngreso(VENTAS);
  console.log(`Producto con mayor ingreso: ${mayor.producto} (${mayor.cantidad * mayor.precio})`);
  console.log(`Unidades totales: ${unidadesTotales(VENTAS)}`);
  const porPrecio = ordenarPorPrecioDesc(VENTAS);
  console.log(`Mayor precio: ${porPrecio[0].producto} (${porPrecio[0].precio})`);
  const porCantidad = ordenarPorCantidadAsc(VENTAS);
  console.log(`Menor cantidad: ${porCantidad[0].producto} (${porCantidad[0].cantidad})`);
}

module.exports = {
  VENTAS,
  ingresosTotales,
  mayorIngreso,
  unidadesTotales,
  ordenarPorPrecioDesc,
  ordenarPorCantidadAsc,
};
````

</details>