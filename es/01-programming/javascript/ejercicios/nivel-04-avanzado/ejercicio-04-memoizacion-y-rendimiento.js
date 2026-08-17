function debounce(fn, espera) {
  // TODO: devuelve una función que retrasa fn hasta que pasen `espera` ms sin llamadas.
  throw new Error("TODO: implementar debounce(fn, espera)");
}

function throttle(fn, limite) {
  // TODO: devuelve una función que ejecuta fn como máximo una vez cada `limite` ms.
  throw new Error("TODO: implementar throttle(fn, limite)");
}

if (require.main === module) {
  let conteoDebounce = 0;
  const debounced = debounce(() => {
    conteoDebounce++;
    console.log(`Debounce: ejecución número ${conteoDebounce}`);
  }, 300);
  for (let i = 0; i < 5; i++) debounced();
  console.log("(5 llamadas rápidas al debounce; solo una debe ejecutarse al final)");

  let ejecuciones = 0;
  const throttled = throttle(() => {
    ejecuciones++;
    console.log(`Throttle: ejecución ${ejecuciones}`);
  }, 250);
  const intervalo = setInterval(() => throttled(), 100);
  setTimeout(() => {
    clearInterval(intervalo);
    console.log("Fin de la prueba de throttle");
  }, 1000);
}

module.exports = { debounce, throttle };
