const { test } = require("node:test");
const assert = require("node:assert/strict");
const { contadorModule, Configuracion, Evento } = require("./index");

test("contadorModule mantiene el estado privado", () => {
  assert.equal(contadorModule.obtener(), 0);
  assert.equal(contadorModule.incrementar(), 1);
  assert.equal(contadorModule.incrementar(), 2);
  assert.equal(contadorModule.obtener(), 2);
});

test("el estado del module no es accesible desde fuera", () => {
  assert.equal(contadorModule.cuenta, undefined);
});

test("Configuracion es un singleton", () => {
  const conf1 = new Configuracion();
  const conf2 = new Configuracion();
  assert.equal(conf1 === conf2, true);
});

test("Evento suscribe, emite y desuscribe", () => {
  const evento = new Evento();
  const recibidos = [];
  const fn1 = (m) => recibidos.push(`1:${m}`);
  const fn2 = (m) => recibidos.push(`2:${m}`);
  evento.suscribir(fn1);
  evento.suscribir(fn2);
  evento.emitir("hola");
  assert.deepEqual(recibidos, ["1:hola", "2:hola"]);
  evento.desuscribir(fn2);
  evento.emitir("adiós");
  assert.deepEqual(recibidos, ["1:hola", "2:hola", "1:adiós"]);
});
