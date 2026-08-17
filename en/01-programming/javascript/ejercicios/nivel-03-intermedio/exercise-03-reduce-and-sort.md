# Exercise 03 — Reduce and Sort

- **Level:** 3/5
- **Topic:** `reduce`, `sort`, grouping
- **Estimated time:** 20 min

## Statement

Given the array of orders:

```javascript
const orders = [
  { product: "apple", qty: 3, price: 1.5 },
  { product: "banana", qty: 2, price: 0.8 },
  { product: "apple", qty: 2, price: 1.5 },
  { product: "orange", qty: 5, price: 2.0 },
  { product: "banana", qty: 1, price: 0.8 },
];
```

Build:

1. `totalRevenue` — `reduce` that sums `qty * price` for all orders, rounded to 2 decimals (should be 19.9).
2. `grouped` — `reduce` that groups orders by product into an object: `{ apple: [...], banana: [...], orange: [...] }`.
3. `quantityByProduct` — `reduce` returning `{ apple: 5, banana: 3, orange: 5 }` (sum of `qty` per product).
4. `sortedByName` — `sort` the **product names** alphabetically (create a unique list first).
5. `cheapestFirst` — `sort` a copy of `orders` by `price` ascending (do not mutate the original).

Print each result. Then print the original array to prove it was not mutated.

## Requirements

- [ ] Uses `reduce` three times with different accumulator shapes (number, object of arrays, object of quantities)
- [ ] Uses `sort` for strings and for numbers
- [ ] Sorts a copy, leaving the original array untouched
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- Grouping with reduce: start from `{}` and use `acc[item.product] = acc[item.product] ?? []` then push.
- Always copy before sorting: `[...orders].sort(...)`.
- For numeric sort: `(a, b) => a.price - b.price`. For strings: `a.localeCompare(b)`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const orders = [
  { product: "apple", qty: 3, price: 1.5 },
  { product: "banana", qty: 2, price: 0.8 },
  { product: "apple", qty: 2, price: 1.5 },
  { product: "orange", qty: 5, price: 2.0 },
  { product: "banana", qty: 1, price: 0.8 },
];

const totalRevenue = Math.round(orders.reduce((acc, o) => acc + o.qty * o.price, 0) * 100) / 100;
console.log("totalRevenue:", totalRevenue);

const grouped = orders.reduce((acc, o) => {
  (acc[o.product] ??= []).push(o);
  return acc;
}, {});
console.log("grouped:", JSON.stringify(grouped, null, 2));

const quantityByProduct = orders.reduce((acc, o) => {
  acc[o.product] = (acc[o.product] ?? 0) + o.qty;
  return acc;
}, {});
console.log("quantityByProduct:", quantityByProduct);

const sortedByName = Object.keys(quantityByProduct).sort((a, b) => a.localeCompare(b));
console.log("sortedByName:", sortedByName);

const cheapestFirst = [...orders].sort((a, b) => a.price - b.price);
console.log("cheapestFirst:", cheapestFirst.map((o) => `${o.product}:${o.price}`));

console.log("original (must be unchanged):", orders.map((o) => `${o.product}:${o.price}`).join(", "));
````

</details>