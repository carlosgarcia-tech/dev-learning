const doble = (n) => {
  // TODO: arrow con retorno implícito, devuelve n * 2.
  throw new Error("TODO: implementar doble(n)");
};

const cuadrado = (n) => {
  // TODO: arrow de una línea, devuelve n * n.
  throw new Error("TODO: implementar cuadrado(n)");
};

const describir = (nombre, edad) => {
  // TODO: arrow con bloque {}, devuelve "<nombre> tiene <edad> años".
  throw new Error("TODO: implementar describir(nombre, edad)");
};

function calcularCuadrados(numeros) {
  // TODO: usa map con una arrow para devolver los cuadrados.
  throw new Error("TODO: implementar calcularCuadrados(numeros)");
}

if (require.main === module) {
  console.log(`doble(6): ${doble(6)}`);
  console.log(`cuadrado(9): ${cuadrado(9)}`);
  console.log(`describir: ${describir("Ana", 30)}`);
  console.log(`Cuadrados: ${calcularCuadrados([1, 2, 3, 4, 5])}`);
}

module.exports = { doble, cuadrado, describir, calcularCuadrados };
