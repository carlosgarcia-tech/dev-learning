const PERSONA = {
  // TODO: define { nombre: "Luis", edad: 28, ciudad: "Quito" }.
};

const PUNTO = [
  // TODO: define [10, 20, 30].
];

function extraerPersona(persona) {
  // TODO: devuelve "nombre: <nombre>, ciudad: <ciudad>" con destructuring.
  throw new Error("TODO: implementar extraerPersona(persona)");
}

function extraerEdad(persona) {
  // TODO: devuelve la edad con alias `edad: anios`.
  throw new Error("TODO: implementar extraerEdad(persona)");
}

function extraerPunto(punto) {
  // TODO: devuelve "x: <x>, y: <y>, resto: [<...resto>]" con destructuring y rest.
  throw new Error("TODO: implementar extraerPunto(punto)");
}

function combinarArrays(a, b) {
  // TODO: devuelve [...a, ...b].
  throw new Error("TODO: implementar combinarArrays(a, b)");
}

function copiarPersona(persona) {
  // TODO: devuelve { ...persona, activo: true }.
  throw new Error("TODO: implementar copiarPersona(persona)");
}

function unir(...args) {
  // TODO: devuelve args.join(",") usando rest.
  throw new Error("TODO: implementar unir(...args)");
}

if (require.main === module) {
  console.log(extraerPersona(PERSONA));
  console.log(`anios: ${extraerEdad(PERSONA)}`);
  console.log(extraerPunto(PUNTO));
  console.log(`Combinado: ${combinarArrays([1, 2, 3], [4, 5, 6])}`);
  console.log("Copia:", copiarPersona(PERSONA));
  console.log(`unir: ${unir("a", "b", "c")}`);
}

module.exports = {
  PERSONA,
  PUNTO,
  extraerPersona,
  extraerEdad,
  extraerPunto,
  combinarArrays,
  copiarPersona,
  unir,
};
