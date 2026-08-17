const { test, before, after } = require("node:test");
const assert = require("node:assert/strict");
const { arrancarServidor, login, api, crearProducto } = require("./helpers");

let ctx;
let token;

before(async () => {
  ctx = await arrancarServidor();
  token = await login(ctx.base);
  await crearProducto(ctx.base, token, { nombre: "Laptop", precio: 100, stock: 10 });
  await crearProducto(ctx.base, token, { nombre: "Mouse", precio: 50, stock: 5 });
});

after(() => new Promise((resolve) => ctx.server.close(resolve)));

test("POST /api/pedidos crea un pedido y calcula el total", async () => {
  const res = await api(ctx.base, token, "/api/pedidos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      cliente: "Ana",
      productos: [
        { id: 1, cantidad: 2 },
        { id: 2, cantidad: 1 },
      ],
    }),
  });
  assert.equal(res.status, 201);
  const pedido = await res.json();
  assert.equal(pedido.cliente, "Ana");
  assert.equal(pedido.total, 250);
  assert.equal(pedido.estado, "recibido");
  assert.equal(pedido.lineas.length, 2);
});

test("crear un pedido descuenta el stock", async () => {
  const res = await api(ctx.base, token, "/api/productos/1");
  const producto = await res.json();
  assert.equal(producto.stock, 8);
});

test("POST con stock insuficiente devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/pedidos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      cliente: "Luis",
      productos: [{ id: 2, cantidad: 99 }],
    }),
  });
  assert.equal(res.status, 400);
  const cuerpo = await res.json();
  assert.ok(cuerpo.error.includes("Stock insuficiente"));
});

test("POST con producto inexistente devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/pedidos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      cliente: "Luis",
      productos: [{ id: 999, cantidad: 1 }],
    }),
  });
  assert.equal(res.status, 400);
});

test("POST sin líneas devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/pedidos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ cliente: "Luis", productos: [] }),
  });
  assert.equal(res.status, 400);
});

test("POST con cantidad inválida devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/pedidos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      cliente: "Luis",
      productos: [{ id: 1, cantidad: -2 }],
    }),
  });
  assert.equal(res.status, 400);
});

test("POST sin cliente devuelve 400", async () => {
  const res = await api(ctx.base, token, "/api/pedidos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ productos: [{ id: 1, cantidad: 1 }] }),
  });
  assert.equal(res.status, 400);
});

test("GET /api/pedidos lista los pedidos", async () => {
  const res = await api(ctx.base, token, "/api/pedidos");
  assert.equal(res.status, 200);
  const cuerpo = await res.json();
  assert.equal(cuerpo.total, 1);
  assert.equal(cuerpo.pedidos.length, 1);
});

test("GET /api/pedidos/:id devuelve el pedido", async () => {
  const res = await api(ctx.base, token, "/api/pedidos/1");
  assert.equal(res.status, 200);
  const pedido = await res.json();
  assert.equal(pedido.cliente, "Ana");
});

test("GET /api/pedidos/999 devuelve 404", async () => {
  const res = await api(ctx.base, token, "/api/pedidos/999");
  assert.equal(res.status, 404);
});

test("filtro por estado", async () => {
  const res = await api(ctx.base, token, "/api/pedidos?estado=recibido");
  const cuerpo = await res.json();
  assert.ok(cuerpo.pedidos.every((p) => p.estado === "recibido"));
});
