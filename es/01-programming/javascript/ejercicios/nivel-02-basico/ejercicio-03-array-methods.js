const PRODUCTOS = [
  // TODO: define el array de productos del enunciado.
];

function obtenerNombres(productos) {
  // TODO: devuelve un array solo con los nombres usando map.
  throw new Error("TODO: implementar obtenerNombres(productos)");
}

function conIVA(productos) {
  // TODO: devuelve [{ nombre, precio }] con el precio +18% redondeado a 2 decimales.
  throw new Error("TODO: implementar conIVA(productos)");
}

function conStock(productos) {
  // TODO: devuelve los productos con stock > 0 usando filter.
  throw new Error("TODO: implementar conStock(productos)");
}

function primeroBarato(productos) {
  // TODO: devuelve el primer producto con precio < 25 usando find.
  throw new Error("TODO: implementar primeroBarato(productos)");
}

if (require.main === module) {
  console.log(`Nombres: ${obtenerNombres(PRODUCTOS)}`);
  console.log("Con IVA:", conIVA(PRODUCTOS));
  console.log(`Con stock: ${conStock(PRODUCTOS).map((p) => p.nombre).join(", ")}`);
  console.log(`Primero < 25: ${primeroBarato(PRODUCTOS).nombre}`);
}

module.exports = { PRODUCTOS, obtenerNombres, conIVA, conStock, primeroBarato };
