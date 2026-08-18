const { test, before, after } = require("node:test");
const assert = require("node:assert/strict");
const { crearServidor } = require("./index");

let server;
let base;

before(async () => {
  server = crearServidor();
  await new Promise((resolve) => server.listen(0, resolve));
  base = `http://localhost:${server.address().port}`;
});

after(() => new Promise((resolve) => server.close(resolve)));

test("GET /productos devuelve 200 con [] al inicio", async () => {
  const res = await fetch(`${base}/productos`);
  assert.equal(res.status, 200);
  assert.deepEqual(await res.json(), []);
});

test("POST /productos crea y devuelve 201 con el objeto", async () => {
  const res = await fetch(`${base}/productos`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "Tablet", precio: 300 }),
  });
  assert.equal(res.status, 201);
  const creado = await res.json();
  assert.equal(creado.id, 1);
  assert.equal(creado.nombre, "Tablet");
  assert.equal(creado.precio, 300);
});

test("GET /productos devuelve la lista tras crear", async () => {
  const res = await fetch(`${base}/productos`);
  assert.equal(res.status, 200);
  const lista = await res.json();
  assert.equal(lista.length, 1);
  assert.equal(lista[0].id, 1);
});

test("GET /productos/1 devuelve el producto", async () => {
  const res = await fetch(`${base}/productos/1`);
  assert.equal(res.status, 200);
  const dato = await res.json();
  assert.equal(dato.nombre, "Tablet");
});

test("GET /productos/99 devuelve 404", async () => {
  const res = await fetch(`${base}/productos/99`);
  assert.equal(res.status, 404);
  const dato = await res.json();
  assert.equal(dato.error, "No encontrado");
});

test("POST con datos incompletos devuelve 400", async () => {
  const res = await fetch(`${base}/productos`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "Solo nombre" }),
  });
  assert.equal(res.status, 400);
  const dato = await res.json();
  assert.equal(dato.error, "Datos inválidos");
});

test("POST con JSON inválido devuelve 400", async () => {
  const res = await fetch(`${base}/productos`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "{no es json",
  });
  assert.equal(res.status, 400);
});

test("ruta desconocida devuelve 404", async () => {
  const res = await fetch(`${base}/otra`);
  assert.equal(res.status, 404);
});

test("método no permitido devuelve 405", async () => {
  const res = await fetch(`${base}/productos`, { method: "PUT" });
  assert.equal(res.status, 405);
});
