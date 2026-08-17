const { test } = require("node:test");
const assert = require("node:assert/strict");
const { debounce, throttle } = require("./ejercicio-04-memoizacion-y-rendimiento");

const dormir = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

test("debounce ejecuta una sola vez tras la ráfaga", async () => {
  let llamadas = 0;
  const debounced = debounce(() => llamadas++, 40);
  for (let i = 0; i < 5; i++) debounced();
  assert.equal(llamadas, 0);
  await dormir(100);
  assert.equal(llamadas, 1);
  await dormir(60);
  assert.equal(llamadas, 1);
});

test("debounce reinicia el temporizador con cada llamada", async () => {
  let llamadas = 0;
  const debounced = debounce(() => llamadas++, 30);
  debounced();
  await dormir(20);
  debounced();
  await dormir(20);
  debounced();
  assert.equal(llamadas, 0);
  await dormir(60);
  assert.equal(llamadas, 1);
});

test("throttle ejecuta como máximo una vez por límite", async () => {
  let llamadas = 0;
  const throttled = throttle(() => llamadas++, 30);
  const inicio = Date.now();
  while (Date.now() - inicio < 150) {
    throttled();
    await dormir(5);
  }
  assert.ok(llamadas >= 4 && llamadas <= 8, `llamadas: ${llamadas}`);
});
