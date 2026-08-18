const { test } = require("node:test");
const assert = require("node:assert/strict");
const { crearPelicula, enriquecer } = require("./index");

test("crearPelicula devuelve un objeto con 4 propiedades", () => {
  const pelicula = crearPelicula();
  assert.equal(typeof pelicula, "object");
  assert.ok(pelicula.titulo);
  assert.equal(typeof pelicula.anio, "number");
  assert.ok(pelicula.director);
  assert.equal(typeof pelicula.duracionMin, "number");
});

test("acceso por notación de punto y de corchetes", () => {
  const pelicula = crearPelicula();
  assert.equal(pelicula.titulo, pelicula["titulo"]);
  assert.equal(pelicula["anio"], pelicula.anio);
});

test("enriquecer modifica duración y añade genero y premios", () => {
  const pelicula = crearPelicula();
  const modificada = enriquecer(pelicula);
  assert.equal(modificada.duracionMin, 195);
  assert.equal(modificada.genero, "Drama");
  assert.deepEqual(modificada.premios, ["Oscar", "Globo de Oro"]);
});

test("el array de premios tiene 2 elementos", () => {
  const pelicula = enriquecer(crearPelicula());
  assert.equal(pelicula.premios.length, 2);
});
