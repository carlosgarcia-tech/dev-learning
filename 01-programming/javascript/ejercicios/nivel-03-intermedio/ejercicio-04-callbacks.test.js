const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  operacion,
  suma,
  resta,
  multiplica,
  procesarLista,
  leerDato,
} = require("./ejercicio-04-callbacks");

test("operacion llama al callback con los dos números", () => {
  assert.equal(operacion(5, 3, suma), 8);
  assert.equal(operacion(5, 3, resta), 2);
  assert.equal(operacion(5, 3, multiplica), 15);
});

test("procesarLista usa el callback dentro de map", () => {
  assert.deepEqual(procesarLista([1, 2, 3, 4, 5], (n) => n * 2), [2, 4, 6, 8, 10]);
  assert.deepEqual(procesarLista([1, 2, 3], (n) => n + 10), [11, 12, 13]);
});

test("leerDato llama al callback de forma asíncrona", async () => {
  const dato = await new Promise((resolve) => leerDato(resolve));
  assert.equal(dato, "dato leído");
});
