// shared/circuit-breaker.js - Circuit Breaker reutilizable
// Protege llamadas síncronas a servicios externos.

class CircuitBreaker {
  constructor(umbral = 3, resetSeg = 0.2) {
    this.umbral = umbral;
    this.resetSeg = resetSeg;
    this.fallos = 0;
    this.estado = 'closed';
    this.ultimoFallo = 0;
  }
  call(fn) {
    if (this.estado === 'open') {
      if (Date.now() - this.ultimoFallo > this.resetSeg * 1000) {
        this.estado = 'half_open';
      } else {
        throw new Error('CircuitBreaker abierto');
      }
    }
    try {
      const r = fn();
      this.fallos = 0;
      this.estado = 'closed';
      return r;
    } catch (e) {
      this.fallos++;
      this.ultimoFallo = Date.now();
      if (this.fallos >= this.umbral) this.estado = 'open';
      throw e;
    }
  }
}

module.exports = { CircuitBreaker };
