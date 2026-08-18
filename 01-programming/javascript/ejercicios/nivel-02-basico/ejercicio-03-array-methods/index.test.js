const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  PRODUCTOS,
  obtenerNombres,
  conIVA,
  conStock,
  primeroBarato,
} = require("./index");

test("PRODUCTOS contiene 4 productos", () => {
  assert.equal(PRODUCTOS.length, 4);
  assert.equal(PRODUCTOS[0].nombre, "Camisa");
});

test("obtenerNombres usa map para extraer los nombres", () => {
  assert.deepEqual(obtenerNombres(PRODUCTOS), ["Camisa", "Pantalón", "Zapatos", "Sombrero"]);
});

test("conIVA añade el 18% redondeado a 2 decimales", () => {
  const con = conIVA(PRODUCTOS);
  assert.equal(con.length, 4);
  assert.equal(con[0].nombre, "Camisa");
  assert.equal(con[0].precio, 23.6);
  assert.equal(con[2].precio, 59);
});

test("conStock filtra los que tienen stock", () => {
  const con = conStock(PRODUCTOS);
  assert.deepEqual(con.map((p) => p.nombre), ["Camisa", "Zapatos", "Sombrero"]);
});

test("primeroBarato encuentra el primer producto con precio < 25", () => {
  assert.equal(primeroBarato(PRODUCTOS).nombre, "Camisa");
});

test("los métodos no mutan el array original", () => {
  const copia = JSON.stringify(PRODUCTOS);
  obtenerNombres(PRODUCTOS);
  conIVA(PRODUCTOS);
  conStock(PRODUCTOS);
  primeroBarato(PRODUCTOS);
  assert.equal(JSON.stringify(PRODUCTOS), copia);
});
