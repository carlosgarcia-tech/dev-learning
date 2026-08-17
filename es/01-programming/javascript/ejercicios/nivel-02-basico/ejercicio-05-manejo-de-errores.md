# Ejercicio 05 — Manejo de errores

- **Nivel:** 2/5
- **Tema:** try/catch/throw
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `errores.js` que:

1. Defina una función `raizCuadrada(n)` que lance un `Error` con mensaje `"No existe raíz cuadrada de un número negativo"` si `n < 0`, y que devuelva `Math.sqrt(n)` en caso contrario.
2. Defina una función `parsearJSON(texto)` que intente `JSON.parse(texto)` y, si falla, lance un `Error` con mensaje `"JSON inválido"`.
3. En el programa principal, llame a `raizCuadrada(9)` dentro de `try` e imprima el resultado.
4. Llame a `raizCuadrada(-4)` dentro de `try/catch` e imprima `"Error: " + error.message`.
5. Llame a `parsearJSON('{"a": 1}')` y a `parsearJSON("texto roto")`, cada una en su try/catch, e imprima resultados o errores.
6. Use `finally` que imprima `"La operación terminó"` después de la llamada a `raizCuadrada(9)`.

Salida esperada:

```
raíz de 9: 3
Error: No existe raíz cuadrada de un número negativo
parseado: { a: 1 }
Error: JSON inválido
La operación terminó
```

## Requisitos

- [ ] Lanzar errores con `throw new Error(...)`.
- [ ] Capturar con `try/catch` e imprimir `error.message`.
- [ ] Usar `finally` en al menos una llamada.
- [ ] Ejecutarlo localmente con `node errores.js` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `throw new Error("mensaje")` lanza una excepción.
- `JSON.parse` lanza `SyntaxError` con texto inválido; captúralo con try/catch.
- `finally` se ejecuta siempre, incluso si hubo o no error.
- En el catch, el parámetro suele llamarse `e` o `error`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function raizCuadrada(n) {
  if (n < 0) {
    throw new Error("No existe raíz cuadrada de un número negativo");
  }
  return Math.sqrt(n);
}

function parsearJSON(texto) {
  try {
    return JSON.parse(texto);
  } catch {
    throw new Error("JSON inválido");
  }
}

try {
  console.log(`raíz de 9: ${raizCuadrada(9)}`);
} finally {
  console.log("La operación terminó");
}

try {
  raizCuadrada(-4);
} catch (error) {
  console.log(`Error: ${error.message}`);
}

try {
  console.log(`parseado: ${parsearJSON('{"a": 1}')}`);
} catch (error) {
  console.log(`Error: ${error.message}`);
}

try {
  parsearJSON("texto roto");
} catch (error) {
  console.log(`Error: ${error.message}`);
}
````

</details>