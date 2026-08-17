# Exercise 03 — Array Methods

- **Level:** 2/5
- **Topic:** `map`, `filter`, `find`
- **Estimated time:** 15 min

## Statement

Given the array of products:

```javascript
const products = [
  { name: "Laptop", price: 899, inStock: true },
  { name: "Mouse", price: 25, inStock: false },
  { name: "Keyboard", price: 60, inStock: true },
  { name: "Monitor", price: 240, inStock: true },
];
```

Build a program that:

1. Uses `map` to create an array `names` of just the product names.
2. Uses `filter` to create `available` with only products where `inStock` is `true`.
3. Uses `filter` to create `cheap` with products whose `price < 100`.
4. Uses `find` to get the first product named `"Monitor"`, and print its price.
5. Uses `find` to look for `"Tablet"` and print what it returns (it won't exist).
6. Uses `map` to add a `withTax` field (price * 1.21 rounded to 2 decimals) and print the first element.

Print the results with `console.log`.

## Requirements

- [ ] Uses `map` twice (names, withTax)
- [ ] Uses `filter` twice (inStock, cheap)
- [ ] Uses `find` twice (existing and missing item)
- [ ] Does not mutate the original `products` array
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- `map`/`filter`/`find` never change the original array.
- `find` returns `undefined` when nothing matches — that is the expected result for "Tablet".
- Rounding: `Math.round(x * 100) / 100`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
const products = [
  { name: "Laptop", price: 899, inStock: true },
  { name: "Mouse", price: 25, inStock: false },
  { name: "Keyboard", price: 60, inStock: true },
  { name: "Monitor", price: 240, inStock: true },
];

const names = products.map((p) => p.name);
console.log("names:", names);

const available = products.filter((p) => p.inStock);
console.log("available:", available.map((p) => p.name));

const cheap = products.filter((p) => p.price < 100);
console.log("cheap:", cheap.map((p) => p.name));

const monitor = products.find((p) => p.name === "Monitor");
console.log("monitor price:", monitor.price);

const tablet = products.find((p) => p.name === "Tablet");
console.log("tablet:", tablet);

const withTax = products.map((p) => ({
  ...p,
  withTax: Math.round(p.price * 1.21 * 100) / 100,
}));
console.log("first withTax:", withTax[0]);
````

</details>