function analizarFrase(frase) {
  // TODO: devuelve { longitud, sinEspacios, mayusculas, minusculas, contieneGenial, palabras }.
  throw new Error("TODO: implementar analizarFrase(frase)");
}

function concatenar(limpia) {
  // TODO: devuelve { concatenacion: "Me encanta: <limpia>!", template: `Aprendo "<limpia>" hoy` }.
  throw new Error("TODO: implementar concatenar(limpia)");
}

if (require.main === module) {
  const frase = "  JavaScript es genial  ";
  const analizado = analizarFrase(frase);
  console.log(`Longitud: ${analizado.longitud}`);
  console.log(`Sin espacios: "${analizado.sinEspacios}"`);
  console.log(`Mayúsculas: ${analizado.mayusculas}`);
  console.log(`Minúsculas: ${analizado.minusculas}`);
  console.log(`¿Contiene "genial"? ${analizado.contieneGenial}`);
  console.log(`Palabras: ${analizado.palabras}`);
  const concat = concatenar(analizado.sinEspacios);
  console.log(concat.concatenacion);
  console.log(concat.template);
}

module.exports = { analizarFrase, concatenar };
