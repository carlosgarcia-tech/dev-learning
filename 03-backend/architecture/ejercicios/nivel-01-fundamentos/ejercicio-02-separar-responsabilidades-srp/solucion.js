// Dominio: solo cálculo (SRP - regla de negocio)
class Factura {
  constructor(items) { this.items = items; }  // items: [{precio, cantidad}]
  total() {
    return this.items.reduce((s, i) => s + i.precio * i.cantidad, 0);
  }
}

// Persistencia (SRP - datos)
class FacturaRepository {
  constructor() { this.db = new Map(); }
  save(factura) {
    const id = 'f-' + Math.random().toString(36).slice(2);
    this.db.set(id, factura);
    return id;
  }
}

// Serialización (SRP - presentación del formato)
class FacturaSerializer {
  toXML(factura) {
    const items = factura.items
      .map(i => `  <item precio="${i.precio}" cantidad="${i.cantidad}"/>`)
      .join('\n');
    return `<factura total="${factura.total()}">\n${items}\n</factura>`;
  }
}

// Email (SRP - comunicación)
class FacturaMailer {
  enviar(factura) {
    return `Enviando email con factura de total ${factura.total()}`;
  }
}

// Service: orquesta, sin lógica propia de cada responsabilidad
class FacturaService {
  constructor(factura, repo, serializer, mailer) {
    this.factura = factura;
    this.repo = repo;
    this.serializer = serializer;
    this.mailer = mailer;
  }
  procesar() {
    const total = this.factura.total();
    const id = this.repo.save(this.factura);
    const xml = this.serializer.toXML(this.factura);
    const mail = this.mailer.enviar(this.factura);
    return { id, total, xml, mail };
  }
}

module.exports = { Factura, FacturaRepository, FacturaSerializer, FacturaMailer, FacturaService };
