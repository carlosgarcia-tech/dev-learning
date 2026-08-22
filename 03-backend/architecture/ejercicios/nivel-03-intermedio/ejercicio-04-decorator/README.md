# Ejercicio 04 — Implementar Decorator

- **Nivel:** 3/5
- **Tema:** Patrón Decorator (composición de comportamientos)
- **Tiempo estimado:** 30 min

## Enunciado

Implementa decoradores para un `Cafe` base: quieres añadir leche, azúcar y extra shot de forma **combinable** sin herencia múltiple. Cada decorador envuelve a otro `Cafe` y le suma coste y descripción.

El archivo `solucion.js` debe contener:

- Una clase base `Cafe` con métodos `coste()` y `desc()`.
- `CafeSimple` (café base, 2€).
- Un decorador base `CafeDecorator` que envuelve un `Cafe` y delega.
- Decoradores concretos: `Leche` (+0.5), `Azucar` (+0.2), `ExtraShot` (+0.8).

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.js`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `Cafe` con `coste()` y `desc()`
- [ ] `solucion.js` define `CafeSimple` (café base)
- [ ] `solucion.js` define `CafeDecorator` que envuelve un `Cafe`
- [ ] `solucion.js` define `Leche`, `Azucar`, `ExtraShot` que extienden `CafeDecorator`
- [ ] Los decoradores se pueden combinar anidándolos
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `CafeDecorator.__init__(cafe) { this.cafe = cafe; }` y delega: `coste() { return this.cafe.coste(); }`.
- `Leche.coste() { return this.cafe.coste() + 0.5; }` y `desc() { return this.cafe.desc() + ' + Leche'; }`.
- Combinar: `new Azucar(new Leche(new CafeSimple()))` → 2 + 0.5 + 0.2 = 2.7.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
