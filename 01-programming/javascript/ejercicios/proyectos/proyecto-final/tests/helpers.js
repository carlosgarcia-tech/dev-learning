const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const { crearServidor } = require("../starter/server");

async function arrancarServidor(configExtra = {}) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "mitienda-"));
  const archivoDatos = path.join(dir, "database.json");
  const config = {
    archivoDatos,
    secreto: "secreto-de-prueba",
    expiracionTokenMs: 3600000,
    datosIniciales: {
      productos: [],
      pedidos: [],
      usuarios: [{ id: 1, usuario: "admin", clave: "admin123" }],
    },
    ...configExtra,
  };
  const server = crearServidor(config);
  await new Promise((resolve) => server.listen(0, resolve));
  const base = `http://localhost:${server.address().port}`;
  return { server, base, archivoDatos, config };
}

async function login(base, usuario = "admin", clave = "admin123") {
  const res = await fetch(`${base}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ usuario, clave }),
  });
  const cuerpo = await res.json();
  return cuerpo.token;
}

async function api(base, token, ruta, opciones = {}) {
  const headers = { ...(opciones.headers || {}) };
  if (token) headers["Authorization"] = `Bearer ${token}`;
  return fetch(`${base}${ruta}`, { ...opciones, headers });
}

async function crearProducto(base, token, datos) {
  const res = await api(base, token, "/api/productos", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(datos),
  });
  return res.json();
}

module.exports = { arrancarServidor, login, api, crearProducto };
