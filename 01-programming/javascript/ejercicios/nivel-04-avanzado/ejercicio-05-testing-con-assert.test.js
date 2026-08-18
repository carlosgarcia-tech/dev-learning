const { test } = require("node:test");
const assert = require("node:assert/strict");
const { sumar, esPalindromo, dividir } = require("./ejercicio-05-testing-con-assert");

test("sumar suma números", () => {
  assert.equal(sumar(2, 3), 5);
  assert.equal(sumar(-1, 1), 0);
});

test("esPalindromo detecta palíndromos", () => {
  assert.equal(esPalindromo("reconocer"), true);
  assert.equal(esPalindromo("Hola"), false);
});

test("esPalindromo ignora mayúsculas/minúsculas", () => {
  assert.equal(esPalindromo("Ana"), true);
});

test("dividir devuelve la división válida", () => {
  assert.equal(dividir(10, 2), 5);
});

test("dividir lanza Error al dividir entre cero", () => {
  assert.throws(() => dividir(1, 0), /cero/);
});
