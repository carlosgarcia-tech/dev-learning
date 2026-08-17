# Exercise 05 — Error Handling

- **Level:** 2/5
- **Topic:** `try`/`catch`/`throw`
- **Estimated time:** 15 min

## Statement

Write a `divide(a, b)` function that:

1. Throws an `Error` with message `"Division by zero"` if `b === 0`.
2. Throws a `TypeError` with message `"Both arguments must be numbers"` if either argument is not a number (check with `typeof`).
3. Otherwise returns `a / b`.

Write a `safeDivide` helper that calls `divide` inside a `try`/`catch` and returns `null` on failure.

Then, in a `try`/`catch`/`finally` block, call `safeDivide` with these inputs and print the result or error name/message:

- `divide(10, 2)` → `5`
- `safeDivide(10, 0)` → `null` (and `finally` still runs)
- `safeDivide("x", 2)` → `null`

Finally, demonstrate `finally` by printing `"finally ran"` once per attempt.

## Requirements

- [ ] Throws with `throw new Error(...)` and `throw new TypeError(...)`
- [ ] Validates types with `typeof`
- [ ] Uses `try`/`catch` to convert errors into `null`
- [ ] Uses `finally` and shows it always runs
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Guard `b === 0` before the type check or after — pick one order and be consistent.
- `catch (err)` gives you `err.name` and `err.message`.
- `finally` runs even after `return` inside `try`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function divide(a, b) {
  if (typeof a !== "number" || typeof b !== "number") {
    throw new TypeError("Both arguments must be numbers");
  }
  if (b === 0) {
    throw new Error("Division by zero");
  }
  return a / b;
}

function safeDivide(a, b) {
  try {
    return divide(a, b);
  } catch (err) {
    console.log(`caught ${err.name}: ${err.message}`);
    return null;
  } finally {
    console.log("finally ran");
  }
}

try {
  console.log(`divide(10, 2) = ${divide(10, 2)}`);
} finally {
  console.log("finally ran");
}

console.log(`safeDivide(10, 0) = ${safeDivide(10, 0)}`);
console.log(`safeDivide("x", 2) = ${safeDivide("x", 2)}`);
````

</details>