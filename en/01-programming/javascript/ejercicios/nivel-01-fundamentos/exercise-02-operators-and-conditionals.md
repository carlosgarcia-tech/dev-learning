# Exercise 02 — Operators and Conditionals

- **Level:** 1/5
- **Topic:** Arithmetic, comparison, `if`/`else`, ternary
- **Estimated time:** 15 min

## Statement

Write a "discount calculator". Given a product `price` (number) and a `student` flag (boolean):

1. If the price is greater than 100 and the buyer is a student, apply a 20% discount.
2. Otherwise, if the price is greater than 100, apply a 10% discount.
3. Otherwise there is no discount.
4. Compute the final price and print both the discount percentage and the final price.
5. Use a ternary expression to build a `message` that says `"Student discount"`, `"Loyalty discount"`, or `"No discount"` depending on the same rules.

Example output for `price = 120`, `student = true`:

```text
Discount: 20%
Final price: 96
Message: Student discount
```

Test with at least three cases by changing the values (e.g. `120`/`true`, `120`/`false`, `50`/`true`).

## Requirements

- [ ] Uses strict comparison (`===`) at least once somewhere in the logic
- [ ] Uses `if`/`else if`/`else`
- [ ] Uses the ternary operator for the message
- [ ] Computes the final price correctly with a single-digit percentage (use whole numbers)
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- A 20% discount means the final price is `price * 0.8`.
- Order the conditions so the most specific one (student + expensive) comes first.
- The ternary can return a string: `const message = cond ? "A" : "B";`

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function applyDiscount(price, student) {
  let discount = 0;

  if (price > 100 && student === true) {
    discount = 20;
  } else if (price > 100) {
    discount = 10;
  } else {
    discount = 0;
  }

  const finalPrice = price - (price * discount) / 100;
  const message =
    discount === 20
      ? "Student discount"
      : discount === 10
        ? "Loyalty discount"
        : "No discount";

  console.log(`Price: ${price}, student: ${student}`);
  console.log(`Discount: ${discount}%`);
  console.log(`Final price: ${finalPrice}`);
  console.log(`Message: ${message}`);
  console.log("---");
}

applyDiscount(120, true);
applyDiscount(120, false);
applyDiscount(50, true);
````

</details>