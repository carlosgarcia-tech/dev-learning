const { test } = require("node:test");
const assert = require("node:assert/strict");
const { crearContador, crearMultiplicador } = require("./ejercicio-06-closures");

test("crearContador incrementa y obtiene el estado", () => {
  const contador = crearContador();
  assert.equal(contador.obtener(), 0);
  assert.equal(contador.incrementar(), 1);
  assert.equal(contador.incrementar(), 2);
});

test("crearContador decrementa el estado", () => {
  const contador = crearContador();
  contador.incrementar();
  assert.equal(contador.decrementar(), 0);
});

test("cada contador mantiene su propio estado privado", () => {
  const a = crearContador();
  const b = crearContador();
  a.incrementar();
  a.incrementar();
  b.incrementar();
  assert.equal(a.obtener(), 2);
  assert.equal(b.obtener(), 1);
});

test("crearMultiplicador fija el factor por closure", () => {
  const porDos = crearMultiplicador(2);
  const porTres = crearMultiplicador(3);
  assert.equal(porDos(5), 10);
  assert.equal(porTres(5), 15);
});
