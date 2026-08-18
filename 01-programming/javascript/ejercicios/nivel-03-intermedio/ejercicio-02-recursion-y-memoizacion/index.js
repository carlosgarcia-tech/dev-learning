function factorial(n) {
  // TODO: recursivo, caso base n <= 1 -> 1.
  throw new Error("TODO: implementar factorial(n)");
}

function fibonacci(n) {
  // TODO: recursivo, fib(0)=0, fib(1)=1.
  throw new Error("TODO: implementar fibonacci(n)");
}

function fibMemo(n, cache = {}) {
  // TODO: recursivo con caché para evitar recalcular.
  throw new Error("TODO: implementar fibMemo(n, cache)");
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
