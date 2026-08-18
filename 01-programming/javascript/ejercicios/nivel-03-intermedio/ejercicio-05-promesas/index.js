function simularDescarga(archivo, ms) {
  // TODO: devuelve una promesa que resuelve "Descargado: <archivo>" tras ms.
  throw new Error("TODO: implementar simularDescarga(archivo, ms)");
}

function dividir(a, b) {
  // TODO: devuelve una promesa que resuelve a / b o rechaza si b === 0.
  throw new Error("TODO: implementar dividir(a, b)");
}

if (require.main === module) {
  simularDescarga("video.mp4", 300)
    .then((resultado) => {
      console.log(resultado);
      return resultado;
    })
    .then((resultado) => console.log(`Reproduciendo ${resultado}`));

  Promise.all([
    simularDescarga("a.txt", 100),
    simularDescarga("b.txt", 200),
    simularDescarga("c.txt", 150),
  ]).then((resultados) => console.log(`Descarga en paralelo: ${resultados}`));

  dividir(10, 0).catch((error) => console.log(`Error: ${error.message}`));
  dividir(10, 2).then((r) => console.log(`División válida: ${r}`));
}

module.exports = { simularDescarga, dividir };
