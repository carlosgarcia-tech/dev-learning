const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  operaciones,
  comparaciones,
  clasificarProducto,
  parOImpar,
} = require("./ejercicio-02-operadores-y-condicionales");

test("operaciones calcula los 6 operadores aritméticos", () => {
  const op = operaciones(10, 3);
  assert.equal(op.suma, 13);
  assert.equal(op.resta, 7);
  assert.equal(op.multiplicacion, 30);
  assert.equal(op.division, 10 / 3);
  assert.equal(op.modulo, 1);
  assert.equal(op.potencia, 1000);
});

test("comparaciones devuelve las 5 comparaciones en orden", () => {
  assert.deepEqual(comparaciones(10, 3), [true, false, true, false, true]);
});

test("comparaciones con valores iguales", () => {
  assert.deepEqual(comparaciones(5, 5), [false, false, true, true, false]);
});

test("clasificarProducto cubre los 3 rangos", () => {
  assert.ok(clasificarProducto(10, 3).includes("está entre 10 y 50"));
  assert.ok(clasificarProducto(9, 9).includes("es mayor a 50"));
  assert.ok(clasificarProducto(2, 2).includes("es menor a 10"));
});

test("parOImpar distingue par e impar", () => {
  assert.equal(parOImpar(10), "par");
  assert.equal(parOImpar(7), "impar");
  assert.equal(parOImpar(0), "par");
});
