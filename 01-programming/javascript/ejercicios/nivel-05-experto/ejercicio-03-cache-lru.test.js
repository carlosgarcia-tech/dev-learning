const { test } = require("node:test");
const assert = require("node:assert/strict");
const { CachéLRU } = require("./ejercicio-03-cache-lru");

test("obtener devuelve el valor y lo marca como reciente", () => {
  const cache = new CachéLRU(2);
  cache.poner("a", 1);
  assert.equal(cache.obtener("a"), 1);
});

test("obtener devuelve null si la clave no existe", () => {
  const cache = new CachéLRU(2);
  assert.equal(cache.obtener("x"), null);
});

test("poner expulsa el menos recientemente usado al llenarse", () => {
  const cache = new CachéLRU(2);
  cache.poner("a", 1);
  cache.poner("b", 2);
  cache.obtener("a");
  cache.poner("c", 3);
  assert.equal(cache.obtener("a"), 1);
  assert.equal(cache.obtener("b"), null);
  assert.equal(cache.obtener("c"), 3);
});

test("poner sobre una clave existente no duplica entradas", () => {
  const cache = new CachéLRU(2);
  cache.poner("a", 1);
  cache.poner("a", 99);
  assert.equal(cache.tamaño(), 1);
  assert.equal(cache.obtener("a"), 99);
});

test("tamaño refleja el número de elementos", () => {
  const cache = new CachéLRU(2);
  assert.equal(cache.tamaño(), 0);
  cache.poner("a", 1);
  cache.poner("b", 2);
  assert.equal(cache.tamaño(), 2);
});
