const { test } = require("node:test");
const assert = require("node:assert/strict");
const { EventEmitter } = require("./ejercicio-04-event-emitter");

test("on y emit pasan los argumentos a los listeners", () => {
  const emisor = new EventEmitter();
  const recibidos = [];
  emisor.on("saludo", (nombre) => recibidos.push(`Hola, ${nombre}!`));
  emisor.emit("saludo", "Ana");
  emisor.emit("saludo", "Luis");
  assert.deepEqual(recibidos, ["Hola, Ana!", "Hola, Luis!"]);
});

test("once se ejecuta una sola vez", () => {
  const emisor = new EventEmitter();
  let veces = 0;
  emisor.once("saludo", () => veces++);
  emisor.emit("saludo");
  emisor.emit("saludo");
  emisor.emit("saludo");
  assert.equal(veces, 1);
});

test("off elimina exactamente el listener indicado", () => {
  const emisor = new EventEmitter();
  const recibidos = [];
  const fn1 = () => recibidos.push("fn1");
  const fn2 = () => recibidos.push("fn2");
  emisor.on("ev", fn1);
  emisor.on("ev", fn2);
  emisor.emit("ev");
  emisor.off("ev", fn1);
  emisor.emit("ev");
  assert.deepEqual(recibidos, ["fn1", "fn2", "fn2"]);
});

test("listeners devuelve el array de listeners", () => {
  const emisor = new EventEmitter();
  const fn = () => {};
  assert.deepEqual(emisor.listeners("saludo"), []);
  emisor.on("saludo", fn);
  assert.equal(emisor.listeners("saludo").length, 1);
});

test("off también elimina un listener registrado con once", () => {
  const emisor = new EventEmitter();
  let veces = 0;
  const fn = () => veces++;
  emisor.once("ev", fn);
  emisor.off("ev", fn);
  emisor.emit("ev");
  assert.equal(veces, 0);
});
