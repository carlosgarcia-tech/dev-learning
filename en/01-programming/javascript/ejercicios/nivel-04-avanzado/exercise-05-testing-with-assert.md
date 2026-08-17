# Exercise 05 — Testing with Assert

- **Level:** 4/5
- **Topic:** `node:assert`, unit tests
- **Estimated time:** 20 min

## Statement

Write a small test suite for a `calculator` module using only the built-in `node:assert` module. Do not use any test framework.

Implement these functions in the same file:

- `add(a, b)` — sum.
- `subtract(a, b)` — difference.
- `multiply(a, b)` — product.
- `divide(a, b)` — throws `Error("Division by zero")` when `b === 0`, otherwise quotient.

Write a helper `test(name, fn)` that runs `fn`, catches assertion errors, and reports `PASS`/`FAIL`. Track and print a summary: `3 passed, 1 failed` (make one test intentionally fail by asserting a wrong value, then comment it out or keep it to show the FAIL line).

Use `assert.strictEqual` for exact equality and `assert.throws` to check thrown errors. Validate the thrown error with a regex on the message.

Expected output:

```text
PASS add(2,3) === 5
PASS divide throws on zero
PASS multiply(4,5) === 20
FAIL subtract(10,4) === 7  (expected 7, got 6)
3 passed, 1 failed
```

## Requirements

- [ ] Uses `require("node:assert")` (or `import` with `node:assert`)
- [ ] Uses `assert.strictEqual` at least twice
- [ ] Uses `assert.throws` with a message regex
- [ ] Implements a `test` helper that reports PASS/FAIL
- [ ] Prints a passing/failing summary
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `assert.throws(fn, /Division by zero/)` checks both the throw and the message.
- Wrap the assertion in a function passed to the helper: `test("name", () => assert.strictEqual(add(2,3), 5))`.
- Catch with `catch (err) { fail(); }` — but re-throw non-assertion errors.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const assert = require("node:assert");

function add(a, b) {
  return a + b;
}
function subtract(a, b) {
  return a - b;
}
function multiply(a, b) {
  return a * b;
}
function divide(a, b) {
  if (b === 0) throw new Error("Division by zero");
  return a / b;
}

let passed = 0;
let failed = 0;

function test(name, fn) {
  try {
    fn();
    passed++;
    console.log(`PASS ${name}`);
  } catch (err) {
    failed++;
    console.log(`FAIL ${name}  (${err.message})`);
  }
}

test("add(2,3) === 5", () => assert.strictEqual(add(2, 3), 5));
test("subtract(10,4) === 6", () => assert.strictEqual(subtract(10, 4), 6));
test("multiply(4,5) === 20", () => assert.strictEqual(multiply(4, 5), 20));
test("divide(10,2) === 5", () => assert.strictEqual(divide(10, 2), 5));
test("divide throws on zero", () => assert.throws(() => divide(10, 0), /Division by zero/));

console.log(`${passed} passed, ${failed} failed`);
````

</details>