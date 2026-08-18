function sumar(a, b) {
  // TODO: devuelve a + b.
  throw new Error("TODO: implementar sumar(a, b)");
}

function esPalindromo(texto) {
  // TODO: devuelve true si el texto (en minúsculas) es igual a su reverso.
  throw new Error("TODO: implementar esPalindromo(texto)");
}

function dividir(a, b) {
  // TODO: devuelve a / b o lanza Error si b === 0.
  throw new Error("TODO: implementar dividir(a, b)");
}

function probar(nombre, fn) {
  // TODO: ejecuta fn; si lanza, imprime el fallo y sale con exit(1).
  throw new Error("TODO: implementar probar(nombre, fn)");
}

if (require.main === module) {
  const assert = require("node:assert");
  probar("sumar(2, 3) === 5", () => assert.strictEqual(sumar(2, 3), 5));
  probar("sumar(-1, 1) === 0", () => assert.strictEqual(sumar(-1, 1), 0));
  probar('esPalindromo("reconocer") === true', () =>
    assert.strictEqual(esPalindromo("reconocer"), true)
  );
  probar('esPalindromo("Hola") === false', () =>
    assert.strictEqual(esPalindromo("Hola"), false)
  );
  probar("dividir(1, 0) lanza error", () =>
    assert.throws(() => dividir(1, 0), /cero/)
  );
  probar("dividir(10, 2) === 5", () => assert.strictEqual(dividir(10, 2), 5));
  console.log("Todas las pruebas pasaron");
}

module.exports = { sumar, esPalindromo, dividir, probar };
