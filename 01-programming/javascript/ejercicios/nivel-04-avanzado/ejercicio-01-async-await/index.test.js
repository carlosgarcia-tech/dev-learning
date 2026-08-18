const { test } = require("node:test");
const assert = require("node:assert/strict");
const { simularPeticion, obtenerDatos, obtenerTodo } = require("./index");

test("simularPeticion resuelve con el mensaje esperado", async () => {
  assert.equal(await simularPeticion(5), "Respuesta lista");
});

test("simularPeticion rechaza cuando fallar es true", async () => {
  await assert.rejects(simularPeticion(5, true), /Error de red/);
});

test("obtenerDatos devuelve el resultado cuando no falla", async () => {
  assert.equal(await obtenerDatos(false), "Respuesta lista");
});

test("obtenerDatos lanza cuando la petición falla", async () => {
  await assert.rejects(obtenerDatos(true), /Error de red/);
});

test("obtenerTodo usa Promise.all y devuelve 3 resultados", async () => {
  const todas = await obtenerTodo();
  assert.equal(todas.length, 3);
  assert.deepEqual(todas, ["Respuesta lista", "Respuesta lista", "Respuesta lista"]);
});
