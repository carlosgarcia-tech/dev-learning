# Exercise 02 — WHERE and ORDER BY

- **Level:** 1/5
- **Topic:** Filtering and sorting
- **Estimated time:** 15 min

## Statement

Using the `products` table, write a query that returns the **name** and
**price** of all products whose price is **greater than 20**, sorted from
**most expensive to cheapest**. Then write a second query that returns the
three cheapest products.

Expected result (first query): three rows, sorted descending by price.
Expected result (second query): exactly three rows with the lowest prices.

## Initial schema

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  price REAL NOT NULL
);

INSERT INTO products (name, price) VALUES
  ('Keyboard', 25.0),
  ('Mouse', 15.0),
  ('Monitor', 180.0),
  ('USB Cable', 8.0),
  ('Laptop Stand', 35.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `WHERE price > 20` filters; `ORDER BY price DESC` sorts descending.
- Hint 2: `ORDER BY price ASC LIMIT 3` gives the three cheapest.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
SELECT name, price
FROM products
WHERE price > 20
ORDER BY price DESC;

SELECT name, price
FROM products
ORDER BY price ASC
LIMIT 3;
````

</details>