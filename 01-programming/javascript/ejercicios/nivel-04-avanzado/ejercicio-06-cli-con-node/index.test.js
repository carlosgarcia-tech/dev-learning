const { test } = require("node:test");
const assert = require("node:assert/strict");
const { sumar, restar, factorial, procesarComando } = require("./index");

test("sumar y restar operan sobre números", () => {
  assert.equal(sumar(4, 5), 9);
  assert.equal(restar(10, 4), 6);
});

test("factorial recursivo", () => {
  assert.equal(factorial(5), 120);
  assert.equal(factorial(1), 1);
  assert.equal(factorial(0), 1);
});

test("procesarComando sin argumentos devuelve el uso", () => {
  assert.equal(procesarComando([]), "Uso: node cli.js <comando> <numero>");
});

test("procesarComando ejecuta suma, resta y factorial", () => {
  assert.equal(procesarComando(["suma", "4", "5"]), "9");
  assert.equal(procesarComando(["resta", "10", "4"]), "6");
  assert.equal(procesarComando(["factorial", "5"]), "120");
});

test("procesarComando valida argumentos numéricos", () => {
  assert.equal(procesarComando(["suma", "x", "5"]), "Argumento inválido");
  assert.equal(procesarComando(["factorial", "-3"]), "Argumento inválido");
});

test("procesarComando reporta comandos desconocidos", () => {
  assert.equal(procesarComando(["foo", "1"]), "Comando desconocido: foo");
});
