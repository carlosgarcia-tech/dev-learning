const { generarToken } = require("../auth");

async function login(req, res, ctx) {
  // TODO: implementa el login.
  // 1. Lee el body con ctx.leerBody(req).
  // 2. Extrae usuario y clave (strings).
  // 3. Busca en ctx.db.usuarios() el usuario con esas credenciales.
  // 4. Si no existe -> 401 { error: "Credenciales inválidas" }.
  // 5. Si existe -> 200 { token: generarToken(...), usuario: { id, usuario } }.
  // Puedes usar ctx.secreto y ctx.expiracionTokenMs.
  throw new Error("TODO: implementar login(req, res, ctx)");
}

module.exports = { login };
