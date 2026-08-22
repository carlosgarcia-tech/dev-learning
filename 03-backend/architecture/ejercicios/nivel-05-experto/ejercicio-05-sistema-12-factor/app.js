// app.js - Ejemplo de aplicación 12-factor
// III Config: config en entorno, NO en código
const PORT = process.env.PORT || 3000;
const DATABASE_URL = process.env.DATABASE_URL;
const REDIS_URL = process.env.REDIS_URL;
const JWT_SECRET = process.env.JWT_SECRET;

// VI Processes: stateless - NO guardar estado en memoria entre peticiones
// (la sesión va a Redis, no a un dict del proceso)
const sessionStore = null; // se inicializa contra REDIS_URL, no en memoria

// X Logs: a stdout en JSON, NO a archivo local
function log(level, msg, extra = {}) {
  console.log(JSON.stringify({ ts: new Date().toISOString(), level, msg, ...extra }));
}

// IX Disposability: arranque rápido + shutdown limpio
function start() {
  log("info", "app starting", { port: PORT });
  if (!DATABASE_URL) log("warn", "DATABASE_URL no configurada");
  if (!JWT_SECRET) log("warn", "JWT_SECRET no configurada");
  // servidor mínimo (no arranca realmente en este starter)
  log("info", "app ready");
  return { port: PORT };
}

// Graceful shutdown
function shutdown() {
  log("info", "shutting down");
  process.exit(0);
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);

// XI Admin processes: las migraciones se corren como proceso aparte
// (ej: npm run migrate) - no en el arranque del servidor

module.exports = { start, log, PORT, DATABASE_URL };
