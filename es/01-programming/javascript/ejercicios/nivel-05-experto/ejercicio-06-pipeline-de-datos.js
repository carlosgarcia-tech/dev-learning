const VENTAS = [
  // TODO: define el array de ventas del enunciado.
];

function soloFebrero(datos) {
  // TODO: filtra las ventas cuya fecha empiece por "2026-02".
  throw new Error("TODO: implementar soloFebrero(datos)");
}

function proyectar(datos) {
  // TODO: quedarse solo con { region, vendedor, monto }.
  throw new Error("TODO: implementar proyectar(datos)");
}

function agruparPorVendedor(datos) {
  // TODO: reduce -> { vendedor: total }.
  throw new Error("TODO: implementar agruparPorVendedor(datos)");
}

function ordenarPorTotal(agrupado) {
  // TODO: Object.entries + sort de mayor a menor por total.
  throw new Error("TODO: implementar ordenarPorTotal(agrupado)");
}

function formatear(entradas) {
  // TODO: mapea cada entrada a "<vendedor>: <total>".
  throw new Error("TODO: implementar formatear(entradas)");
}

function pipeline(etapas, datosIniciales) {
  // TODO: encadena las etapas con reduce.
  throw new Error("TODO: implementar pipeline(etapas, datosIniciales)");
}

if (require.main === module) {
  const resultado = pipeline(
    [soloFebrero, proyectar, agruparPorVendedor, ordenarPorTotal, formatear],
    VENTAS
  );
  for (const linea of resultado) {
    console.log(linea);
  }
}

module.exports = {
  VENTAS,
  soloFebrero,
  proyectar,
  agruparPorVendedor,
  ordenarPorTotal,
  formatear,
  pipeline,
};
