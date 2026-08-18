const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  PERSONA,
  PUNTO,
  extraerPersona,
  extraerEdad,
  extraerPunto,
  combinarArrays,
  copiarPersona,
  unir,
} = require("./index");

test("extraerPersona usa destructuring de objeto", () => {
  assert.equal(extraerPersona(PERSONA), "nombre: Luis, ciudad: Quito");
});

test("extraerEdad usa destructuring con alias", () => {
  assert.equal(extraerEdad(PERSONA), 28);
});

test("extraerPunto usa destructuring de array con rest", () => {
  assert.equal(extraerPunto(PUNTO), "x: 10, y: 20, resto: [30]");
});

test("combinarArrays usa spread", () => {
  assert.deepEqual(combinarArrays([1, 2, 3], [4, 5, 6]), [1, 2, 3, 4, 5, 6]);
});

test("copiarPersona crea copia con activo: true", () => {
  const copia = copiarPersona(PERSONA);
  assert.deepEqual(copia, { nombre: "Luis", edad: 28, ciudad: "Quito", activo: true });
  assert.notEqual(copia, PERSONA);
});

test("unir usa rest y une con comas", () => {
  assert.equal(unir("a", "b", "c"), "a,b,c");
  assert.equal(unir(), "");
});
