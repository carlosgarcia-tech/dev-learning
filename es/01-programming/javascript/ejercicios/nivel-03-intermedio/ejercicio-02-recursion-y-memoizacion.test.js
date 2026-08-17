const { test } = require("node:test");
const assert = require("node:assert/strict");
const { factorial, fibonacci, fibMemo } = require("./ejercicio-02-recursion-y-memoizacion");

test("factorial recursivo", () => {
  assert.equal(factorial(5), 120);
  assert.equal(factorial(0), 1);
  assert.equal(factorial(1), 1);
});

test("fibonacci recursivo con casos base", () => {
  assert.equal(fibonacci(0), 0);
  assert.equal(fibonacci(1), 1);
  assert.equal(fibonacci(10), 55);
});

test("fibMemo devuelve los mismos resultados", () => {
  assert.equal(fibMemo(0), 0);
  assert.equal(fibMemo(1), 1);
  assert.equal(fibMemo(10), 55);
});

test("fibMemo es rápido para n grandes", () => {
  assert.equal(fibMemo(40), 102334155);
});
