const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  primerElemento,
  ultimoElemento,
  agregarAlFinal,
  quitarDelFinal,
  agregarAlInicio,
  quitarDelInicio,
} = require("./index");

test("primerElemento y ultimoElemento acceden por índice", () => {
  const arr = ["estudiar", "cocinar", "dormir"];
  assert.equal(primerElemento(arr), "estudiar");
  assert.equal(ultimoElemento(arr), "dormir");
});

test("agregarAlFinal usa push y devuelve el array completo", () => {
  const arr = ["a", "b"];
  assert.deepEqual(agregarAlFinal(arr, "c"), ["a", "b", "c"]);
  assert.equal(arr.length, 3);
});

test("quitarDelFinal usa pop y devuelve el elemento y el array", () => {
  const arr = ["a", "b", "c"];
  const r = quitarDelFinal(arr);
  assert.equal(r.quitado, "c");
  assert.deepEqual(r.array, ["a", "b"]);
});

test("agregarAlInicio usa unshift", () => {
  const arr = ["b", "c"];
  assert.deepEqual(agregarAlInicio(arr, "a"), ["a", "b", "c"]);
});

test("quitarDelInicio usa shift y devuelve el elemento y el array", () => {
  const arr = ["a", "b"];
  const r = quitarDelInicio(arr);
  assert.equal(r.quitado, "a");
  assert.deepEqual(r.array, ["b"]);
});

test("quitar sobre un array vacío devuelve undefined sin romper", () => {
  const r = quitarDelFinal([]);
  assert.equal(r.quitado, undefined);
  assert.deepEqual(r.array, []);
});
