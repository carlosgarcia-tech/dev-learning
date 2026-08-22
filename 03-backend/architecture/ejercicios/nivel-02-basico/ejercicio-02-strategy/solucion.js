// Interfaz común
class EstrategiaEnvio {
  calcular(peso, distancia) { throw new Error('no implementado'); }
}

// Estrategias concretas
class EnvioEstandar extends EstrategiaEnvio {
  calcular(peso, distancia) { return peso * 1 + distancia * 0.5; }
}
class EnvioExpress extends EstrategiaEnvio {
  calcular(peso, distancia) { return peso * 2 + distancia * 1; }
}
class EnvioInternacional extends EstrategiaEnvio {
  calcular(peso, distancia) { return peso * 3 + distancia * 2; }
}

// Contexto: usa la estrategia inyectada, intercambiable
class CalculadoraEnvio {
  constructor(estrategia) { this.estrategia = estrategia; }
  setEstrategia(e) { this.estrategia = e; return this; }
  calcular(peso, distancia) { return this.estrategia.calcular(peso, distancia); }
}

module.exports = {
  EstrategiaEnvio, EnvioEstandar, EnvioExpress, EnvioInternacional, CalculadoraEnvio,
};
