class EventEmitter {
  constructor() {
    // TODO: this.registros = new Map().
    throw new Error("TODO: implementar el constructor de EventEmitter");
  }

  on(evento, listener) {
    // TODO: registra un listener para el evento.
    throw new Error("TODO: implementar on(evento, listener)");
  }

  once(evento, listener) {
    // TODO: registra un listener que se ejecuta una sola vez.
    throw new Error("TODO: implementar once(evento, listener)");
  }

  off(evento, listener) {
    // TODO: elimina el listener indicado del evento.
    throw new Error("TODO: implementar off(evento, listener)");
  }

  emit(evento, ...args) {
    // TODO: llama a todos los listeners del evento con los argumentos.
    throw new Error("TODO: implementar emit(evento, ...args)");
  }

  listeners(evento) {
    // TODO: devuelve el array de listeners del evento.
    throw new Error("TODO: implementar listeners(evento)");
  }
}

if (require.main === module) {
  const emisor = new EventEmitter();
  const saludar = (nombre) => console.log(`Hola, ${nombre}!`);
  const despedir = (nombre) => console.log(`Adiós, ${nombre}!`);
  emisor.on("saludo", saludar);
  emisor.once("saludo", despedir);
  emisor.emit("saludo", "Ana");
  emisor.emit("saludo", "Luis");
  emisor.off("saludo", saludar);
  emisor.emit("saludo", "Pedro");
  console.log(emisor.listeners("saludo"));
}

module.exports = { EventEmitter };
