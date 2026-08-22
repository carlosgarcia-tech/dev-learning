class Cafe {
  coste() { return 0; }
  desc() { return ''; }
}

class CafeSimple extends Cafe {
  coste() { return 2; }
  desc() { return 'Café'; }
}

class CafeDecorator extends Cafe {
  constructor(cafe) { super(); this.cafe = cafe; }
  coste() { return this.cafe.coste(); }
  desc() { return this.cafe.desc(); }
}

class Leche extends CafeDecorator {
  coste() { return this.cafe.coste() + 0.5; }
  desc() { return this.cafe.desc() + ' + Leche'; }
}
class Azucar extends CafeDecorator {
  coste() { return this.cafe.coste() + 0.2; }
  desc() { return this.cafe.desc() + ' + Azúcar'; }
}
class ExtraShot extends CafeDecorator {
  coste() { return this.cafe.coste() + 0.8; }
  desc() { return this.cafe.desc() + ' + Extra Shot'; }
}

module.exports = { Cafe, CafeSimple, CafeDecorator, Leche, Azucar, ExtraShot };
