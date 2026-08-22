# Ejercicio 05 — Aplicar Open/Closed

- **Nivel:** 1/5
- **Tema:** Open/Closed Principle (OCP)
- **Tiempo estimado:** 25 min

## Enunciado

Tienes una función `precioFinal(tipo, base)` con una cascada de `if` por tipo de descuento. Cada vez que añades un descuento nuevo, modificas la función (violando OCP). Tu tarea es **refactorizar** a un diseño **abierto a extensión, cerrado a modificación**.

El archivo `solucion.js` debe contener:

- Una clase base `Descuento` con método `aplicar(base)`.
- Descuentos concretos: `SinDescuento`, `DescuentoVIP`, `DescuentoBlackFriday`.
- Una función `precioFinal(descuento, base)` que **no** cambia al añadir nuevos descuentos.
- Una clase `Carrito` que acepta un descuento y calcula el total.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.js` con polimorfismo (sin cascadas de `if`).
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define la clase base `Descuento` con método `aplicar(base)`
- [ ] `solucion.js` define `SinDescuento`, `DescuentoVIP`, `DescuentoBlackFriday`
- [ ] La función `precioFinal(descuento, base)` NO contiene `if` por tipo
- [ ] Añadir un descuento nuevo NO requiere tocar `precioFinal` (OCP)
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El truco del OCP: `precioFinal` recibe un **objeto con método `aplicar`**, no un string `tipo`.
- Así, `precioFinal` no sabe qué descuento es; solo lo aplica. Añadir `DescuentoNavidad` no la toca.
- `DescuentoVIP.aplicar(base) = base * 0.8` (20% off).
- `DescuentoBlackFriday.aplicar(base) = base * 0.5` (50% off).
- `SinDescuento.aplicar(base) = base`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
