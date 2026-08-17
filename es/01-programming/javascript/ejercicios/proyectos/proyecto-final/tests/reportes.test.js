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

test("reporte de inventario con datos vacíos devuelve ceros", async () => {
  const res = await api(ctx.base, token, "/api/reportes/inventario");
  assert.equal(res.status, 200);
  const reporte = await res.json();
  assert.equal(reporte.totalProductos, 0);
  assert.equal(reporte.unidadesTotales, 0);
  assert.equal(reporte.valorInventario, 0);
});

test("reporte de inventario refleja los productos", async () => {
  await crearProducto(ctx.base, token, { nombre: "Laptop", precio: 100, stock: 3 });
  await crearProducto(ctx.base, token, { nombre: "Mouse", precio: 50, stock: 0 });
  const res = await api(ctx.base, token, "/api/reportes/inventario");
  const reporte = await res.json();
  assert.equal(reporte.totalProductos, 2);
  assert.equal(reporte.unidadesTotales, 3);
  assert.equal(reporte.valorInventario, 300);
  assert.equal(reporte.productosSinStock, 1);
});

test("reporte de ventas sin pedidos devuelve ceros", async () => {
  const res = await api(ctx.base, token, "/api/reportes/ventas");
  const reporte = await res.json();
  assert.equal(reporte.totalPedidos, 0);
  assert.equal(reporte.ingresosTotales, 0);
});

test("reporte de ventas acumula los pedidos", async () => {
  await api(ctx.base, token, "/api/pedidos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      cliente: "Ana",
      productos: [{ id: 1, cantidad: 2 }],
    }),
  });
  const res = await api(ctx.base, token, "/api/reportes/ventas");
  const reporte = await res.json();
  assert.equal(reporte.totalPedidos, 1);
  assert.equal(reporte.ingresosTotales, 200);
  assert.deepEqual(reporte.pedidosPorEstado, { recibido: 1 });
});

test("reporte inexistente devuelve 404", async () => {
  const res = await api(ctx.base, token, "/api/reportes/inexistente");
  assert.equal(res.status, 404);
});
