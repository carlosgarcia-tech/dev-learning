# 01 — JavaScript Fundamentals

## Goals

- [ ] Use `let`, `const`, and `var` and explain the difference between them
- [ ] Identify the primitive types and how `typeof` reports them
- [ ] Build strings with concatenation and template literals
- [ ] Use arithmetic, comparison, and logical operators
- [ ] Write `if`/`else if`/`else` and the ternary operator
- [ ] Write `for`, `while`, and `for...of` loops

## Notes

### Variables

- `let` declares a variable you can reassign.
- `const` declares a constant you cannot reassign (the value can still be *mutated* for objects/arrays).
- `var` is the old way: function-scoped, hoisted, and should be avoided in modern code.
- A variable name can't start with a digit and can't be a reserved keyword. Use `camelCase`.

### Types

JavaScript has 8 types. The primitives are:

| Type | Example | `typeof` |
|------|---------|----------|
| `string` | `"hi"`, `'hi'`, `` `hi` `` | `"string"` |
| `number` | `42`, `3.14`, `NaN`, `Infinity` | `"number"` |
| `boolean` | `true`, `false` | `"boolean"` |
| `undefined` | `let x;` | `"undefined"` |
| `null` | `null` | `"object"` (a historical bug) |
| `symbol` | `Symbol("id")` | `"symbol"` |
| `bigint` | `10n` | `"bigint"` |

Plus one non-primitive: `object` (includes arrays, functions, `Date`, etc.). `typeof` on `null` returns `"object"` — that's a long-standing quirk, not a bug you should rely on.

### Template literals

Backticks let you embed expressions with `${}` and write multi-line strings without `\n`.

```js
const name = "Ada";
const age = 36;
console.log(`${name} is ${age} years old.`);
```

### Operators

- Arithmetic: `+ - * / % **`
- Comparison: `==` (loose), `===` (strict, recommended), `!=`, `!==`, `<`, `>`, `<=`, `>=`
- Logical: `&&` (and), `||` (or), `!` (not)
- Assignment: `=`, `+=`, `-=`, `*=`, `/=`

### Conditionals

`if`/`else if`/`else` works as expected. The ternary operator `cond ? a : b` is a short expression form. Falsy values: `false`, `0`, `""`, `null`, `undefined`, `NaN` — everything else is truthy.

### Loops

- `for` when you know the number of iterations.
- `while` when you loop until a condition becomes false.
- `for...of` to iterate values of an array, string, or `Set`.
- Avoid `for...in` for arrays; it iterates keys (including inherited ones).

## Code examples

```javascript
const price = 19.99;
let quantity = 3;
let total = price * quantity; // 59.97

if (total > 50) {
  console.log("You get free shipping!");
} else {
  console.log("Shipping costs $4.99");
}

const status = total > 50 ? "free" : "paid";
console.log(`Shipping status: ${status}`);

for (let i = 1; i <= 3; i++) {
  console.log(`Attempt ${i}`);
}

let n = 0;
while (n < 3) {
  n++;
}
console.log(n); // 3

const fruits = ["apple", "banana", "pear"];
for (const fruit of fruits) {
  console.log(fruit);
}
```

## Related exercises

- [ejercicios/nivel-01-fundamentos/](ejercicios/nivel-01-fundamentos/) — all 6 exercises of level 1 use this guide.

## Common mistakes

- Using `==` instead of `===` — `1 == "1"` is `true`, which hides bugs.
- Reassigning a `const` — throws `TypeError: Assignment to constant variable`.
- Expecting `typeof null === "null"` — it returns `"object"`.
- Comparing strings with `<` and `>` thinking it's numeric — it's lexicographic (alphabetical).
- Using `var` in a block and expecting it to be block-scoped.
- Off-by-one in `for` loops (`i <= arr.length` reads past the end).

## Resources

- [MDN: JavaScript first steps](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting)
- [MDN: Grammar and types](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Grammar_and_types)
- [JavaScript.info: Fundamentals](https://javascript.info/first-steps)
- `node -p` to quickly evaluate expressions: `node -p "typeof 42"`