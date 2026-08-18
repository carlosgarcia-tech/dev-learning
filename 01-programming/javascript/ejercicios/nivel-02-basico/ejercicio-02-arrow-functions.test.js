const { test } = require("node:test");
const assert = require("node:assert/strict");
const { doble, cuadrado, describir, calcularCuadrados } = require("./ejercicio-02-arrow-functions");

test("doble y cuadrado con retorno implícito", () => {
  assert.equal(doble(6), 12);
  assert.equal(cuadrado(9), 81);
});

test("describir con cuerpo de bloque", () => {
  assert.equal(describir("Ana", 30), "Ana tiene 30 años");
});

test("calcularCuadrados usa map con arrow", () => {
  assert.deepEqual(calcularCuadrados([1, 2, 3, 4, 5]), [1, 4, 9, 16, 25]);
  assert.deepEqual(calcularCuadrados([]), []);
});
