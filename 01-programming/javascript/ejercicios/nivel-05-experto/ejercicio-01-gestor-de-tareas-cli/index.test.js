const { test } = require("node:test");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const {
  leerTareas,
  guardarTareas,
  siguienteId,
  agregarTarea,
  completarTarea,
  eliminarTarea,
  formatear,
} = require("./index");

function archivoTemporal() {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "tareas-"));
  return path.join(dir, "tareas.json");
}

test("leerTareas crea el archivo con [] si no existe", () => {
  const archivo = archivoTemporal();
  const tareas = leerTareas(archivo);
  assert.deepEqual(tareas, []);
  assert.equal(fs.readFileSync(archivo, "utf-8"), "[]");
});

test("siguienteId calcula el máximo + 1", () => {
  assert.equal(siguienteId([]), 1);
  assert.equal(siguienteId([{ id: 3 }, { id: 7 }]), 8);
});

test("agregarTarea añade con id incremental", () => {
  const base = [];
  const primero = agregarTarea(base, "Estudiar JavaScript");
  assert.equal(primero.tarea.id, 1);
  assert.equal(primero.tarea.completada, false);
  const segundo = agregarTarea(primero.tareas, "Hacer ejercicios");
  assert.equal(segundo.tarea.id, 2);
});

test("completarTarea marca la tarea como completada", () => {
  const base = [{ id: 1, texto: "A", completada: false }];
  const resultado = completarTarea(base, 1);
  assert.equal(resultado.encontrada, true);
  assert.equal(resultado.tareas[0].completada, true);
});

test("completarTarea no encuentra un id inexistente", () => {
  const resultado = completarTarea([{ id: 1, texto: "A", completada: false }], 99);
  assert.equal(resultado.encontrada, false);
});

test("eliminarTarea filtra el id indicado", () => {
  const base = [
    { id: 1, texto: "A", completada: false },
    { id: 2, texto: "B", completada: false },
  ];
  const resultado = eliminarTarea(base, 2);
  assert.equal(resultado.eliminada, true);
  assert.deepEqual(resultado.tareas, [base[0]]);
});

test("eliminarTarea reporta ids inexistentes", () => {
  const base = [{ id: 1, texto: "A", completada: false }];
  const resultado = eliminarTarea(base, 99);
  assert.equal(resultado.eliminada, false);
});

test("formatear usa [x] y [ ]", () => {
  const tareas = [
    { id: 1, texto: "Estudiar", completada: true },
    { id: 2, texto: "Dormir", completada: false },
  ];
  assert.deepEqual(formatear(tareas), ["1. [x] Estudiar", "2. [ ] Dormir"]);
});

test("persistencia: guardar y volver a leer devuelve lo mismo", () => {
  const archivo = archivoTemporal();
  const base = [{ id: 1, texto: "A", completada: false }];
  guardarTareas(archivo, base);
  assert.deepEqual(leerTareas(archivo), base);
});
