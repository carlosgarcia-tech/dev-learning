function raizCuadrada(n) {
  // TODO: lanza Error si n < 0; si no, devuelve Math.sqrt(n).
  throw new Error("TODO: implementar raizCuadrada(n)");
}

function parsearJSON(texto) {
  // TODO: devuelve JSON.parse(texto) o lanza Error("JSON inválido").
  throw new Error("TODO: implementar parsearJSON(texto)");
}

if (require.main === module) {
  try {
    console.log(`raíz de 9: ${raizCuadrada(9)}`);
  } finally {
    console.log("La operación terminó");
  }
  try {
    raizCuadrada(-4);
  } catch (error) {
    console.log(`Error: ${error.message}`);
  }
  try {
    console.log(`parseado: ${parsearJSON('{"a": 1}')}`);
  } catch (error) {
    console.log(`Error: ${error.message}`);
  }
  try {
    parsearJSON("texto roto");
  } catch (error) {
    console.log(`Error: ${error.message}`);
  }
}

module.exports = { raizCuadrada, parsearJSON };
