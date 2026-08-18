function sumar(a, b) {
  // TODO: devuelve a + b (números).
  throw new Error("TODO: implementar sumar(a, b)");
}

function restar(a, b) {
  // TODO: devuelve a - b (números).
  throw new Error("TODO: implementar restar(a, b)");
}

function factorial(n) {
  // TODO: recursivo, caso base n <= 1 -> 1.
  throw new Error("TODO: implementar factorial(n)");
}

function procesarComando(args) {
  // TODO: interpreta args y devuelve el texto a imprimir.
  // - [] -> "Uso: node cli.js <comando> <numero>"
  // - ["suma"|"resta"|"factorial", ...] -> resultado o "Argumento inválido"
  // - otro -> "Comando desconocido: <comando>"
  throw new Error("TODO: implementar procesarComando(args)");
}

if (require.main === module) {
  console.log(procesarComando(process.argv.slice(2)));
}

module.exports = { sumar, restar, factorial, procesarComando };
