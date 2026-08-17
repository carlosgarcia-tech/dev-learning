# Ejercicio 05 — Testing con assert

- **Nivel:** 4/5
- **Tema:** node:assert, pruebas unitarias simples
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `testing.js` que:

1. Importe el módulo nativo `node:assert` con `const assert = require("node:assert");`.
2. Defina funciones puras para probar:
   - `sumar(a, b)` → `a + b`.
   - `esPalindromo(texto)` → `true` si el texto es igual al revés (ignorando mayúsculas y espacios).
   - `dividir(a, b)` → `a / b`, lanzando `Error` si `b === 0`.
3. Escriba "pruebas" con `assert.strictEqual` y `assert.throws`:
   - `assert.strictEqual(sumar(2, 3), 5)`.
   - `assert.strictEqual(sumar(-1, 1), 0)`.
   - `assert.strictEqual(esPalindromo("reconocer"), true)`.
   - `assert.strictEqual(esPalindromo("Hola"), false)`.
   - `assert.throws(() => dividir(1, 0), /cero/)`.
   - `assert.strictEqual(dividir(10, 2), 5)`.
4. Imprima `"Todas las pruebas pasaron ✅"` solo si ninguna aserción lanzó error (usa try/catch para capturar el primero).

Salida esperada:

```
Prueba 1: sumar(2, 3) === 5 -> OK
Prueba 2: sumar(-1, 1) === 0 -> OK
Prueba 3: esPalindromo("reconocer") === true -> OK
Prueba 4: esPalindromo("Hola") === false -> OK
Prueba 5: dividir(1, 0) lanza error -> OK
Prueba 6: dividir(10, 2) === 5 -> OK
Todas las pruebas pasaron
```

## Requisitos

- [ ] Usar el módulo `node:assert` (no una librería externa).
- [ ] Probar casos válidos e inválidos (incluido `assert.throws`).
- [ ] Que el script falle con un mensaje claro si una aserción no se cumple.
- [ ] Ejecutarlo localmente con `node testing.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-05-testing-con-assert.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `assert.strictEqual(valor, esperado)` lanza `AssertionError` si no son estrictamente iguales.
- `assert.throws(fn, /regex/)` comprueba que `fn` lance un error cuyo mensaje coincide con la regex.
- Un palíndromo: `texto.toLowerCase().split("").reverse().join("") === texto.toLowerCase()`.
- Envuelve cada prueba en try/catch para imprimir `OK` o el mensaje de error.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function sumar(a, b) {
  return a + b;
}

function esPalindromo(texto) {
  const limpio = texto.toLowerCase();
  return limpio === limpio.split("").reverse().join("");
}

function dividir(a, b) {
  if (b === 0) {
    throw new Error("No se puede dividir entre cero");
  }
  return a / b;
}

function probar(nombre, fn) {
  try {
    fn();
    console.log(`Prueba: ${nombre} -> OK`);
  } catch (error) {
    console.error(`Prueba: ${nombre} -> FALLO: ${error.message}`);
    process.exit(1);
  }
}

if (require.main === module) {
  const assert = require("node:assert");
  probar("sumar(2, 3) === 5", () => assert.strictEqual(sumar(2, 3), 5));
  probar("sumar(-1, 1) === 0", () => assert.strictEqual(sumar(-1, 1), 0));
  probar('esPalindromo("reconocer") === true', () =>
    assert.strictEqual(esPalindromo("reconocer"), true)
  );
  probar('esPalindromo("Hola") === false', () =>
    assert.strictEqual(esPalindromo("Hola"), false)
  );
  probar("dividir(1, 0) lanza error", () =>
    assert.throws(() => dividir(1, 0), /cero/)
  );
  probar("dividir(10, 2) === 5", () => assert.strictEqual(dividir(10, 2), 5));
  console.log("Todas las pruebas pasaron");
}

module.exports = { sumar, esPalindromo, dividir, probar };
````

</details>