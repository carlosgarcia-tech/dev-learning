// Interfaz común
class Logger {
  log(mensaje) { throw new Error('no implementado'); }
}

// Implementación real (consola)
class ConsoleLogger extends Logger {
  log(mensaje) { console.log(mensaje); }
}

// Implementación para tests (memoria)
class MemoryLogger extends Logger {
  constructor() { super(); this.mensajes = []; }
  log(mensaje) { this.mensajes.push(mensaje); }
}

// Service: NO crea el logger, lo RECIBE (DIP)
class LoggerService {
  constructor(logger) {        // inyección por constructor
    this.logger = logger;
  }
  registrar(mensaje) {
    this.logger.log(mensaje);
  }
}

module.exports = { Logger, ConsoleLogger, MemoryLogger, LoggerService };
