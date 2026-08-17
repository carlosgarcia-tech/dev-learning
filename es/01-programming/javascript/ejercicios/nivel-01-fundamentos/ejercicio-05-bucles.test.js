const { test } = require("node:test");
const assert = require("node:assert/strict");
const { numerosFor, cuentaRegresiva, recorrer, suma1aN } = require("./ejercicio-05-bucles");

test("numerosFor recorre del 1 al 5 con for", () => {
  assert.deepEqual(numerosFor(), [1, 2, 3, 4, 5]);
});

test("cuentaRegresiva recorre del 5 al 1 con while", () => {
  assert.deepEqual(cuentaRegresiva(), [5, 4, 3, 2, 1]);
});

test("recorrer une las frutas con comas", () => {
  assert.equal(recorrer(["manzana", "pera", "uva"]), "manzana, pera, uva");
  assert.equal(recorrer([]), "");
});

test("suma1aN suma correctamente (100 -> 5050)", () => {
  assert.equal(suma1aN(100), 5050);
});

test("suma1aN en casos borde", () => {
  assert.equal(suma1aN(1), 1);
  assert.equal(suma1aN(0), 0);
});
