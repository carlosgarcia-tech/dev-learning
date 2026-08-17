const crypto = require("node:crypto");

function generarToken(usuario, secreto, expiracionMs = 8 * 60 * 60 * 1000) {
  // TODO: implementa un token firmado con HMAC-SHA256.
  // 1. Construye el payload { sub: usuario.id, usuario: usuario.usuario, exp: Date.now() + expiracionMs }.
  // 2. Codifícalo con Buffer.from(JSON.stringify(payload)).toString("base64url").
  // 3. Fírmalo: crypto.createHmac("sha256", secreto).update(payload).digest("base64url").
  // 4. Devuelve `${payload}.${firma}`.
  throw new Error("TODO: implementar generarToken(usuario, secreto, expiracionMs)");
}

function verificarToken(token, secreto) {
  // TODO: valida el token y devuelve el payload o null.
  // 1. Separa por "."; si no hay payload o firma, devuelve null.
  // 2. Recalcula la firma esperada y compárala con crypto.timingSafeEqual (cuidado con longitudes).
  // 3. Decodifica el payload y comprueba que datos.exp >= Date.now().
  // 4. Devuelve los datos (o null si algo falla).
  throw new Error("TODO: implementar verificarToken(token, secreto)");
}

module.exports = { generarToken, verificarToken };
