function operaciones(a, b) {
  // TODO: devuelve { suma, resta, multiplicacion, division, modulo, potencia }.
  throw new Error("TODO: implementar operaciones(a, b)");
}

function comparaciones(a, b) {
  // TODO: devuelve [a>b, a<b, a>=b, a===b, a!==b].
  throw new Error("TODO: implementar comparaciones(a, b)");
}

function clasificarProducto(a, b) {
  // TODO: clasifica a*b en "mayor a 50", "entre 10 y 50" o "menor a 10".
  throw new Error("TODO: implementar clasificarProducto(a, b)");
}

function parOImpar(n) {
  // TODO: devuelve "par" o "impar" con un ternario.
  throw new Error("TODO: implementar parOImpar(n)");
}

if (require.main === module) {
  const a = 10;
  const b = 3;
  const op = operaciones(a, b);
  console.log(`Suma: ${op.suma}`);
  console.log(`Resta: ${op.resta}`);
  console.log(`Multiplicacion: ${op.multiplicacion}`);
  console.log(`Division: ${op.division}`);
  console.log(`Modulo: ${op.modulo}`);
  console.log(`Potencia: ${op.potencia}`);
  const [mayor, menor, mayorIgual, estrictamenteIgual, distinto] = comparaciones(a, b);
  console.log(`${a} > ${b}: ${mayor}`);
  console.log(`${a} < ${b}: ${menor}`);
  console.log(`${a} >= ${b}: ${mayorIgual}`);
  console.log(`${a} === ${b}: ${estrictamenteIgual}`);
  console.log(`${a} !== ${b}: ${distinto}`);
  console.log(clasificarProducto(a, b));
  console.log(`${a} es ${parOImpar(a)}`);
}

module.exports = { operaciones, comparaciones, clasificarProducto, parOImpar };
