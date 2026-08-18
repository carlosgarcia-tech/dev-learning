const { test, before, after } = require("node:test");
const assert = require("node:assert/strict");
const { arrancarServidor, api } = require("./helpers");
const { generarToken } = require("../starter/auth");

let ctx;

before(async () => {
  ctx = await arrancarServidor();
});

after(() => new Promise((resolve) => ctx.server.close(resolve)));

test("login con credenciales válidas devuelve 200 y un token", async () => {
  const res = await fetch(`${ctx.base}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ usuario: "admin", clave: "admin123" }),
  });
  assert.equal(res.status, 200);
  const cuerpo = await res.json();
  assert.ok(typeof cuerpo.token === "string" && cuerpo.token.includes("."));
});

test("login con clave incorrecta devuelve 401", async () => {
  const res = await fetch(`${ctx.base}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ usuario: "admin", clave: "incorrecta" }),
  });
  assert.equal(res.status, 401);
  const cuerpo = await res.json();
  assert.ok(cuerpo.error);
});

test("login con usuario inexistente devuelve 401", async () => {
  const res = await fetch(`${ctx.base}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ usuario: "noexiste", clave: "x" }),
  });
  assert.equal(res.status, 401);
});

test("acceso a un recurso protegido sin token devuelve 401", async () => {
  const res = await api(ctx.base, null, "/api/productos");
  assert.equal(res.status, 401);
  const cuerpo = await res.json();
  assert.ok(cuerpo.error);
});

test("acceso con un token manipulado devuelve 401", async () => {
  const resLogin = await fetch(`${ctx.base}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ usuario: "admin", clave: "admin123" }),
  });
  const token = (await resLogin.json()).token;
  const corrupto = token.slice(0, -3) + "aaa";
  const res = await api(ctx.base, corrupto, "/api/productos");
  assert.equal(res.status, 401);
});

test("acceso con un token expirado devuelve 401", async () => {
  const usuario = ctx.config.datosIniciales.usuarios[0];
  const tokenExpirado = generarToken(usuario, ctx.config.secreto, -1000);
  const res = await api(ctx.base, tokenExpirado, "/api/productos");
  assert.equal(res.status, 401);
});

test("login con body inválido devuelve 401", async () => {
  const res = await fetch(`${ctx.base}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "no-json",
  });
  assert.equal(res.status, 401);
});
