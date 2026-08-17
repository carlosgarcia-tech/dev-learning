# Exercise 05 — Loops

- **Level:** 1/5
- **Topic:** `for`, `while`, `for...of`
- **Estimated time:** 15 min

## Statement

Write a program that prints numbers using the three main loop styles.

1. With a `for` loop, print the numbers from 1 to 5.
2. With a `while` loop, count down from 5 to 1.
3. With a `for...of` loop, iterate over the array `["apple", "banana", "cherry"]` and print each item preceded by `"Fruit: "`.
4. In the `for` loop, accumulate the sum of 1..5 into a `let total` and print it after the loop.

Expected output:

```text
for: 1 2 3 4 5
sum 1..5 = 15
while: 5 4 3 2 1
Fruit: apple
Fruit: banana
Fruit: cherry
```

## Requirements

- [ ] Uses `for`, `while`, and `for...of` each at least once
- [ ] Accumulates a sum inside the `for` loop
- [ ] Does not modify the original array
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `for (let i = 1; i <= 5; i++)` runs with `i` = 1,2,3,4,5.
- For the countdown: start at 5 and decrement while `i >= 1`.
- `for...of` gives you each *value* directly: `for (const fruit of fruits)`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
let total = 0;
for (let i = 1; i <= 5; i++) {
  process.stdout.write(i + " ");
  total += i;
}
console.log();
console.log(`sum 1..5 = ${total}`);

let n = 5;
while (n >= 1) {
  process.stdout.write(n + " ");
  n--;
}
console.log();

const fruits = ["apple", "banana", "cherry"];
for (const fruit of fruits) {
  console.log(`Fruit: ${fruit}`);
}
````

</details>