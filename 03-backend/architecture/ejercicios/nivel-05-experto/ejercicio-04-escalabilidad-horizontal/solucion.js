class Instancia {
  constructor(id) {
    this.id = id;
    this.conexiones = 0;
    this.up = true;
  }
  health() { return this.up ? 'up' : 'down'; }
  async handle(req) {
    this.conexiones++;
    try {
      return { handled_by: this.id, req };
    } finally {
      this.conexiones--;
    }
  }
  // Simula mantener conexiones activas (para test least-connections)
  async hold() { this.conexiones++; }
  release() { this.conexiones--; }
}

class LoadBalancer {
  constructor() {
    this.instancias = [];
    this._rr = 0;
  }
  add(inst) { this.instancias.push(inst); return this; }
  remove(inst) {
    this.instancias = this.instancias.filter(i => i !== inst);
    return this;
  }
  _ups() { return this.instancias.filter(i => i.health() === 'up'); }
  distribute(req, algoritmo = 'round-robin') {
    const ups = this._ups();
    if (ups.length === 0) throw new Error('no hay instancias disponibles');
    let elegida;
    if (algoritmo === 'least-connections') {
      elegida = ups.reduce((min, i) => i.conexiones < min.conexiones ? i : min, ups[0]);
    } else { // round-robin
      elegida = ups[this._rr % ups.length];
      this._rr = (this._rr + 1) % ups.length;
    }
    return elegida.handle(req);
  }
}

module.exports = { Instancia, LoadBalancer };
