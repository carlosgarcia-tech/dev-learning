const VENTAS = [
  // TODO: define el array de ventas del enunciado.
];

function ingresosTotales(ventas) {
  // TODO: reduce -> suma de cantidad * precio.
  throw new Error("TODO: implementar ingresosTotales(ventas)");
}

function mayorIngreso(ventas) {
  // TODO: reduce -> devuelve el producto con mayor cantidad * precio.
  throw new Error("TODO: implementar mayorIngreso(ventas)");
}

function unidadesTotales(ventas) {
  // TODO: reduce -> suma de cantidades.
  throw new Error("TODO: implementar unidadesTotales(ventas)");
}

function ordenarPorPrecioDesc(ventas) {
  // TODO: devuelve copia ordenada por precio desc (no mutar el original).
  throw new Error("TODO: implementar ordenarPorPrecioDesc(ventas)");
}

function ordenarPorCantidadAsc(ventas) {
  // TODO: devuelve copia ordenada por cantidad asc (no mutar el original).
  throw new Error("TODO: implementar ordenarPorCantidadAsc(ventas)");
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
