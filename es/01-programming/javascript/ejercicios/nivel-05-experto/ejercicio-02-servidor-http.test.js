const { test, before, after } = require("node:test");
const assert = require("node:assert/strict");
const { crearServidor } = require("./ejercicio-02-servidor-http");

let server;
let base;

before(async () => {
  server = crearServidor();
  await new Promise((resolve) => server.listen(0, resolve));
  base = `http://localhost:${server.address().port}`;
});

after(() => new Promise((resolve) => server.close(resolve)));

test("GET / responde con la bienvenida", async () => {
  const res = await fetch(`${base}/`);
  assert.equal(res.status, 200);
  assert.equal(await res.text(), "Bienvenido al servidor de Node.js");
});

test("GET /hora devuelve una fecha ISO válida", async () => {
  const res = await fetch(`${base}/hora`);
  assert.equal(res.status, 200);
  const cuerpo = await res.text();
  assert.ok(!Number.isNaN(Date.parse(cuerpo)));
});

test("GET /saludo?nombre=Ana saluda a Ana", async () => {
  const res = await fetch(`${base}/saludo?nombre=Ana`);
  assert.equal(res.status, 200);
  assert.equal(await res.text(), "Hola, Ana!");
});

test("GET /saludo sin nombre usa 'mundo'", async () => {
  const res = await fetch(`${base}/saludo`);
  assert.equal(await res.text(), "Hola, mundo!");
});

test("GET /productos devuelve el JSON de productos", async () => {
  const res = await fetch(`${base}/productos`);
  assert.equal(res.status, 200);
  const datos = await res.json();
  assert.equal(datos.length, 2);
  assert.equal(datos[0].nombre, "Laptop");
});

test("ruta desconocida devuelve 404", async () => {
  const res = await fetch(`${base}/otra`);
  assert.equal(res.status, 404);
  assert.equal(await res.text(), "No encontrado");
});
