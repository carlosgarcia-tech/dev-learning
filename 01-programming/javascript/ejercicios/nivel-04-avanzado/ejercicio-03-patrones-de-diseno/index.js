const contadorModule = (() => {
  // TODO: IIFE con variable `cuenta` privada y métodos incrementar()/obtener().
  throw new Error("TODO: implementar el module pattern (contadorModule)");
})();

class Configuracion {
  constructor() {
    // TODO: singleton: devuelve siempre la misma instancia (Configuracion.instancia).
    throw new Error("TODO: implementar el singleton Configuracion");
  }
}

class Evento {
  constructor() {
    // TODO: this.suscritos = [].
    throw new Error("TODO: implementar el constructor de Evento");
  }

  suscribir(fn) {
    // TODO: añade fn a los suscriptores.
    throw new Error("TODO: implementar Evento.suscribir(fn)");
  }

  desuscribir(fn) {
    // TODO: elimina fn de los suscriptores.
    throw new Error("TODO: implementar Evento.desuscribir(fn)");
  }

  emitir(...args) {
    // TODO: llama a todos los suscriptores con los argumentos.
    throw new Error("TODO: implementar Evento.emitir(...args)");
  }
}

if (require.main === module) {
  console.log(
    `Module: cuenta ${contadorModule.incrementar()}, ${contadorModule.incrementar()}, ${contadorModule.incrementar()}`
  );
  console.log(`module.cuenta está oculto: ${contadorModule.cuenta}`);
  const conf1 = new Configuracion();
  const conf2 = new Configuracion();
  console.log(`Singleton: ¿misma instancia? ${conf1 === conf2}`);

  const evento = new Evento();
  const sus1 = (m) => console.log(`Suscriptor 1 recibió: ${m}`);
  const sus2 = (m) => console.log(`Suscriptor 2 recibió: ${m}`);
  evento.suscribir(sus1);
  evento.suscribir(sus2);
  evento.emitir("Hola desde observer");
  evento.desuscribir(sus2);
  evento.emitir("Tras desuscribir, solo responde un suscriptor");
}

module.exports = { contadorModule, Configuracion, Evento };
