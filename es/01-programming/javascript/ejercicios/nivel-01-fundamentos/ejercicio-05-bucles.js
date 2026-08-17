function numerosFor() {
  // TODO: devuelve [1, 2, 3, 4, 5] con un bucle for.
  throw new Error("TODO: implementar numerosFor()");
}

function cuentaRegresiva() {
  // TODO: devuelve [5, 4, 3, 2, 1] con un bucle while.
  throw new Error("TODO: implementar cuentaRegresiva()");
}

function recorrer(frutas) {
  // TODO: devuelve las frutas unidas con ", " (recorre con for...of).
  throw new Error("TODO: implementar recorrer(frutas)");
}

function suma1aN(n) {
  // TODO: devuelve la suma de 1 a n con un bucle for.
  throw new Error("TODO: implementar suma1aN(n)");
}

if (require.main === module) {
  console.log(`for: ${numerosFor().join(" ")}`);
  console.log(`while: ${cuentaRegresiva().join(" ")}`);
  console.log(`for...of: ${recorrer(["manzana", "pera", "uva"])}`);
  console.log(`Suma del 1 al 100: ${suma1aN(100)}`);
}

module.exports = { numerosFor, cuentaRegresiva, recorrer, suma1aN };
