function crearContador() {
  // TODO: usa un closure para mantener `cuenta` privada y devuelve
  // { incrementar(), decrementar(), obtener() }.
  throw new Error("TODO: implementar crearContador()");
}

function crearMultiplicador(n) {
  // TODO: devuelve (x) => x * n usando un closure.
  throw new Error("TODO: implementar crearMultiplicador(n)");
}

if (require.main === module) {
  const contadorA = crearContador();
  const contadorB = crearContador();
  console.log(`A incrementa: ${contadorA.incrementar()}`);
  console.log(`A incrementa: ${contadorA.incrementar()}`);
  console.log(`B incrementa: ${contadorB.incrementar()}`);
  console.log(`A decrementa: ${contadorA.decrementar()}`);
  console.log(`A obtener: ${contadorA.obtener()}`);
  console.log(`B obtener: ${contadorB.obtener()}`);
  const porDos = crearMultiplicador(2);
  const porTres = crearMultiplicador(3);
  console.log(`porDos(5): ${porDos(5)}`);
  console.log(`porTres(5): ${porTres(5)}`);
}

module.exports = { crearContador, crearMultiplicador };
