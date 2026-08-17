# Exercise 02 — Recursion and Memoization

- **Level:** 3/5
- **Topic:** Recursion, memoization
- **Estimated time:** 20 min

## Statement

Implement the Fibonacci sequence in three ways and compare:

1. `fibRecursive(n)` — classic recursion. `fib(0)=0`, `fib(1)=1`, `fib(n)=fib(n-1)+fib(n-2)`.
2. `createFibMemo()` — returns a memoized version of `fibRecursive` using a `Map` cache. It must still be a function you can call as `fibMemo(n)`.
3. `fibIterative(n)` — iterative version using a loop.

Write a small runner that:

- Prints `fibRecursive(10)` and `fibIterative(10)` (both must be `55`).
- Prints the number of function calls made by `fibRecursive` via a counter, for `n = 10` (count only within the recursive function).
- Prints the number of *computations* (cache misses) made by the memoized version for `n = 30` and then again for `n = 30` — the second call should make 0 new computations because every value is already cached.

Print a note about time complexity: recursive is O(2^n), memoized and iterative are O(n).

## Requirements

- [ ] Implements pure recursion
- [ ] Implements memoization with a `Map`
- [ ] Implements an iterative version
- [ ] Counts computations (cache misses) to prove memoization works (second run = 0 new computations)
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Put the cache *inside* the closure factory so each instance has its own cache.
- Memoized: `if (cache.has(n)) return cache.get(n); const result = fibMemo(n-1) + fibMemo(n-2); cache.set(n, result); return result;`
- Count calls with a variable tracked by the closure.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
let recursiveCalls = 0;
function fibRecursive(n) {
  recursiveCalls++;
  if (n <= 1) return n;
  return fibRecursive(n - 1) + fibRecursive(n - 2);
}

function createFibMemo() {
  const cache = new Map();
  let computations = 0;

  function fib(n) {
    if (cache.has(n)) return cache.get(n);
    computations++;
    if (n <= 1) {
      cache.set(n, n);
      return n;
    }
    const result = fib(n - 1) + fib(n - 2);
    cache.set(n, result);
    return result;
  }

  fib.getComputations = () => computations;
  return fib;
}

function fibIterative(n) {
  if (n <= 1) return n;
  let prev = 0;
  let curr = 1;
  for (let i = 2; i <= n; i++) {
    [prev, curr] = [curr, prev + curr];
  }
  return curr;
}

recursiveCalls = 0;
console.log(`fibRecursive(10) = ${fibRecursive(10)} (calls: ${recursiveCalls})`);
console.log(`fibIterative(10) = ${fibIterative(10)}`);

const fibMemo = createFibMemo();
const first = fibMemo(30);
const afterFirst = fibMemo.getComputations();
const second = fibMemo(30);
const afterSecond = fibMemo.getComputations();

console.log(`fibMemo(30) = ${first}`);
console.log(`computations after first run: ${afterFirst}`);
console.log(`computations after second run: ${afterSecond} (new: ${afterSecond - afterFirst})`);

console.log("Complexity: recursive O(2^n), memoized and iterative O(n)");
````

</details>