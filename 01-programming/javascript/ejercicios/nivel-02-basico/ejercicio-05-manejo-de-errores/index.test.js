const { test } = require("node:test");
const assert = require("node:assert/strict");
const { raizCuadrada, parsearJSON } = require("./index");

test("raizCuadrada devuelve la raíz de números válidos", () => {
  assert.equal(raizCuadrada(9), 3);
  assert.equal(raizCuadrada(0), 0);
});

test("raizCuadrada lanza Error con número negativo", () => {
  assert.throws(() => raizCuadrada(-4), /negativo/);
});

test("parsearJSON devuelve el objeto parseado", () => {
  assert.deepEqual(parsearJSON('{"a": 1}'), { a: 1 });
});

test("parsearJSON lanza Error con JSON inválido", () => {
  assert.throws(() => parsearJSON("texto roto"), /JSON inválido/);
});
