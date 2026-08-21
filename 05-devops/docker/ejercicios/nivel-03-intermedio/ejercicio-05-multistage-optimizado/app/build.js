// build.js — "compila" copiando src/ a dist/ (simula un build real)
const fs = require("fs");
const path = require("path");
const SRC = path.join(__dirname, "src");
const DIST = path.join(__dirname, "dist");
fs.rmSync(DIST, { recursive: true, force: true });
fs.mkdirSync(DIST, { recursive: true });
for (const file of fs.readdirSync(SRC)) {
  fs.copyFileSync(path.join(SRC, file), path.join(DIST, file));
}
console.log("Build completo: dist/ generado");
