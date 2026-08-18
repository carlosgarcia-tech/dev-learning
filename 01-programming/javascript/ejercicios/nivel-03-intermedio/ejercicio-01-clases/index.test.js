const { test } = require("node:test");
const assert = require("node:assert/strict");
const { Animal, Perro } = require("./index");

test("Animal construye e imita su sonido", () => {
  const animal = new Animal("Gato", "miau");
  assert.equal(animal.hablar(), "Gato hace miau");
});

test("el getter descripcion funciona", () => {
  const animal = new Animal("Rex", "guau");
  assert.equal(animal.descripcion, "Animal llamado Rex");
});

test("el setter nombre valida valores vacíos", () => {
  const animal = new Animal("Rex", "guau");
  assert.throws(() => (animal.nombre = ""), /no puede estar vacío/);
  assert.throws(() => (animal.nombre = "   "), /no puede estar vacío/);
});

test("Perro extiende Animal y guarda la raza", () => {
  const rex = new Perro("Rex", "Labrador");
  assert.equal(rex.raza, "Labrador");
  assert.equal(rex.descripcion, "Animal llamado Rex");
});

test("Perro.hablar usa super para llamar al método del padre", () => {
  const rex = new Perro("Rex", "Labrador");
  assert.equal(rex.hablar(), "Rex ladra: Rex hace ¡Guau!");
});
