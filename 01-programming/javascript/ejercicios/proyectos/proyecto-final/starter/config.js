const path = require("node:path");

const config = {
  puerto: 3000,
  secreto: "secreto-super-seguro-cambiar-en-produccion",
  expiracionTokenMs: 8 * 60 * 60 * 1000,
  archivoDatos: path.join(__dirname, "data", "database.json"),
  datosIniciales: {
    productos: [],
    pedidos: [],
    usuarios: [{ id: 1, usuario: "admin", clave: "admin123" }],
  },
};

module.exports = config;
