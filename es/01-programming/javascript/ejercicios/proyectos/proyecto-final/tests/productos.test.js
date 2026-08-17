const { test, before, after } = require("node:test");
const assert = require("node:assert/strict");
const { arrancarServidor, login, api, crearProducto } = require("./helpers");

let ctx;
let token;

before(async () => {
  ctx = await arrancarServidor();
  token = await login(ctx.base);
});

after(() => new Promise((resolve) => ctx.server.close(resolve)));

test("POST /api/productos crea un producto válido", async () => {
  const res = await api(ctx.base, token, "/api/productos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "Laptop", precio: 800, stock: 5 }),
  });
  assert.equal(res.status, 201);
  const creado = await res.json();
  assert.equal(creado.id, 1);
  assert.equal(creado.nombre, "Laptop");
  assert.equal(creado.precio, 800);
  assert.equal(creado.stock, 5);
});

test("POST sin nombre devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/productos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ precio: 10, stock: 1 }),
  });
  assert.equal(res.status, 400);
});

test("POST con precio negativo devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/productos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "X", precio: -1, stock: 1 }),
  });
  assert.equal(res.status, 400);
});

test("POST con stock no entero devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/productos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "X", precio: 10, stock: 1.5 }),
  });
  assert.equal(res.status, 400);
});

test("POST con JSON inválido devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/productos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "no-json",
  });
  assert.equal(res.status, 400);
});

test("GET /api/productos lista con paginación", async () => {
  const res = await api(ctx.base, token, "/api/productos");
  assert.equal(res.status, 200);
  const cuerpo = await res.json();
  assert.equal(cuerpo.total, 1);
  assert.equal(cuerpo.productos.length, 1);
  assert.ok(cuerpo.pagina && cuerpo.limite);
});

test("GET /api/productos/:id devuelve el producto", async () => {
  const res = await api(ctx.base, token, "/api/productos/1");
  assert.equal(res.status, 200);
  const dato = await res.json();
  assert.equal(dato.nombre, "Laptop");
});

test("GET /api/productos/999 devuelve 404", async () => {
  const res = await api(ctx.base, token, "/api/productos/999");
  assert.equal(res.status, 404);
});

test("PUT /api/productos/:id actualiza el producto", async () => {
  const res = await api(ctx.base, token, "/api/productos/1", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "Laptop Pro", precio: 900, stock: 3 }),
  });
  assert.equal(res.status, 200);
  const actualizado = await res.json();
  assert.equal(actualizado.nombre, "Laptop Pro");
  assert.equal(actualizado.precio, 900);
});

test("PUT con datos inválidos devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/productos/1", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "", precio: 900, stock: 3 }),
  });
  assert.equal(res.status, 400);
});

test("PUT sobre un producto inexistente devuelve 404", async () => {
  const res = await api(ctx.base, token, "/api/productos/999", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "N", precio: 1, stock: 1 }),
  });
  assert.equal(res.status, 404);
});

test("DELETE /api/productos/:id elimina y devuelve 204", async () => {
  await crearProducto(ctx.base, token, { nombre: "Mouse", precio: 20, stock: 10 });
  const res = await api(ctx.base, token, "/api/productos/2", { method: "DELETE" });
  assert.equal(res.status, 204);
  const resGet = await api(ctx.base, token, "/api/productos/2");
  assert.equal(resGet.status, 404);
});

test("DELETE de un producto inexistente devuelve 404", async () => {
  const res = await api(ctx.base, token, "/api/productos/999", { method: "DELETE" });
  assert.equal(res.status, 404);
});

test("búsqueda por ?buscar= filtra por nombre", async () => {
  const res = await api(ctx.base, token, "/api/productos?buscar=laptop");
  const cuerpo = await res.json();
  assert.ok(cuerpo.productos.every((p) => p.nombre.toLowerCase().includes("laptop")));
});

test("filtro por rango de precio", async () => {
  await crearProducto(ctx.base, token, { nombre: "Teclado", precio: 50, stock: 4 });
  await crearProducto(ctx.base, token, { nombre: "Monitor", precio: 300, stock: 2 });
  const res = await api(ctx.base, token, "/api/productos?minPrecio=40&maxPrecio=100");
  const cuerpo = await res.json();
  assert.ok(cuerpo.productos.every((p) => p.precio >= 40 && p.precio <= 100));
});

test("orden asc y desc por precio", async () => {
  const asc = await (await api(ctx.base, token, "/api/productos?orden=asc")).json();
  const desc = await (await api(ctx.base, token, "/api/productos?orden=desc")).json();
  const preciosAsc = asc.productos.map((p) => p.precio);
  const preciosDesc = desc.productos.map((p) => p.precio);
  assert.deepEqual(preciosAsc, [...preciosAsc].sort((a, b) => a - b));
  assert.deepEqual(preciosDesc, [...preciosDesc].sort((a, b) => b - a));
});

test("paginación devuelve solo la página pedida", async () => {
  const res = await api(ctx.base, token, "/api/productos?pagina=2&limite=2");
  const cuerpo = await res.json();
  assert.equal(cuerpo.total, 3);
  assert.equal(cuerpo.productos.length, 1);
});

test("método no permitido devuelve 405", async () => {
  const res = await api(ctx.base, token, "/api/productos/1", { method: "PATCH" });
  assert.equal(res.status, 405);
});
