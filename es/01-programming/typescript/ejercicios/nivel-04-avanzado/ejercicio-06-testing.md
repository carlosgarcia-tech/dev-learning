# Ejercicio 06 — Testing con node:assert

- **Nivel:** 4/5
- **Tema:** `node:assert/strict`, pruebas unitarias tipadas, casos de éxito y error
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `testing.ts` que:

1. Defina `sumar(a: number, b: number): number` y `dividir(a: number, b: number): number` (que **lance** `Error` si `b === 0`).
2. Escriba una función `ejecutarPruebas` que corra **3 pruebas** usando `node:assert/strict`:
   - `sumar(2, 3)` es `5`.
   - `dividir(10, 4)` es `2.5`.
   - `dividir(1, 0)` lanza un error con mensaje `"No se puede dividir entre cero"` (usa `assert.throws`).
3. Imprima `✓` por cada prueba que pase y, si alguna falla, capture el error con try/catch e imprima el mensaje.
4. Al final, imprima un resumen: `X de 3 pruebas pasaron`.

Salida esperada (ejemplo):

```
✓ sumar(2, 3) === 5
✓ dividir(10, 4) === 2.5
✓ dividir(1, 0) lanza
2 de 3 pruebas pasaron
```

## Requisitos

- [ ] Importar `node:assert/strict` con `import assert from "node:assert/strict";`.
- [ ] Usar `assert.strictEqual` y `assert.throws` con un mensaje verificado.
- [ ] Envolver cada prueba en try/catch para no detener la ejecución.
- [ ] Llevar un contador de pruebas pasadas y falladas.
- [ ] Ejecutarlo localmente con `npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist testing.ts` y luego `node dist/testing.js`, y verificar la salida.
- [ ] Nota: para que los tipos de Node funcionen es necesario tener instalado `@types/node` (incluido normalmente como dependencia de desarrollo).

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `assert.throws(fn, /regex/)` comprueba que la función lanza y que el mensaje coincide con la expresión regular.
- El contador: `let pasadas = 0;` y dentro del try `pasadas++;`.
- Si usas `--strict` y módulos NodeNext, recuerda terminar los imports relativos con `.js` (no aplica aquí, solo importas `node:assert`).
- Ejemplo de verificación de mensaje: `assert.throws(() => dividir(1, 0), /cero/)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist testing.ts && node dist/testing.js
import assert from "node:assert/strict";

function sumar(a: number, b: number): number {
  return a + b;
}

function dividir(a: number, b: number): number {
  if (b === 0) {
    throw new Error("No se puede dividir entre cero");
  }
  return a / b;
}

function ejecutarPruebas(): void {
  let pasadas = 0;
  const total = 3;

  try {
    assert.strictEqual(sumar(2, 3), 5);
    pasadas++;
    console.log("✓ sumar(2, 3) === 5");
  } catch (e) {
    console.log(`✗ sumar(2, 3): ${e instanceof Error ? e.message : String(e)}`);
  }

  try {
    assert.strictEqual(dividir(10, 4), 2.5);
    pasadas++;
    console.log("✓ dividir(10, 4) === 2.5");
  } catch (e) {
    console.log(`✗ dividir(10, 4): ${e instanceof Error ? e.message : String(e)}`);
  }

  try {
    assert.throws(() => dividir(1, 0), /No se puede dividir entre cero/);
    pasadas++;
    console.log("✓ dividir(1, 0) lanza");
  } catch (e) {
    console.log(`✗ dividir(1, 0): ${e instanceof Error ? e.message : String(e)}`);
  }

  console.log(`${pasadas} de ${total} pruebas pasaron`);
}

ejecutarPruebas();
````

</details>