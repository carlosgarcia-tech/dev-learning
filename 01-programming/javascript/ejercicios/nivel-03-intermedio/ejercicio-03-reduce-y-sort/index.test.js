const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  VENTAS,
  ingresosTotales,
  mayorIngreso,
  unidadesTotales,
  ordenarPorPrecioDesc,
  ordenarPorCantidadAsc,
} = require("./index");

test("VENTAS contiene 4 ventas", () => {
  assert.equal(VENTAS.length, 4);
});

test("ingresosTotales suma cantidad * precio", () => {
  assert.equal(ingresosTotales(VENTAS), 3450);
});

test("mayorIngreso devuelve el producto con más ingreso", () => {
  assert.equal(mayorIngreso(VENTAS).producto, "Laptop");
});

test("unidadesTotales suma las cantidades", () => {
  assert.equal(unidadesTotales(VENTAS), 20);
});

test("ordenarPorPrecioDesc ordena de mayor a menor", () => {
  const ordenado = ordenarPorPrecioDesc(VENTAS);
  assert.equal(ordenado[0].producto, "Laptop");
  assert.equal(ordenado[3].producto, "Mouse");
});

test("ordenarPorCantidadAsc ordena de menor a mayor", () => {
  const ordenado = ordenarPorCantidadAsc(VENTAS);
  assert.equal(ordenado[0].producto, "Monitor");
  assert.equal(ordenado[3].producto, "Mouse");
});

test("los sort no mutan el array original", () => {
  const copia = JSON.stringify(VENTAS);
  ordenarPorPrecioDesc(VENTAS);
  ordenarPorCantidadAsc(VENTAS);
  assert.equal(JSON.stringify(VENTAS), copia);
});
