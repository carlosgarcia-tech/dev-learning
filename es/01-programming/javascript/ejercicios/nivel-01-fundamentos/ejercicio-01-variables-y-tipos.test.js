const { test } = require("node:test");
const assert = require("node:assert/strict");
const {
  crearDatos,
  tiposDe,
  formatearDescripcion,
} = require("./ejercicio-01-variables-y-tipos");

test("crearDatos devuelve los 4 datos con sus tipos correctos", () => {
  const datos = crearDatos();
  assert.equal(typeof datos.nombre, "string");
  assert.equal(typeof datos.ciudad, "string");
  assert.equal(typeof datos.edad, "number");
  assert.equal(typeof datos.programacion, "boolean");
});

test("tiposDe devuelve una línea por cada variable", () => {
  const lineas = tiposDe(crearDatos());
  assert.equal(lineas.length, 4);
  assert.equal(lineas[0], "nombre es de tipo string");
  assert.equal(lineas[1], "ciudad es de tipo string");
  assert.equal(lineas[2], "edad es de tipo number");
  assert.equal(lineas[3], "programacion es de tipo boolean");
});

test("formatearDescripcion usa template literals con todos los datos", () => {
  const datos = crearDatos();
  const frase = formatearDescripcion(datos);
  assert.equal(
    frase,
    `Soy ${datos.nombre}, tengo ${datos.edad} años, nací en ${datos.ciudad} y es ${datos.programacion} que estudio programación.`
  );
});

test("formatearDescripcion refleja otros valores de entrada", () => {
  const frase = formatearDescripcion({
    nombre: "Pablo",
    ciudad: "Bogotá",
    edad: 25,
    programacion: false,
  });
  assert.ok(frase.includes("Soy Pablo"));
  assert.ok(frase.includes("25 años"));
  assert.ok(frase.includes("Bogotá"));
  assert.ok(frase.includes("false"));
});
