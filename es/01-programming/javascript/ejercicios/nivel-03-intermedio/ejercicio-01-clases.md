# Ejercicio 01 — Clases

- **Nivel:** 3/5
- **Tema:** class, herencia, getters/setters
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `clases.js` que:

1. Defina una clase `Animal` con constructor que reciba `nombre` y `sonido`. Debe tener un método `hablar()` que devuelva `"<nombre> hace <sonido>"`.
2. Añada un **getter** `descripcion` que devuelva `"Animal llamado <nombre>"`, y un **setter** `nombre` que valide que el valor no esté vacío (si está vacío, lance un `Error`).
3. Defina una clase `Perro` que **extienda** `Animal`, con constructor que reciba `nombre` y añada `raza`. Sobrescriba `hablar()` para que devuelva `"<nombre> ladra: ¡Guau!"`.
4. Cree una instancia de `Perro`, imprima su `descripcion`, su `hablar()`, y pruebe el setter con un nombre vacío dentro de try/catch.

Salida esperada:

```
descripcion: Animal llamado Rex
Rex ladra: ¡Guau!
Rex hace ¡Guau! (llamando al método del padre con super)
setter: Error: El nombre no puede estar vacío
```

## Requisitos

- [ ] Usar `class`, `constructor` y `extends`.
- [ ] Implementar al menos un getter y un setter con validación.
- [ ] Llamar al método del padre con `super.metodo()`.
- [ ] Ejecutarlo localmente con `node clases.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-01-clases.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Getter: `get descripcion() { return ...; }` — se accede sin paréntesis: `perro.descripcion`.
- Setter: `set nombre(valor) { if (!valor) throw new Error(...); this._nombre = valor; }`.
- En la clase hija: `constructor(nombre, raza) { super(nombre, "¡Guau!"); this.raza = raza; }`.
- Para usar el método del padre dentro del hijo: `super.hablar()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
class Animal {
  constructor(nombre, sonido) {
    this._nombre = nombre;
    this._sonido = sonido;
  }

  get nombre() {
    return this._nombre;
  }

  set nombre(valor) {
    if (!valor || valor.trim() === "") {
      throw new Error("El nombre no puede estar vacío");
    }
    this._nombre = valor;
  }

  get descripcion() {
    return `Animal llamado ${this._nombre}`;
  }

  hablar() {
    return `${this._nombre} hace ${this._sonido}`;
  }
}

class Perro extends Animal {
  constructor(nombre, raza) {
    super(nombre, "¡Guau!");
    this.raza = raza;
  }

  hablar() {
    return `${this._nombre} ladra: ${super.hablar()}`;
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
````

</details>