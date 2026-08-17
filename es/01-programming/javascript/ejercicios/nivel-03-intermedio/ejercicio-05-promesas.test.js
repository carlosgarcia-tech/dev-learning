const { test } = require("node:test");
const assert = require("node:assert/strict");
const { simularDescarga, dividir } = require("./ejercicio-05-promesas");

test("simularDescarga resuelve con el mensaje correcto", async () => {
  const resultado = await simularDescarga("video.mp4", 10);
  assert.equal(resultado, "Descargado: video.mp4");
});

test("Promise.all descarga varios archivos en paralelo", async () => {
  const resultados = await Promise.all([
    simularDescarga("a.txt", 5),
    simularDescarga("b.txt", 5),
    simularDescarga("c.txt", 5),
  ]);
  assert.deepEqual(resultados, [
    "Descargado: a.txt",
    "Descargado: b.txt",
    "Descargado: c.txt",
  ]);
});

test("dividir resuelve con la división válida", async () => {
  assert.equal(await dividir(10, 2), 5);
});

test("dividir rechaza con la división entre cero", async () => {
  await assert.rejects(dividir(10, 0), /No se puede dividir entre cero/);
});
