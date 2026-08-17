# Exercise 03 — Common Table Expressions (CTEs)

- **Level:** 3/5
- **Topic:** WITH, recursive-friendly queries
- **Estimated time:** 25 min

## Statement

Using a CTE (`WITH`), write a query that:

1. Computes, in a CTE, the total revenue per category.
2. Then returns all products whose price is **above the average price of the
   products table** — but expressed through a second CTE that reuses the first.

Expected result: Monitor (180) and Keyboard (25) — both above the average of
22.5. The `USBCable` (8) is below.

## Initial schema

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  price REAL NOT NULL
);

INSERT INTO products (name, category, price) VALUES
  ('Keyboard', 'Accessories', 25.0),
  ('Mouse',    'Accessories', 15.0),
  ('Monitor',  'Screens',     180.0),
  ('USB Cable','Accessories', 8.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: Define the average inside a CTE: `WITH avg_price AS (SELECT AVG(price) AS a FROM products)`.
- Hint 2: Reference it in the main query: `WHERE price > (SELECT a FROM avg_price)`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
WITH avg_price AS (
  SELECT AVG(price) AS average_price FROM products
)
SELECT name, price
FROM products, avg_price
WHERE price > avg_price.average_price;
````

</details>