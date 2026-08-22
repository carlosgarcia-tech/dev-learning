// Clase base (interfaz)
class Descuento {
  aplicar(base) { return base; }
}

// Descuentos concretos: cada uno extiende sin tocar a los demás
class SinDescuento extends Descuento {
  aplicar(base) { return base; }
}
class DescuentoVIP extends Descuento {
  aplicar(base) { return base * 0.8; }
}
class DescuentoBlackFriday extends Descuento {
  aplicar(base) { return base * 0.5; }
}

// Esta función NO cambia al añadir nuevos descuentos → OCP
function precioFinal(descuento, base) {
  return descuento.aplicar(base);
}

// Carrito usa un descuento (inyectado)
class Carrito {
  constructor(descuento = new SinDescuento()) {
    this.descuento = descuento;
    this.items = [];
  }
  add(precio) { this.items.push(precio); return this; }
  total() {
    const base = this.items.reduce((s, p) => s + p, 0);
    return precioFinal(this.descuento, base);
  }
}

module.exports = {
  Descuento, SinDescuento, DescuentoVIP, DescuentoBlackFriday,
  precioFinal, Carrito,
};
