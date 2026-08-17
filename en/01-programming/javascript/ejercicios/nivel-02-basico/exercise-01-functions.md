# Exercise 01 — Functions

- **Level:** 2/5
- **Topic:** Function declarations, parameters, return
- **Estimated time:** 15 min

## Statement

Write four functions to build a small math toolkit:

1. `add(a, b)` — declaration, returns `a + b`.
2. `multiply(a, b)` — expression assigned to a `const`, returns `a * b`.
3. `square(n)` — declaration with a default parameter `n = 0`, returns `n * n`.
4. `max(...nums)` — accepts any number of arguments and returns the largest (assume at least one argument; handle the empty case by returning `undefined`).

Print the result of each call:

```text
add(2, 3) = 5
multiply(4, 5) = 20
square() = 0
square(7) = 49
max(1, 9, 3) = 9
max(42) = 42
max() = undefined
```

## Requirements

- [ ] Uses a function declaration, a function expression, and a default parameter
- [ ] Uses rest parameters `...nums`
- [ ] Returns values (no side-effect-only functions)
- [ ] Handles the empty case of `max` returning `undefined`
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- A function expression: `const multiply = function (a, b) { return a * b; };`
- Default parameters kick in when the argument is `undefined`: `function square(n = 0)`.
- For `max`, iterate `...nums` with a loop or `Math.max(...nums)` — but note `Math.max()` with no args returns `-Infinity`, so guard the empty case.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function add(a, b) {
  return a + b;
}

const multiply = function (a, b) {
  return a * b;
};

function square(n = 0) {
  return n * n;
}

function max(...nums) {
  if (nums.length === 0) return undefined;
  return Math.max(...nums);
}

console.log(`add(2, 3) = ${add(2, 3)}`);
console.log(`multiply(4, 5) = ${multiply(4, 5)}`);
console.log(`square() = ${square()}`);
console.log(`square(7) = ${square(7)}`);
console.log(`max(1, 9, 3) = ${max(1, 9, 3)}`);
console.log(`max(42) = ${max(42)}`);
console.log(`max() = ${max()}`);
````

</details>