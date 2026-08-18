class Animal {
  constructor(nombre, sonido) {
    // TODO: guarda this._nombre y this._sonido.
    throw new Error("TODO: implementar el constructor de Animal");
  }

  get nombre() {
    // TODO: devuelve this._nombre.
    throw new Error("TODO: implementar el getter nombre");
  }

  set nombre(valor) {
    // TODO: valida que no esté vacío; si lo está, lanza Error.
    throw new Error("TODO: implementar el setter nombre");
  }

  get descripcion() {
    // TODO: devuelve "Animal llamado <nombre>".
    throw new Error("TODO: implementar el getter descripcion");
  }

  hablar() {
    // TODO: devuelve "<nombre> hace <sonido>".
    throw new Error("TODO: implementar hablar()");
  }
}

class Perro extends Animal {
  constructor(nombre, raza) {
    // TODO: llama a super(nombre, "¡Guau!") y guarda this.raza.
    throw new Error("TODO: implementar el constructor de Perro");
  }

  hablar() {
    // TODO: devuelve "<nombre> ladra: " + super.hablar().
    throw new Error("TODO: implementar Perro.hablar()");
  }
}

if (require.main === module) {
  const rex = new Perro("Rex", "Labrador");
  console.log(`descripcion: ${rex.descripcion}`);
  console.log(`hablar: ${rex.hablar()}`);
  try {
    rex.nombre = "";
  } catch (error) {
    console.log(`setter: Error: ${error.message}`);
  }
}

module.exports = { Animal, Perro };
