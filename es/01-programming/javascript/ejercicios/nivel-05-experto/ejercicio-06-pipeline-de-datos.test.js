const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  VENTAS,
  soloFebrero,
  proyectar,
  agruparPorVendedor,
  ordenarPorTotal,
  formatear,
  pipeline,
} = require("./ejercicio-06-pipeline-de-datos");

test("VENTAS contiene 6 ventas", () => {
  assert.equal(VENTAS.length, 6);
});

test("soloFebrero filtra por el mes", () => {
  const febrero = soloFebrero(VENTAS);
  assert.equal(febrero.length, 3);
  assert.ok(febrero.every((v) => v.fecha.startsWith("2026-02")));
});

test("proyectar deja solo region, vendedor y monto", () => {
  const proyectado = proyectar([{ region: "Norte", vendedor: "Ana", monto: 100, fecha: "2026-01-01", extra: 1 }]);
  assert.deepEqual(proyectado, [{ region: "Norte", vendedor: "Ana", monto: 100 }]);
});

test("agruparPorVendedor suma los montos", () => {
  const agrupado = agruparPorVendedor(soloFebrero(VENTAS));
  assert.deepEqual(agrupado, { Ana: 500, Luis: 1500, Pedro: 900 });
});

test("ordenarPorTotal ordena de mayor a menor", () => {
  const ordenado = ordenarPorTotal({ Ana: 500, Luis: 1500, Pedro: 900 });
  assert.deepEqual(ordenado, [
    ["Luis", 1500],
    ["Pedro", 900],
    ["Ana", 500],
  ]);
});

test("formatear produce strings con dos puntos", () => {
  assert.deepEqual(
    formatear([
      ["Luis", 1500],
      ["Ana", 500],
    ]),
    ["Luis: 1500", "Ana: 500"]
  );
});

test("pipeline encadena las etapas de principio a fin", () => {
  const resultado = pipeline(
    [soloFebrero, proyectar, agruparPorVendedor, ordenarPorTotal, formatear],
    VENTAS
  );
  assert.deepEqual(resultado, ["Luis: 1500", "Pedro: 900", "Ana: 500"]);
});
