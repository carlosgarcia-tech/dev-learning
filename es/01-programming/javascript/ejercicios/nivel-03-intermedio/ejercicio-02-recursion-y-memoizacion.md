# Ejercicio 02 — Recursión y memoización

- **Nivel:** 3/5
- **Tema:** Recursión, memoización
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `recursion.js` que:

1. Implemente `factorial(n)` de forma **recursiva** (caso base `n <= 1` → 1).
2. Implemente `fibonacci(n)` de forma recursiva (casos base: `fib(0) = 0`, `fib(1) = 1`).
3. Implemente una versión **memoizada** de `fibonacci` llamada `fibMemo(n)` que guarde resultados ya calculados en un objeto/caché para evitar recalcular.
4. Imprima `factorial(5)`, `fibonacci(10)` y `fibMemo(40)`, y una comparación de cuántas veces se llamó la versión sin memoización.

Salida esperada:

```
factorial(5): 120
fibonacci(10): 55
fibonacci llama 177 veces sin memoizar
fibMemo(40): 102334155
```

## Requisitos

- [ ] Funciones recursivas con caso base claro.
- [ ] La versión memoizada debe ser notablemente más rápida para `n` grandes.
- [ ] Contar las llamadas de la versión sin memoizar con un contador.
- [ ] Ejecutarlo localmente con `node recursion.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-02-recursion-y-memoizacion.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Recursión: la función se llama a sí misma con un problema más pequeño.
- La memoización consulta primero el caché: `if (n in cache) return cache[n];`.
- `fib(10) = 55`, `fib(40) = 102334155` te sirven para verificar.
- `fibonacci` sin memoización tiene complejidad exponencial; a partir de `n ≈ 40` se nota mucho.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function factorial(n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

function fibonacci(n) {
  if (n === 0) return 0;
  if (n === 1) return 1;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

function fibMemo(n, cache = {}) {
  if (n === 0) return 0;
  if (n === 1) return 1;
  if (n in cache) return cache[n];
  cache[n] = fibMemo(n - 1, cache) + fibMemo(n - 2, cache);
  return cache[n];
}

if (require.main === module) {
  let llamadas = 0;
  function contarFibonacci(n) {
    llamadas++;
    if (n === 0) return 0;
    if (n === 1) return 1;
    return contarFibonacci(n - 1) + contarFibonacci(n - 2);
  }
  console.log(`factorial(5): ${factorial(5)}`);
  console.log(`fibonacci(10): ${fibonacci(10)}`);
  console.log(`fibonacci llama ${llamadas} veces sin memoizar`);
  console.log(`fibMemo(40): ${fibMemo(40)}`);
}

module.exports = { factorial, fibonacci, fibMemo };
````

</details>