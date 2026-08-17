const { test } = require("node:test");
const assert = require("node:assert/strict");
const { analizarFrase, concatenar } = require("./ejercicio-03-strings");

test("analizarFrase calcula los métodos de string pedidos", () => {
  const a = analizarFrase("  JavaScript es genial  ");
  assert.equal(a.longitud, 24);
  assert.equal(a.sinEspacios, "JavaScript es genial");
  assert.equal(a.mayusculas, "  JAVASCRIPT ES GENIAL  ");
  assert.equal(a.minusculas, "  javascript es genial  ");
  assert.equal(a.contieneGenial, true);
  assert.deepEqual(a.palabras, ["JavaScript", "es", "genial"]);
});

test("analizarFrase no muta la frase original", () => {
  const frase = "  Hola  ";
  const a = analizarFrase(frase);
  assert.equal(frase, "  Hola  ");
  assert.equal(a.sinEspacios, "Hola");
});

test("analizarFrase con string vacío", () => {
  const a = analizarFrase("");
  assert.equal(a.longitud, 0);
  assert.equal(a.sinEspacios, "");
  assert.equal(a.contieneGenial, false);
});

test("concatenar devuelve los dos formatos pedidos", () => {
  const c = concatenar("JavaScript es genial");
  assert.equal(c.concatenacion, "Me encanta: JavaScript es genial!");
  assert.equal(c.template, 'Aprendo "JavaScript es genial" hoy');
});
