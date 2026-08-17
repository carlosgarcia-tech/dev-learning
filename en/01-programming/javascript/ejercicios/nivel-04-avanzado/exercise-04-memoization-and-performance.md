# Exercise 04 — Memoization and Performance

- **Level:** 4/5
- **Topic:** Debounce, throttle, performance
- **Estimated time:** 25 min

## Statement

Implement `debounce` and `throttle` from scratch, plus a `measure` helper that times a function.

1. `debounce(fn, wait)` — returns a wrapped function that postpones calling `fn` until `wait` ms have passed without a new call. Every call cancels the previous timer.
2. `throttle(fn, limit)` — returns a wrapped function that calls `fn` at most once every `limit` ms (leading edge).
3. `measure(fn)` — calls `fn` and returns `{ result, ms }`.
4. Demonstrate with an `async` runner that paces the calls with real `delay(10)` gaps (this keeps the timing deterministic despite machine load):

```javascript
const slowAdd = (a, b) => { /* small busy loop */ return a + b; };
```

- Call the *debounced* version 5 times in a row with 10 ms gaps and `wait = 100`: only **one** invocation should actually run (count real calls with a counter).
- Call the *throttled* version 9 times in a row with 10 ms gaps and `limit = 50`: **two** invocations should run (the leading one, then another once 50 ms have elapsed).
- Use `measure` on `slowAdd(2, 3)` and print `result` and `ms`.

Expected output shape:

```text
debounced real calls: 1
throttled real calls: 2
slowAdd(2,3) = 5 in ~5ms
```

## Requirements

- [ ] Implements `debounce` with `setTimeout`/`clearTimeout`
- [ ] Implements `throttle` tracking the last run time
- [ ] Counts real invocations to prove the behavior
- [ ] Implements `measure` with `Date.now()` or `performance.now()`
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Debounce: `clearTimeout(this.timer); this.timer = setTimeout(() => fn(...args), wait);`
- Throttle: if `Date.now() - last >= limit`, run now and set `last = Date.now()`.
- Drive the demo with `setTimeout` and `.then` after the timers resolve.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function debounce(fn, wait) {
  let timer = null;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), wait);
  };
}

function throttle(fn, limit) {
  let last = 0;
  return (...args) => {
    const now = Date.now();
    if (now - last >= limit) {
      last = now;
      fn(...args);
    }
  };
}

function measure(fn) {
  const start = Date.now();
  const result = fn();
  return { result, ms: Date.now() - start };
}

function slowAdd(a, b) {
  let x = 0;
  for (let i = 0; i < 1_000_000; i++) x += i;
  return a + b;
}

function runDemo() {
  const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

  (async () => {
    let debouncedCalls = 0;
    const debounced = debounce(() => debouncedCalls++, 100);

    for (let i = 0; i < 5; i++) {
      debounced();
      await delay(10);
    }
    await delay(120); // let the trailing debounce fire

    let throttledCalls = 0;
    const throttled = throttle(() => throttledCalls++, 50);

    for (let i = 0; i < 9; i++) {
      throttled();
      await delay(10);
    }

    console.log(`debounced real calls: ${debouncedCalls}`);
    console.log(`throttled real calls: ${throttledCalls}`);
  })();

  const { result, ms } = measure(() => slowAdd(2, 3));
  console.log(`slowAdd(2,3) = ${result} in ~${ms}ms`);
}

runDemo();
````

</details>