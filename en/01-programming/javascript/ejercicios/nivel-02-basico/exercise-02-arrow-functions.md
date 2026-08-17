# Exercise 02 — Arrow Functions

- **Level:** 2/5
- **Topic:** Arrow functions, implicit return
- **Estimated time:** 15 min

## Statement

Rewrite the following code using arrow functions where possible.

1. `isEven(n)` — arrow that returns `true` if `n` is even (implicit return, single expression).
2. `greet(name)` — arrow with a default parameter and a block body that returns `` `Hello, ${name}!` ``.
3. `doubleAll(arr)` — arrow that returns a new array where every number is doubled, using `.map()` with a nested arrow.
4. `firstLetters(words)` — arrow returning an array of the first letters of each word.

Print:

```text
isEven(4) = true
isEven(7) = false
greet() = Hello, world!
greet('Ada') = Hello, Ada!
doubleAll([1,2,3]) = [2,4,6]
firstLetters(['apple','banana']) = ['a','b']
```

## Requirements

- [ ] Uses at least one arrow with implicit return (no `{}`/`return`)
- [ ] Uses at least one arrow with a block body and explicit `return`
- [ ] Uses an arrow inside `.map()`
- [ ] Uses a default parameter in an arrow
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Implicit return only works with a single expression: `const isEven = (n) => n % 2 === 0;`
- With `{ }` you must write `return` yourself.
- For first letters: `word[0]` on each element of `words`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const isEven = (n) => n % 2 === 0;

const greet = (name = "world") => {
  return `Hello, ${name}!`;
};

const doubleAll = (arr) => arr.map((n) => n * 2);

const firstLetters = (words) => words.map((word) => word[0]);

console.log(`isEven(4) = ${isEven(4)}`);
console.log(`isEven(7) = ${isEven(7)}`);
console.log(`greet() = ${greet()}`);
console.log(`greet('Ada') = ${greet("Ada")}`);
console.log(`doubleAll([1,2,3]) = ${JSON.stringify(doubleAll([1, 2, 3]))}`);
console.log(`firstLetters(['apple','banana']) = ${JSON.stringify(firstLetters(["apple", "banana"]))}`);
````

</details>