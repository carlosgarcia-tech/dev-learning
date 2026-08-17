function saludar(nombre) {
  // TODO: devuelve `Hola, <nombre>!` (declaración de función).
  throw new Error("TODO: implementar saludar(nombre)");
}

const esPar = function (n) {
  // TODO: devuelve true si n es par (expresión de función).
  throw new Error("TODO: implementar esPar(n)");
};

function sumarTodos(...numeros) {
  // TODO: devuelve la suma de todos los argumentos usando rest.
  throw new Error("TODO: implementar sumarTodos(...numeros)");
}

function potencia(base, exponente = 2) {
  // TODO: devuelve base ** exponente con valor por defecto.
  throw new Error("TODO: implementar potencia(base, exponente = 2)");
}

if (require.main === module) {
  console.log(saludar("Ana"));
  console.log(`7 es par: ${esPar(7)}`);
  console.log(`8 es par: ${esPar(8)}`);
  console.log(`Suma de 1,2,3,4: ${sumarTodos(1, 2, 3, 4)}`);
  console.log(`Suma sin argumentos: ${sumarTodos()}`);
  console.log(`3^2 (por defecto): ${potencia(3)}`);
  console.log(`3^4: ${potencia(3, 4)}`);
}

module.exports = { saludar, esPar, sumarTodos, potencia };
