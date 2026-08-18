const { test } = require("node:test");
const assert = require("node:assert/strict");
const { saludar, esPar, sumarTodos, potencia } = require("./ejercicio-01-funciones");

test("saludar devuelve el saludo con el nombre", () => {
  assert.equal(saludar("Ana"), "Hola, Ana!");
});

test("esPar identifica pares e impares", () => {
  assert.equal(esPar(8), true);
  assert.equal(esPar(7), false);
  assert.equal(esPar(0), true);
});

test("sumarTodos usa rest y suma todos los argumentos", () => {
  assert.equal(sumarTodos(1, 2, 3, 4), 10);
  assert.equal(sumarTodos(), 0);
  assert.equal(sumarTodos(5), 5);
});

test("potencia usa el exponente por defecto 2", () => {
  assert.equal(potencia(3), 9);
  assert.equal(potencia(3, 4), 81);
});
