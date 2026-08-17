# 04 — Async / Await

## Goals

- [ ] Explain the difference between synchronous and asynchronous code
- [ ] Use callbacks and identify the "callback hell" problem
- [ ] Create promises with `new Promise` and consume them with `.then` / `.catch`
- [ ] Rewrite promise chains with `async` / `await`
- [ ] Run tasks in parallel with `Promise.all` / `Promise.allSettled`
- [ ] Use `fetch` and handle async errors with `try` / `catch` / `finally`

## Notes

### The event loop in one paragraph

Node.js runs JavaScript on a single thread. Slow operations (timers, network, disk) are delegated to the system, and their callbacks run later on the event loop. That is why `setTimeout(..., 0)` fires *after* the synchronous code finishes.

### Callbacks

A callback is a function passed to another function to run when an async operation finishes. Nesting many callbacks produces deeply indented, hard-to-read code ("callback hell" or the "pyramid of doom").

### Promises

A promise is an object representing a future value. It has three states: `pending`, `fulfilled`, and `rejected`. Once settled it never changes.

```javascript
const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
delay(1000).then(() => console.log("1 second passed"));
```

- `.then(onFulfilled, onRejected)` runs when fulfilled (or rejected).
- `.catch(fn)` catches errors anywhere earlier in the chain.
- `.finally(fn)` runs regardless of success or failure.
- Errors and rejections propagate down the chain until caught.

### async / await

`async` functions always return a promise. Inside them, `await` pauses execution until a promise settles — without blocking the event loop. `await` only works inside `async` functions (or at the top level of modules).

### Parallel execution

- `Promise.all([...])` — waits for all; rejects fast if any rejects.
- `Promise.allSettled([...])` — waits for all and reports each outcome, never rejects.
- `Promise.race([...])` — settles with the first promise to settle.
- `Promise.any([...])` — settles with the first *fulfilled* one.

### fetch

`fetch(url, options)` is a promise-based HTTP client available in Node 18+. It resolves with a `Response`; call `res.json()` (also a promise) to read the body.

### Async error handling

`try` / `catch` around `await` is the idiomatic way. Because `await` unwraps rejections, a rejected promise throws like a synchronous error inside the `try` block.

## Code examples

```javascript
// Promise chain
fetch("https://jsonplaceholder.typicode.com/users/1")
  .then((res) => res.json())
  .then((user) => console.log(user.name))
  .catch((err) => console.error("Request failed:", err));

// Same thing with async/await + try/catch/finally
async function loadUser() {
  try {
    const res = await fetch("https://jsonplaceholder.typicode.com/users/1");
    const user = await res.json();
    console.log(user.name);
  } catch (err) {
    console.error("Request failed:", err);
  } finally {
    console.log("Done");
  }
}

// Parallel requests
const [a, b] = await Promise.all([
  fetch("https://jsonplaceholder.typicode.com/users/1").then((r) => r.json()),
  fetch("https://jsonplaceholder.typicode.com/users/2").then((r) => r.json()),
]);
```

## Related exercises

- [nivel-03-intermedio/exercise-04-callbacks.md](ejercicios/nivel-03-intermedio/exercise-04-callbacks.md)
- [nivel-03-intermedio/exercise-05-promises.md](ejercicios/nivel-03-intermedio/exercise-05-promises.md)
- [nivel-04-avanzado/exercise-01-async-await.md](ejercicios/nivel-04-avanzado/exercise-01-async-await.md)
- [nivel-04-avanzado/exercise-02-fetch-and-json.md](ejercicios/nivel-04-avanzado/exercise-02-fetch-and-json.md)

## Common mistakes

- Calling `await` outside an `async` function (throws `SyntaxError`).
- Forgetting to `await` a promise (or the promise returned by `res.json()`).
- Using `Promise.all` when a failure should still let the others finish — use `allSettled`.
- Not catching — an unhandled promise rejection can crash Node or print scary warnings.
- Wrapping a promise in another promise needlessly (`await` already unwraps).
- Forgetting that `async` functions *always* return a promise, so callers must `await` them too.

## Resources

- [MDN: Using promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises)
- [MDN: async function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)
- [MDN: Promise.all](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)
- [MDN: fetch()](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
- [Node.js: Event loop](https://nodejs.org/en/learn/asynchronous-work/event-loop-timers-and-nexttick)