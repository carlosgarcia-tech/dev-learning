# Ejercicio 04 — Clases con tipos

- **Nivel:** 2/5
- **Tema:** `class`, modificadores de acceso, métodos tipados, herencia
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `clases.ts` que:

1. Defina una clase `Cuenta` con una propiedad privada `saldo` (number, inicializada en 0) y una propiedad pública `titular` (string).
2. Añada métodos tipados `depositar(cantidad: number): void`, `retirar(cantidad: number): boolean` (false si no hay saldo) y `getSaldo(): number`.
3. Defina una clase `CuentaAhorro extends Cuenta` que añada una propiedad pública `interes` (number) y un método `aplicarInteres(): void` que multiplique el saldo por `(1 + interes)`.
4. Realice operaciones y compruebe que `saldo` no es accesible desde fuera.
5. Imprima el estado de ambas cuentas.

Salida esperada (ejemplo):

```
Saldo inicial: 0
Deposito 100
Retiro de 50: true
Saldo: 50
CuentaAhorro: titular Ana, saldo 115, interes 0.15
Retiro de 999: false
```

## Requisitos

- [ ] Usar `private` para encapsular el saldo y `public` para el titular.
- [ ] Implementar métodos con parámetros y retornos tipados.
- [ ] Heredar con `extends` y añadir miembros nuevos.
- [ ] Demostrar en un comentario que `cuenta.saldo` no es accesible.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist clases.ts` y luego `node dist/clases.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `private saldo: number = 0;` se declara como propiedad de la clase.
- `retirar` devuelve `boolean` y usa `if (cantidad > this.saldo) return false;`.
- Para leer el saldo desde fuera usa el getter `getSaldo()`.
- En `aplicarInteres`, usa `this.getSaldo()` (no `this.saldo`) o define el método en la misma clase.
- Comentario de ejemplo: `// cuenta.saldo; // ERROR: saldo es private`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist clases.ts && node dist/clases.js
class Cuenta {
  private saldo: number = 0;

  constructor(public titular: string) {}

  depositar(cantidad: number): void {
    this.saldo += cantidad;
  }

  retirar(cantidad: number): boolean {
    if (cantidad > this.saldo) {
      return false;
    }
    this.saldo -= cantidad;
    return true;
  }

  getSaldo(): number {
    return this.saldo;
  }
}

class CuentaAhorro extends Cuenta {
  constructor(titular: string, public interes: number) {
    super(titular);
  }

  aplicarInteres(): void {
    this.depositar(this.getSaldo() * this.interes);
  }
}

const cuenta = new Cuenta("Luis");
console.log(`Saldo inicial: ${cuenta.getSaldo()}`);
cuenta.depositar(100);
console.log("Deposito 100");
console.log(`Retiro de 50: ${cuenta.retirar(50)}`);
console.log(`Saldo: ${cuenta.getSaldo()}`);

const ahorro = new CuentaAhorro("Ana", 0.15);
ahorro.depositar(100);
ahorro.aplicarInteres();
console.log(`CuentaAhorro: titular ${ahorro.titular}, saldo ${ahorro.getSaldo()}, interes ${ahorro.interes}`);
console.log(`Retiro de 999: ${cuenta.retirar(999)}`);

// cuenta.saldo; // ERROR: la propiedad saldo es privada (private)
````

</details>